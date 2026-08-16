import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import 'package:url_launcher/url_launcher.dart';

import '../theme/app_colors.dart';
import '../theme/common_methods.dart';
import '../../../features/orders/domain/entities/order_entity.dart';
import '../utility/dependency_injection.dart';
import '../../../features/auth/bloc/auth_bloc.dart';
import '../../../features/auth/bloc/auth_state.dart';
import '../utils/snackbar_utils.dart';
import 'whatsapp_template_service.dart';
import '../../../features/orders/data/datasources/lookup_remote_data_source.dart';

class ReceiptPdfService {
  /// Generates PDF receipt byte data dynamically based on the user's shop details
  static Future<Uint8List> generateReceiptPdf(
    OrderEntity order, {
    String? shopName,
    String? shopAddress,
    String? shopPhone,
  }) async {
    final pdf = pw.Document();

    // Fetch dynamic shop details from AuthBloc if available
    String resolvedShopName = shopName ?? 'My Tailoring Store';
    String resolvedShopAddress = shopAddress ?? '';
    String resolvedShopPhone = shopPhone ?? '';

    try {
      if (getIt.isRegistered<AuthBloc>()) {
        final authState = getIt<AuthBloc>().state;
        if (authState is AuthAuthenticated && authState.user.shop != null) {
          final s = authState.user.shop!;
          if (s.name.isNotEmpty) resolvedShopName = s.name;
          if (s.address.isNotEmpty) resolvedShopAddress = s.address;
        }
      }
    } catch (_) {}

    final orderShortId = order.id.length > 6 ? order.id.substring(0, 6).toUpperCase() : order.id.toUpperCase();
    final receiptNo = 'RCPT-${order.createdAt.year}-$orderShortId';
    final formattedDate = DateFormat('dd MMM yyyy, h:mm a').format(order.createdAt);
    final font = await PdfGoogleFonts.poppinsRegular();
    final fontBold = await PdfGoogleFonts.poppinsBold();

    // Calculate subtotal from items or total amount
    double calculatedSubtotal = 0;
    final List<Map<String, dynamic>> itemsList = [];

    if (order.items.isNotEmpty) {
      for (final item in order.items) {
        final itemTotal = item.unitPrice * item.quantity > 0
            ? item.unitPrice * item.quantity
            : (order.garmentPrices[item.garmentName] ?? order.totalAmount);
        calculatedSubtotal += itemTotal;
        itemsList.add({
          'name': item.garmentName,
          'qty': item.quantity,
          'price': itemTotal,
        });
      }
    } else if (order.garmentTypes.isNotEmpty) {
      for (final garment in order.garmentTypes) {
        final qty = order.garmentQuantities[garment] ?? 1;
        final itemTotal = order.garmentPrices[garment] ?? (order.totalAmount / order.garmentTypes.length);
        calculatedSubtotal += itemTotal;

        itemsList.add({
          'name': garment,
          'qty': qty,
          'price': itemTotal,
        });
      }
    } else {
      calculatedSubtotal = order.totalAmount;
      itemsList.add({
        'name': 'Custom Tailoring Service',
        'qty': 1,
        'price': order.totalAmount,
      });
    }

    final double discount = (calculatedSubtotal - order.totalAmount).clamp(0, double.infinity);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // ── Header Branding ──
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text(
                      resolvedShopName.toUpperCase(),
                      style: pw.TextStyle(
                        font: fontBold,
                        fontSize: 18,
                        letterSpacing: 2,
                        color: PdfColors.grey900,
                      ),
                    ),
                    if (resolvedShopAddress.isNotEmpty) ...[
                      pw.SizedBox(height: 4),
                      pw.Text(
                        resolvedShopAddress,
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.grey700),
                      ),
                    ],
                    if (resolvedShopPhone.isNotEmpty) ...[
                      pw.SizedBox(height: 2),
                      pw.Text(
                        resolvedShopPhone,
                        style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.grey700),
                      ),
                    ],
                  ],
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Divider(color: PdfColors.grey300, thickness: 0.8),
              pw.SizedBox(height: 16),

              // ── Payment Receipt & Receipt Info Row ──
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'PAYMENT RECEIPT',
                    style: pw.TextStyle(
                      font: fontBold,
                      fontSize: 14,
                      letterSpacing: 1.5,
                      color: PdfColors.grey900,
                    ),
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'RECEIPT NUMBER',
                        style: pw.TextStyle(
                          font: font,
                          fontSize: 8,
                          letterSpacing: 0.8,
                          color: PdfColors.grey600,
                        ),
                      ),
                      pw.SizedBox(height: 2),
                      pw.Text(
                        receiptNo,
                        style: pw.TextStyle(font: fontBold, fontSize: 11, color: PdfColors.grey900),
                      ),
                      pw.SizedBox(height: 2),
                      pw.Text(
                        formattedDate,
                        style: pw.TextStyle(font: font, fontSize: 9, color: PdfColors.grey600),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20),

              // ── Bill To & Order Details Banner Card ──
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: const pw.BoxDecoration(
                  color: PdfColor.fromInt(0xFFF8F9FA),
                  borderRadius: pw.BorderRadius.all(pw.Radius.circular(6)),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'BILL TO',
                          style: pw.TextStyle(
                            font: font,
                            fontSize: 8,
                            letterSpacing: 0.8,
                            color: PdfColors.grey600,
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          order.customerName ?? 'Customer',
                          style: pw.TextStyle(
                            font: fontBold,
                            fontSize: 11,
                            color: PdfColors.grey900,
                          ),
                        ),
                        if (order.customerPhone != null && order.customerPhone!.isNotEmpty)
                          pw.Text(
                            order.customerPhone!,
                            style: pw.TextStyle(
                              font: font,
                              fontSize: 10,
                              color: PdfColors.grey700,
                            ),
                          ),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          'ORDER DETAILS',
                          style: pw.TextStyle(
                            font: font,
                            fontSize: 8,
                            letterSpacing: 0.8,
                            color: PdfColors.grey600,
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          'Order #ORD-$orderShortId',
                          style: pw.TextStyle(
                            font: fontBold,
                            fontSize: 11,
                            color: PdfColors.grey900,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 24),

              // ── Garments / Items Table ──
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Expanded(
                    flex: 5,
                    child: pw.Text(
                      'ITEM',
                      style: pw.TextStyle(
                        font: font,
                        fontSize: 8,
                        letterSpacing: 0.8,
                        color: PdfColors.grey600,
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      'QTY',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        font: font,
                        fontSize: 8,
                        letterSpacing: 0.8,
                        color: PdfColors.grey600,
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 3,
                    child: pw.Text(
                      'AMOUNT',
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(
                        font: font,
                        fontSize: 8,
                        letterSpacing: 0.8,
                        color: PdfColors.grey600,
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 6),
              pw.Divider(color: PdfColors.grey300, thickness: 0.8),
              pw.SizedBox(height: 8),

              ...itemsList.map((item) {
                return pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 6),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Expanded(
                        flex: 5,
                        child: pw.Text(
                          item['name'] as String,
                          style: pw.TextStyle(
                            font: fontBold,
                            fontSize: 10,
                            color: PdfColors.grey900,
                          ),
                        ),
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Text(
                          '${item['qty']}',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            font: fontBold,
                            fontSize: 10,
                            color: PdfColors.grey900,
                          ),
                        ),
                      ),
                      pw.Expanded(
                        flex: 3,
                        child: pw.Text(
                          'INR ${(item['price'] as double).toStringAsFixed(0)}',
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            font: fontBold,
                            fontSize: 10,
                            color: PdfColors.grey900,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              pw.Spacer(),

              // ── Summary & Totals Block (Right Aligned) ──
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Container(
                    width: 220,
                    child: pw.Column(
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              'Subtotal',
                              style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.grey700),
                            ),
                            pw.Text(
                              'INR ${calculatedSubtotal.toStringAsFixed(0)}',
                              style: pw.TextStyle(font: fontBold, fontSize: 10, color: PdfColors.grey900),
                            ),
                          ],
                        ),
                        if (discount > 0) ...[
                          pw.SizedBox(height: 4),
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text(
                                'Discount',
                                style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.red700),
                              ),
                              pw.Text(
                                '-INR ${discount.toStringAsFixed(0)}',
                                style: pw.TextStyle(font: fontBold, fontSize: 10, color: PdfColors.red700),
                              ),
                            ],
                          ),
                        ],
                        pw.SizedBox(height: 8),
                        pw.Divider(color: PdfColors.grey300, thickness: 0.8),
                        pw.SizedBox(height: 8),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              'TOTAL',
                              style: pw.TextStyle(
                                font: fontBold,
                                fontSize: 12,
                                letterSpacing: 0.8,
                                color: PdfColors.grey900,
                              ),
                            ),
                            pw.Text(
                              'INR ${order.totalAmount.toStringAsFixed(0)}',
                              style: pw.TextStyle(font: fontBold, fontSize: 13, color: PdfColors.grey900),
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 6),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              'AMOUNT PAID',
                              style: pw.TextStyle(
                                font: font,
                                fontSize: 9,
                                letterSpacing: 0.5,
                                color: PdfColors.grey600,
                              ),
                            ),
                            pw.Text(
                              'INR ${order.advancePaid.toStringAsFixed(0)}',
                              style: pw.TextStyle(font: fontBold, fontSize: 10, color: PdfColors.grey700),
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 12),

                        // Dark Balance Due Pill Box
                        pw.Container(
                          width: double.infinity,
                          padding: const pw.EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: pw.BoxDecoration(
                            color: const PdfColor.fromInt(0xFF18221F),
                            borderRadius: pw.BorderRadius.circular(8),
                          ),
                          child: pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text(
                                'Balance Due',
                                style: pw.TextStyle(
                                  font: font,
                                  fontSize: 11,
                                  color: PdfColors.white,
                                ),
                              ),
                              pw.Text(
                                'INR ${order.balanceDue.toStringAsFixed(0)}',
                                style: pw.TextStyle(
                                  font: fontBold,
                                  fontSize: 13,
                                  color: PdfColors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  /// Default predefined message template — short, clean, no dashed lines or long itemized lists
  static String getDefaultWhatsAppText(OrderEntity order) {
    String name = 'Tailor & Co.';
    try {
      if (getIt.isRegistered<AuthBloc>()) {
        final authState = getIt<AuthBloc>().state;
        if (authState is AuthAuthenticated && authState.user.shop != null) {
          if (authState.user.shop!.name.isNotEmpty) name = authState.user.shop!.name;
        }
      }
    } catch (_) {}

    final orderShortId = order.id.length > 6 ? order.id.substring(0, 6).toUpperCase() : order.id.toUpperCase();
    final custName = order.customerName ?? 'Customer';
    final deliveryText = order.deliveryDate != null
        ? '${order.deliveryDate!.day}/${order.deliveryDate!.month}/${order.deliveryDate!.year}'
        : 'To be confirmed';

    return '''Hello $custName! 👋
Thank you for your order with $name.

Order #ORD-$orderShortId
Delivery Date: $deliveryText
Paid: ₹${order.advancePaid.toStringAsFixed(0)} | Balance Due: ₹${order.balanceDue.toStringAsFixed(0)}

Attached is your PDF receipt. Thank you!''';
  }

  /// Copies message to Clipboard and opens PDF file share directly
  static Future<void> shareReceipt({
    required OrderEntity order,
    required String customMessage,
  }) async {
    // 1. Copy text to clipboard so user can paste it into WhatsApp directly
    await Clipboard.setData(ClipboardData(text: customMessage));

    // 2. Generate PDF file
    final pdfBytes = await generateReceiptPdf(order);
    final tempDir = await getTemporaryDirectory();
    final orderShortId = order.id.length > 6 ? order.id.substring(0, 6).toUpperCase() : order.id.toUpperCase();
    final file = File('${tempDir.path}/Receipt_ORD_$orderShortId.pdf');
    await file.writeAsBytes(pdfBytes);

    final xFile = XFile(file.path);

    // 3. Trigger PDF file share directly
    await Share.shareXFiles([xFile], text: customMessage);
  }

  /// Displays the interactive multi-template WhatsApp Message Bottom Sheet
  static void showWhatsAppReceiptBottomSheet(
    BuildContext context,
    OrderEntity order, {
    WhatsAppTemplateType? initialTemplate,
  }) {
    // 1. Asynchronously fetch latest cloud master templates from Supabase
    try {
      if (getIt.isRegistered<LookupRemoteDataSource>()) {
        getIt<LookupRemoteDataSource>().getWhatsAppMasterTemplates().then((cloudMap) {
          if (cloudMap.isNotEmpty) {
            WhatsAppTemplateService.updateCloudMasterTemplates(cloudMap);
          }
        });
      }
    } catch (_) {}

    final c = getThemeBaseColors(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final options = WhatsAppTemplateService.getAvailableOptions();
    final defaultType = initialTemplate ?? WhatsAppTemplateService.getRecommendedTemplateForOrder(order);

    final phoneController = TextEditingController(
      text: order.customerPhone ?? 'No Phone Number',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? c.cardDark : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(ctx).size.height * 0.90,
          ),
          child: _WhatsAppMessageOptionsSheet(
            order: order,
            options: options,
            initialType: defaultType,
            phoneController: phoneController,
            c: c,
            isDark: isDark,
          ),
        );
      },
    );
  }
}

class _WhatsAppMessageOptionsSheet extends StatefulWidget {
  final OrderEntity order;
  final List<WhatsAppTemplateOption> options;
  final WhatsAppTemplateType initialType;
  final TextEditingController phoneController;
  final AppColorScheme c;
  final bool isDark;

  const _WhatsAppMessageOptionsSheet({
    required this.order,
    required this.options,
    required this.initialType,
    required this.phoneController,
    required this.c,
    required this.isDark,
  });

  @override
  State<_WhatsAppMessageOptionsSheet> createState() => _WhatsAppMessageOptionsSheetState();
}

class _WhatsAppMessageOptionsSheetState extends State<_WhatsAppMessageOptionsSheet> {
  late WhatsAppTemplateType _selectedType;
  late TextEditingController _messageController;
  late bool _attachPdf;
  late bool _hasLocalOverride;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialType;
    final initialOption = widget.options.firstWhere(
      (o) => o.type == _selectedType,
      orElse: () => widget.options.first,
    );
    _attachPdf = initialOption.defaultAttachPdf;
    _hasLocalOverride = WhatsAppTemplateService.hasLocalUserOverride(_selectedType);
    _messageController = TextEditingController(
      text: WhatsAppTemplateService.generateMessageText(type: _selectedType, order: widget.order),
    );

    Future.microtask(() async {
      try {
        if (getIt.isRegistered<LookupRemoteDataSource>()) {
          final cloudMap = await getIt<LookupRemoteDataSource>().getWhatsAppMasterTemplates();
          if (cloudMap.isNotEmpty) {
            await WhatsAppTemplateService.updateCloudMasterTemplates(cloudMap);
            if (mounted && _messageController.text.isEmpty) {
              setState(() {
                _messageController.text = WhatsAppTemplateService.generateMessageText(
                  type: _selectedType,
                  order: widget.order,
                );
              });
            }
          }
        }
      } catch (_) {}
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _onSelectTemplate(WhatsAppTemplateOption option) {
    setState(() {
      _selectedType = option.type;
      _attachPdf = option.defaultAttachPdf;
      _hasLocalOverride = WhatsAppTemplateService.hasLocalUserOverride(option.type);
      _messageController.text = WhatsAppTemplateService.generateMessageText(
        type: option.type,
        order: widget.order,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final recommendedType = WhatsAppTemplateService.getRecommendedTemplateForOrder(widget.order);

    final orderShortId = widget.order.orderNumber != null
        ? '${widget.order.orderNumber}'
        : (widget.order.id.length > 6 ? widget.order.id.substring(0, 6).toUpperCase() : widget.order.id.toUpperCase());

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          color: const Color(0xFF25D366).withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const FaIcon(FontAwesomeIcons.whatsapp, color: Color(0xFF25D366), size: 20),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'WhatsApp Customer Update',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: GoogleFonts.poppins(
                                fontSize: 15.5,
                                fontWeight: FontWeight.bold,
                                color: widget.c.textDark,
                              ),
                            ),
                            Text(
                              'Order #ORD-$orderShortId • ${widget.order.customerName ?? "Customer"}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: widget.c.gray,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, color: widget.c.gray),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Phone Field
            Row(
              children: [
                Text(
                  'Customer Phone Number',
                  style: GoogleFonts.poppins(fontSize: 11.5, fontWeight: FontWeight.w600, color: widget.c.gray),
                ),
                const SizedBox(width: 4),
                Icon(Icons.lock_outline, size: 12, color: widget.c.gray),
              ],
            ),
            const SizedBox(height: 5),
            TextField(
              controller: widget.phoneController,
              readOnly: true,
              style: GoogleFonts.poppins(fontSize: 13.5, fontWeight: FontWeight.w600, color: widget.c.textDark.withValues(alpha: 0.8)),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.phone_outlined, size: 18, color: widget.c.gray),
                filled: true,
                fillColor: widget.isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              ),
            ),
            const SizedBox(height: 14),

            // Horizontal Template Chips
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Message Type',
                  style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: widget.c.textDark),
                ),
                if (_selectedType == recommendedType)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF25D366).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, size: 11, color: Color(0xFF25D366)),
                        const SizedBox(width: 3),
                        Text(
                          'Recommended',
                          style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF25D366)),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.options.map((opt) {
                final isSelected = opt.type == _selectedType;
                return ChoiceChip(
                  showCheckmark: false,
                  avatar: Icon(
                    opt.icon,
                    size: 15,
                    color: isSelected ? Colors.white : opt.themeColor,
                  ),
                  label: Text(
                    opt.title,
                    style: GoogleFonts.poppins(
                      fontSize: 11.5,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? Colors.white : widget.c.textDark,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: const Color(0xFF25D366),
                  backgroundColor: widget.isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected ? const Color(0xFF25D366) : Colors.transparent,
                    ),
                  ),
                  onSelected: (_) => _onSelectTemplate(opt),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),

            // Attach PDF Receipt Toggle Card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: widget.isDark ? Colors.white.withValues(alpha: 0.04) : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: widget.isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey.shade200,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.picture_as_pdf, size: 18, color: widget.c.colorPrimary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Include PDF Receipt attachment',
                          style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: widget.c.textDark),
                        ),
                        Text(
                          'Shares receipt document along with text',
                          style: GoogleFonts.poppins(fontSize: 10, color: widget.c.gray),
                        ),
                      ],
                    ),
                  ),
                  Switch.adaptive(
                    value: _attachPdf,
                    activeColor: const Color(0xFF25D366),
                    onChanged: (val) {
                      setState(() {
                        _attachPdf = val;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Message Editor Header & Actions Toolbar
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Message Content',
                    style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: widget.c.textDark),
                  ),
                ),

                // Save Local Override
                InkWell(
                  onTap: () async {
                    await WhatsAppTemplateService.saveLocalUserTemplate(
                      _selectedType,
                      _messageController.text,
                    );
                    setState(() {
                      _hasLocalOverride = true;
                    });
                    if (context.mounted) {
                      showAppSnackBar(context, message: 'Template saved as your local shop default!');
                    }
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.bookmark_outline, size: 13, color: widget.c.colorPrimary),
                        const SizedBox(width: 3),
                        Text(
                          'Save Default',
                          style: GoogleFonts.poppins(fontSize: 10.5, fontWeight: FontWeight.w600, color: widget.c.colorPrimary),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 6),

                // Reset to Master DB
                if (_hasLocalOverride)
                  InkWell(
                    onTap: () async {
                      await WhatsAppTemplateService.resetLocalUserTemplate(_selectedType);
                      setState(() {
                        _hasLocalOverride = false;
                        _messageController.text = WhatsAppTemplateService.generateMessageText(
                          type: _selectedType,
                          order: widget.order,
                        );
                      });
                      if (context.mounted) {
                        showAppSnackBar(context, message: 'Reset to cloud master template');
                      }
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.refresh, size: 13, color: Colors.orange),
                          const SizedBox(width: 3),
                          Text(
                            'Reset Master',
                            style: GoogleFonts.poppins(fontSize: 10.5, fontWeight: FontWeight.w600, color: Colors.orange),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(width: 6),

                // Copy Text Button
                InkWell(
                  onTap: () async {
                    await Clipboard.setData(ClipboardData(text: _messageController.text));
                    if (context.mounted) {
                      showAppSnackBar(context, message: 'Message text copied to clipboard!');
                    }
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      color: widget.c.colorPrimary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.copy, size: 12, color: widget.c.colorPrimary),
                        const SizedBox(width: 4),
                        Text(
                          'Copy',
                          style: GoogleFonts.poppins(fontSize: 10.5, fontWeight: FontWeight.bold, color: widget.c.colorPrimary),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            TextField(
              controller: _messageController,
              minLines: 5,
              maxLines: 8,
              style: GoogleFonts.poppins(fontSize: 12.5, color: widget.c.textDark),
              decoration: InputDecoration(
                filled: true,
                fillColor: widget.isDark ? Colors.white.withValues(alpha: 0.03) : Colors.grey.shade50,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 16),

            // Main Action Buttons
            Row(
              children: [
                if (_attachPdf)
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () async {
                        final pdfBytes = await ReceiptPdfService.generateReceiptPdf(widget.order);
                        await Printing.layoutPdf(
                          onLayout: (_) => pdfBytes,
                          name: 'Receipt_ORD_${widget.order.id}',
                        );
                      },
                      icon: const Icon(Icons.picture_as_pdf, size: 17),
                      label: Text('Preview PDF', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ),
                if (_attachPdf) const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25D366),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                      if (_attachPdf) {
                        showAppSnackBar(context, message: 'Message copied! Select WhatsApp to attach PDF & send');
                        await ReceiptPdfService.shareReceipt(
                          order: widget.order,
                          customMessage: _messageController.text,
                        );
                      } else {
                        final cleanPhone = WhatsAppTemplateService.cleanPhoneNumber(widget.order.customerPhone);
                        if (cleanPhone.isNotEmpty) {
                          final encodedText = Uri.encodeComponent(_messageController.text);
                          final url = Uri.parse('https://wa.me/$cleanPhone?text=$encodedText');
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url, mode: LaunchMode.externalApplication);
                          } else {
                            if (context.mounted) {
                              showAppSnackBar(context, message: 'Could not launch WhatsApp app', isError: true);
                            }
                          }
                        } else {
                          showAppSnackBar(context, message: 'No valid phone number for WhatsApp', isError: true);
                        }
                      }
                    },
                    icon: const FaIcon(FontAwesomeIcons.whatsapp, size: 17),
                    label: Text(
                      _attachPdf ? 'Send PDF on WhatsApp' : 'Send WhatsApp Message',
                      style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
