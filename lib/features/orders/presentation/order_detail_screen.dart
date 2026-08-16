import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/snackbar_utils.dart';
import 'package:tailoring_flutter/l10n/app_localizations.dart';
import '../../../routes/app_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/common_methods.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/app_action_bar.dart';
import '../data/order_form_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/entities/order_entity.dart';
import 'bloc/order_bloc.dart';
import 'bloc/order_event.dart';
import 'bloc/order_state.dart';
import '../../../core/services/receipt_pdf_service.dart';
import '../../../core/utility/dependency_injection.dart';
import 'bloc/order_wizard_bloc.dart';
import '../data/datasources/lookup_remote_data_source.dart';
import '../data/models/payment_mode_model.dart';
import '../../templates/presentation/bloc/template_bloc.dart';
import '../../templates/presentation/bloc/template_state.dart';
import '../../payments/presentation/widgets/record_payment_sheet.dart';
import '../../payments/presentation/bloc/payment_bloc.dart';

class OrderDetailScreen extends StatefulWidget {
  final OrderEntity order;
  const OrderDetailScreen({super.key, required this.order});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late OrderEntity _order;
  late final TextEditingController _instructionsCtrl;
  late final TextEditingController _advanceCtrl;

  List<PaymentModeModel> _remotePaymentModes = [];

  static const _statuses = ['NOT STARTED', 'IN PROGRESS', 'READY', 'OVERDUE', 'DELIVERED'];

  @override
  void initState() {
    super.initState();
    _order = widget.order;
    _instructionsCtrl = TextEditingController(text: _order.specialInstructions);
    _advanceCtrl = TextEditingController(text: _order.advancePaid.toStringAsFixed(0));
    _loadPaymentModes();
  }

  Future<void> _loadPaymentModes() async {
    try {
      final modes = await getIt<LookupRemoteDataSource>().getPaymentModes();
      if (mounted && modes.isNotEmpty) {
        setState(() {
          _remotePaymentModes = modes;
        });
      }
    } catch (_) {}
  }

  String _getValueFlexible(Map<String, String> map, String key) {
    if (map.containsKey(key)) return map[key]!;
    final trimmedKey = key.trim().toLowerCase();
    for (final entry in map.entries) {
      if (entry.key.trim().toLowerCase() == trimmedKey) {
        return entry.value;
      }
    }
    return '';
  }

  int _getQtyFlexible(Map<String, int> map, String key) {
    if (map.containsKey(key)) return map[key]!;
    final trimmedKey = key.trim().toLowerCase();
    for (final entry in map.entries) {
      if (entry.key.trim().toLowerCase() == trimmedKey) {
        return entry.value;
      }
    }
    return 1;
  }

  double _getPriceFlexible(Map<String, double> map, String key) {
    if (map.containsKey(key)) return map[key]!;
    final trimmedKey = key.trim().toLowerCase();
    for (final entry in map.entries) {
      if (entry.key.trim().toLowerCase() == trimmedKey) {
        return entry.value;
      }
    }
    return 0.0;
  }

  String _getPaymentModeText(int mode) {
    final match = _remotePaymentModes.where((m) => m.id == mode).firstOrNull;
    if (match != null) return match.name;
    return getLocalizedPaymentMode(mode, AppLocalizations.of(context));
  }

  @override
  void dispose() {
    _instructionsCtrl.dispose();
    _advanceCtrl.dispose();
    super.dispose();
  }

  void _onDelete(AppColorScheme c, bool isDark) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: isDark ? c.cardDark : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(AppLocalizations.of(context).deleteOrderTitle,
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: c.textDark)),
        content: Text(
            AppLocalizations.of(context).deleteOrderConfirm(_order.customerName ?? ''),
            style: GoogleFonts.poppins(fontSize: 13, color: c.gray)),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(AppLocalizations.of(context).cancel, style: GoogleFonts.poppins(color: c.gray, fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: c.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0),
            onPressed: () {
              context.read<OrderBloc>().add(DeleteOrder(_order.id));
              context.pop();
            },
            child: Text(AppLocalizations.of(context).delete, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = getThemeBaseColors(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return BlocConsumer<OrderBloc, OrderState>(
      listener: (context, state) {
        if (state is OrderDeleteSuccess) {
          context.pop(true);
          showAppSnackBar(context, message: AppLocalizations.of(context).operationSuccessful);
        } else if (state is OrderUpdateSuccess) {
          if (state.order.id == _order.id) {
            setState(() {
              _order = state.order;
              _instructionsCtrl.text = _order.specialInstructions;
            });
          }
          showAppSnackBar(context, message: AppLocalizations.of(context).operationSuccessful);
        } else if (state is OrdersLoaded) {
          final updated = state.orders.where((e) => e.id == _order.id).firstOrNull;
          if (updated != null && updated != _order) {
            setState(() {
              _order = updated;
              _instructionsCtrl.text = _order.specialInstructions;
              _advanceCtrl.text = _order.advancePaid.toStringAsFixed(0);
            });
          }
        } else if (state is OrderError) {
          showAppSnackBar(context, message: state.message, isError: true);
        }
      },
      builder: (context, state) {
        OrderEntity o = _order;
        if (state is OrdersLoaded) {
          final updated = state.orders.where((e) => e.id == _order.id).firstOrNull;
          if (updated != null) {
            o = updated;
          }
        }
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.home);
            }
          },
          child: Scaffold(
            backgroundColor: c.background,
        body: Stack(
          children: [
            Positioned(top: 0, left: 0, right: 0,
              height: MediaQuery.of(context).size.height * 0.40,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      isDark ? c.colorPrimaryDark.withValues(alpha: 0.8) : c.colorAccent.withValues(alpha: 0.95),
                      isDark ? c.colorPrimaryDark.withValues(alpha: 0.4) : c.colorAccent.withValues(alpha: 0.2),
                      c.background.withValues(alpha: 0.0),
                    ],
                    begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            SafeArea(
              child: RefreshIndicator(
                color: c.colorPrimary,
                onRefresh: () async {
                  final bloc = context.read<OrderBloc>();
                  bloc.add(LoadOrders());
                  await bloc.stream.firstWhere(
                    (s) => s is OrdersLoaded || s is OrderError,
                  );
                },
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 120),
                  children: [
                  _buildHeader(c, o),
                  const SizedBox(height: 24),
                  _buildDeliveredPaymentPendingBanner(context, c, o),
                  _buildCustomerSection(c, isDark, o),
                  const SizedBox(height: 20),
                  _buildGarmentsSection(c, isDark, o),
                  const SizedBox(height: 20),
                  _buildScheduleSection(c, isDark, o),
                  const SizedBox(height: 20),
                  _buildPaymentSection(c, isDark, o),
                  const SizedBox(height: 28),
                  
                  AppActionBar(
                    isEditing: false,
                    editLabel: AppLocalizations.of(context).editOrder,
                    saveLabel: AppLocalizations.of(context).saveChanges,
                    onEditSaveTap: () {
                      final templateState = context.read<TemplateBloc?>()?.state;
                      final templates = templateState is TemplatesLoaded ? templateState.templates : null;

                      final resolvedGarmentTypes = o.garmentTypes.map((g) {
                        if (templates != null) {
                          final match = templates.where(
                            (t) => t.id == g || t.name == g || t.id.toLowerCase() == g.toLowerCase() || t.name.toLowerCase() == g.toLowerCase(),
                          ).firstOrNull;
                          if (match != null) return match.id;
                        }
                        final itemMatch = o.items.where((i) => (i.garmentName == g || i.templateId == g) && i.templateId != null && i.templateId!.isNotEmpty).firstOrNull;
                        if (itemMatch != null && itemMatch.templateId != null && itemMatch.templateId!.isNotEmpty) {
                          return itemMatch.templateId!;
                        }
                        return g;
                      }).toList();

                      final formData = OrderFormData(
                        isEditing: true,
                        existingOrderRef: o.id,
                        customerName: o.customerName ?? '',
                        customerPhone: o.customerPhone ?? '',
                        customerId: o.customerId,
                        garmentTypes: resolvedGarmentTypes,
                        garmentQuantities: o.garmentQuantities,
                        garmentPrices: o.garmentPrices,
                        specialInstructions: o.specialInstructions,
                        measurements: o.measurements,
                        deliveryDate: o.deliveryDate,
                        priorityIndex: o.priorityIndex,
                        assignedTailor: o.assignedTailor,
                        totalAmount: o.totalAmount,
                        advancePaid: o.advancePaid,
                        externalCharges: o.externalCharges,
                        paymentMode: o.paymentMode,
                        status: o.status,
                        measurementNotes: Map.from(o.measurementNotes),
                      );
                      getIt<OrderWizardBloc>().add(StartOrderWizard(initialData: formData));
                      context.push(AppRoutes.createOrderItems).then((refresh) {
                        if (refresh == true) {
                          if (!context.mounted) return;
                          context.read<OrderBloc>().add(LoadOrders());
                        }
                      });
                    },
                    onDeleteTap: () => _onDelete(c, isDark),
                  ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  },
);
}

  Widget _buildHeader(AppColorScheme c, OrderEntity o) {
    return Row(
      children: [
        AppBackButton(
          onTap: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.home);
            }
          },
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(AppLocalizations.of(context).orderDetailTitle.toUpperCase(),
                style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold,
                    letterSpacing: 1.2, color: c.textDark.withValues(alpha: 0.6))),
            Text(o.orderNumber != null ? '#${o.orderNumber}' : '#${o.id.length > 8 ? o.id.substring(0, 8).toUpperCase() : o.id.toUpperCase()}',
                style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold,
                    color: c.textDark, height: 1.2)),
          ]),
        ),
        GestureDetector(
          onTap: () => ReceiptPdfService.showWhatsAppReceiptBottomSheet(context, o),
          child: Container(
            width: 40, height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: const Color(0xFF25D366).withValues(alpha: 0.12),
                shape: BoxShape.circle),
            child: const Center(
              child: FaIcon(
                FontAwesomeIcons.whatsapp,
                color: Color(0xFF25D366),
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveredPaymentPendingBanner(BuildContext context, AppColorScheme c, OrderEntity o) {
    if (o.status != 'DELIVERED' || o.balanceDue <= 0) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.shade700, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.amber.shade900, size: 22),
              const SizedBox(width: 8),
              Text(
                'DELIVERED · PAYMENT PENDING',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                  color: Colors.amber.shade900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'This order has been delivered, but ₹${o.balanceDue.toStringAsFixed(2)} payment is pending.',
            style: GoogleFonts.poppins(fontSize: 13, color: c.textDark),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (ctx) => BlocProvider<PaymentBloc>(
                    create: (_) => getIt<PaymentBloc>(),
                    child: RecordPaymentSheet(order: o),
                  ),
                );
              },
              icon: const Icon(Icons.payment, size: 18),
              label: Text(
                'Record Payment (₹${o.balanceDue.toStringAsFixed(0)})',
                style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerSection(AppColorScheme c, bool isDark, OrderEntity o) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _sectionLabel(c, Icons.person_outline, AppLocalizations.of(context).customer),
      const SizedBox(height: 10),
      _card(c, isDark, child: Row(children: [
        Container(
          width: 52, height: 52,
          decoration: BoxDecoration(
              color: c.colorPrimary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14)),
          alignment: Alignment.center,
          child: Text(o.customerName != null && o.customerName!.isNotEmpty ? o.customerName![0] : '?',
              style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold,
                  color: c.colorPrimary)),
        ),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(o.customerName ?? AppLocalizations.of(context).noName,
              style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.bold,
                  color: c.textDark)),
          if (o.customerPhone != null && o.customerPhone!.isNotEmpty)
            Row(children: [
              Icon(Icons.phone_outlined, size: 13, color: c.gray),
              const SizedBox(width: 5),
              Text(o.customerPhone!,
                  style: GoogleFonts.poppins(fontSize: 13, color: c.gray)),
            ]),
          const SizedBox(height: 8),
          _statusPicker(context, c, o),
        ])),
      ])),
    ]);
  }

  void _onStatusSelected(BuildContext context, AppColorScheme c, OrderEntity o, String nextStatus) {
    if (nextStatus == 'DELIVERED' && o.balanceDue > 0) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Order Delivered',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Order #${o.id.length > 6 ? o.id.substring(0, 6) : o.id} has a pending balance of ₹${o.balanceDue.toStringAsFixed(2)}.\n\nHas the customer completed full payment?',
            style: GoogleFonts.poppins(fontSize: 13),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                final upd = o.copyWith(status: 'DELIVERED');
                context.read<OrderBloc>().add(UpdateOrder(upd));
              },
              child: Text(
                'Keep Payment Pending',
                style: GoogleFonts.poppins(color: c.gray, fontWeight: FontWeight.w600),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.pop(ctx);
                final upd = o.copyWith(status: 'DELIVERED');
                context.read<OrderBloc>().add(UpdateOrder(upd));
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (sheetCtx) => BlocProvider<PaymentBloc>(
                    create: (_) => getIt<PaymentBloc>(),
                    child: RecordPaymentSheet(order: upd),
                  ),
                );
              },
              child: Text(
                'Record Payment',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      );
    } else {
      final upd = o.copyWith(status: nextStatus);
      context.read<OrderBloc>().add(UpdateOrder(upd));
    }
  }

  Widget _statusPicker(BuildContext context, AppColorScheme c, OrderEntity o) {
    return PopupMenuButton<String>(
      onSelected: (String next) => _onStatusSelected(context, c, o, next),
      itemBuilder: (ctx) => _statuses.map((s) => PopupMenuItem(value: s, child: Text(getLocalizedStatus(s, AppLocalizations.of(context)), style: GoogleFonts.poppins(fontSize: 13)))).toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
            color: _statusBg(o.status, c),
            borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(getLocalizedStatus(o.status, AppLocalizations.of(context)),
                style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold,
                    letterSpacing: 0.4, color: _statusColor(o.status, c))),
            const SizedBox(width: 4),
            Icon(Icons.arrow_drop_down, size: 14, color: _statusColor(o.status, c)),
          ],
        ),
      ),
    );
  }

  void _openFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.92),
      builder: (ctx) => Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.broken_image_outlined, color: Colors.white54, size: 48),
                        const SizedBox(height: 8),
                        Text(
                          AppLocalizations.of(context).imageFailed,
                          style: GoogleFonts.poppins(color: Colors.white54, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: CircleAvatar(
                  backgroundColor: Colors.black54,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 20),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGarmentsSection(AppColorScheme c, bool isDark, OrderEntity o) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _sectionLabel(c, Icons.checkroom_outlined, AppLocalizations.of(context).garmentsDesign),
      const SizedBox(height: 10),
      _card(c, isDark, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (o.referenceImagePath != null && o.referenceImagePath!.isNotEmpty) ...[
          GestureDetector(
            onTap: () => _openFullScreenImage(context, o.referenceImagePath!),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: (o.referenceImagePath!.startsWith('http://') || o.referenceImagePath!.startsWith('https://'))
                      ? Image.network(
                          o.referenceImagePath!,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, _, _) => Container(
                            width: double.infinity,
                            height: 150,
                            color: c.divider.withValues(alpha: 0.1),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.broken_image_outlined, color: c.gray, size: 32),
                                const SizedBox(height: 8),
                                Text(AppLocalizations.of(context).imageFailed, style: GoogleFonts.poppins(fontSize: 12, color: c.gray)),
                              ],
                            ),
                          ),
                        )
                      : Image.file(
                          File(o.referenceImagePath!),
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, _, _) => Container(
                            width: double.infinity,
                            height: 150,
                            color: c.divider.withValues(alpha: 0.1),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.broken_image_outlined, color: c.gray, size: 32),
                                const SizedBox(height: 8),
                                Text(AppLocalizations.of(context).imageFailed, style: GoogleFonts.poppins(fontSize: 12, color: c.gray)),
                              ],
                            ),
                          ),
                        ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.zoom_in, color: Colors.white, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          'Tap to expand',
                          style: GoogleFonts.poppins(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
        if (o.garmentTypes.isNotEmpty) ...[
          _micro(c, AppLocalizations.of(context).garmentTypes.toUpperCase()),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: o.garmentTypes.map((g) {
              final tState = context.read<TemplateBloc?>()?.state;
              final tmpls = tState is TemplatesLoaded ? tState.templates : null;
              final name = resolveGarmentName(g, AppLocalizations.of(context), items: o.items, templates: tmpls);
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                    color: c.colorPrimary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: c.colorPrimary.withValues(alpha: 0.2))),
                child: Text(name, style: GoogleFonts.poppins(fontSize: 12,
                    fontWeight: FontWeight.bold, color: c.colorPrimary)),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ],
        _micro(c, AppLocalizations.of(context).specialInstructionsLabel.toUpperCase()),
        const SizedBox(height: 8),
        Text(
          o.specialInstructions.isEmpty ? '—  ${AppLocalizations.of(context).none}' : o.specialInstructions,
          style: GoogleFonts.poppins(fontSize: 14,
              color: o.specialInstructions.isEmpty ? c.gray : c.textDark,
              fontStyle: o.specialInstructions.isEmpty ? FontStyle.italic : FontStyle.normal),
        ),
        
        // Grouped Measurements & Notes
        if (o.garmentTypes.isNotEmpty) ...[
          const SizedBox(height: 24),
          _micro(c, AppLocalizations.of(context).detailsByGarment.toUpperCase()),
          const SizedBox(height: 12),
          ...o.garmentTypes.map((g) {
            final mJson = _getValueFlexible(o.measurements, g);
            final mParts = _parseMeasurements(mJson);
            final note = _getValueFlexible(o.measurementNotes, g);
            final qty = _getQtyFlexible(o.garmentQuantities, g);
            final price = _getPriceFlexible(o.garmentPrices, g);

            final tState = context.read<TemplateBloc?>()?.state;
            final tmpls = tState is TemplatesLoaded ? tState.templates : null;
            final name = resolveGarmentName(g, AppLocalizations.of(context), items: o.items, templates: tmpls);

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.black.withValues(alpha: 0.02),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: c.divider.withValues(alpha: 0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.label_important_outline, size: 14, color: c.colorPrimary),
                      const SizedBox(width: 8),
                      Text(name.toUpperCase(), style: GoogleFonts.poppins(
                        fontSize: 12, fontWeight: FontWeight.bold, color: c.colorPrimary, letterSpacing: 0.5)),
                      const Spacer(),
                      if (qty > 0) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: c.colorPrimary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Qty: $qty',
                            style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: c.colorPrimary),
                          ),
                        ),
                        if (price > 0) ...[
                          const SizedBox(width: 6),
                          Text(
                            '₹${price.toStringAsFixed(0)}',
                            style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: c.textDark),
                          ),
                        ],
                      ],
                    ],
                  ),
                  if (mParts.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 16,
                      runSpacing: 12,
                      children: mParts.entries.map((me) => SizedBox(
                        width: 130,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(me.key, style: GoogleFonts.poppins(fontSize: 11, color: c.gray)),
                            const SizedBox(height: 2),
                            Text(me.value, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: c.textDark)),
                          ],
                        ),
                      )).toList(),
                    ),
                  ] else ...[
                    const SizedBox(height: 6),
                    Text('— ${AppLocalizations.of(context).none}', style: GoogleFonts.poppins(fontSize: 12, color: c.gray, fontStyle: FontStyle.italic)),
                  ],
                  if (note.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.notes, size: 13, color: c.gray),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(note, style: GoogleFonts.poppins(fontSize: 12, color: c.textDark.withValues(alpha: 0.8), fontStyle: FontStyle.italic)),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            );
          }),
        ],
      ])),
    ]);
  }

  Map<String, String> _parseMeasurements(String str) {
    if (str.isEmpty) return {};
    final parts = str.split(RegExp(r',\s*'));
    final result = <String, String>{};
    for (var p in parts) {
      final kv = p.split(':');
      if (kv.length == 2) {
        final key = kv[0].trim();
        final val = kv[1].trim();
        if (key != '__UNIT__') {
          result[key] = val;
        }
      }
    }
    return result;
  }

  Widget _buildScheduleSection(AppColorScheme c, bool isDark, OrderEntity o) {
    final dueIcon = o.deliveryDate != null && o.deliveryDate!.isBefore(DateTime.now()) ? Icons.access_time_outlined : Icons.calendar_today_outlined;
    final dueColor = o.deliveryDate != null && o.deliveryDate!.isBefore(DateTime.now()) ? c.red : c.colorPrimary;
    
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _sectionLabel(c, Icons.calendar_today_outlined, AppLocalizations.of(context).scheduleAssign),
      const SizedBox(height: 10),
      _card(c, isDark, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _micro(c, AppLocalizations.of(context).deliveryDateLabel.toUpperCase()),
        const SizedBox(height: 8),
        Row(children: [
          Icon(dueIcon, size: 15, color: dueColor),
          const SizedBox(width: 8),
          Text(
            o.deliveryDate == null
                ? AppLocalizations.of(context).notSet
                : '${o.deliveryDate!.day}/${o.deliveryDate!.month}/${o.deliveryDate!.year}',
            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600,
                color: dueColor),
          ),
        ]),
        const SizedBox(height: 20),
        _micro(c, AppLocalizations.of(context).priorityLabel.toUpperCase()),
        const SizedBox(height: 8),
        _priorityBadge(c, o.priorityIndex),
      ])),
    ]);
  }

  Widget _buildPaymentSection(AppColorScheme c, bool isDark, OrderEntity o) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _sectionLabel(c, Icons.payment_outlined, AppLocalizations.of(context).payment),
      const SizedBox(height: 10),
      _card(c, isDark, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          _micro(c, AppLocalizations.of(context).grandTotal.toUpperCase()),
          Text('₹${o.totalAmount.toStringAsFixed(2)}',
              style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold,
                  color: c.colorPrimary)),
        ]),
        const SizedBox(height: 12),
        if (o.externalCharges > 0) ...[
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _micro(c, AppLocalizations.of(context).externalCharges.toUpperCase()),
            Text('₹${o.externalCharges.toStringAsFixed(2)}',
                style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: c.textDark)),
          ]),
          const SizedBox(height: 12),
        ],
        Divider(color: c.divider.withValues(alpha: 0.5)),
        const SizedBox(height: 12),
        _micro(c, AppLocalizations.of(context).advancePaidLabel.toUpperCase()),
        const SizedBox(height: 8),
        Row(children: [
          Text('₹${o.advancePaid.toStringAsFixed(2)}',
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold,
                  color: Colors.green.shade700)),
          const SizedBox(width: 8),
          if (o.advancePaid >= o.totalAmount)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6)),
              child: Text(AppLocalizations.of(context).paid, style: GoogleFonts.poppins(fontSize: 9,
                  fontWeight: FontWeight.bold, color: Colors.green.shade700)),
            ),
        ]),
        const SizedBox(height: 12),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(AppLocalizations.of(context).balanceDue, style: GoogleFonts.poppins(fontSize: 14,
              fontWeight: FontWeight.w600, color: c.red)),
          Text('₹${o.balanceDue.toStringAsFixed(2)}', style: GoogleFonts.poppins(
              fontSize: 18, fontWeight: FontWeight.bold, color: c.red)),
        ]),
        const SizedBox(height: 16),
        Divider(color: c.divider.withValues(alpha: 0.5)),
        const SizedBox(height: 12),
        _micro(c, AppLocalizations.of(context).paymentModeLabel.toUpperCase()),
        const SizedBox(height: 8),
        Row(children: [
          _payIcon(o.paymentMode),
          const SizedBox(width: 8),
          Text(_getPaymentModeText(o.paymentMode), style: GoogleFonts.poppins(fontSize: 14,
              fontWeight: FontWeight.w600, color: c.textDark)),
        ]),
        const SizedBox(height: 20),

        // Action Button: Record Payment
        if (o.balanceDue > 0) ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: c.colorPrimary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () async {
                final result = await showModalBottomSheet<bool>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (ctx) => BlocProvider<PaymentBloc>(
                    create: (_) => getIt<PaymentBloc>(),
                    child: RecordPaymentSheet(order: o),
                  ),
                );
                if (result == true && mounted) {
                  context.read<OrderBloc>().add(LoadOrders());
                }
              },
              icon: const Icon(Icons.add_circle_outline, size: 18, color: Colors.white),
              label: Text(
                'Record Payment',
                style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ],
      ])),
    ]);
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────
  Widget _sectionLabel(AppColorScheme c, IconData icon, String title) => Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: Row(children: [
          Icon(icon, size: 16, color: c.colorPrimary),
          const SizedBox(width: 8),
          Text(title.toUpperCase(),
              style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold,
                  letterSpacing: 0.8, color: c.gray)),
        ]),
      );

  Widget _micro(AppColorScheme c, String t) => Text(t,
      style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold,
          letterSpacing: 0.8, color: c.gray));

  Widget _card(AppColorScheme c, bool isDark, {required Widget child}) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isDark ? c.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 14, offset: const Offset(0, 4))],
          border: Border.all(color: c.divider.withValues(alpha: 0.3)),
        ),
        child: child,
      );

  Widget _priorityBadge(AppColorScheme c, int priorityIndex) {
    final l10n = AppLocalizations.of(context);
    final localizedP = getLocalizedPriority(priorityIndex, l10n);
    final col = priorityIndex == 3 ? c.red : (priorityIndex == 2 ? c.colorPrimary : c.gray);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
          color: col.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20),
          border: Border.all(color: col.withValues(alpha: 0.3))),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.speed, size: 14, color: col),
        const SizedBox(width: 6),
        Text(localizedP, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: col)),
      ]),
    );
  }

  Widget _payIcon(int paymentIndex) {
    IconData icon; Color col;
    if (paymentIndex == 1 || paymentIndex == 0) { icon = Icons.attach_money; col = const Color(0xFF2E7D32); }
    else if (paymentIndex == 2) { icon = Icons.credit_card; col = const Color(0xFF1565C0); }
    else { icon = Icons.qr_code_scanner; col = const Color(0xFF6A1B9A); }
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: col.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
      child: Icon(icon, color: col, size: 18),
    );
  }
  

  Color _statusBg(String s, AppColorScheme c) => switch (s) {
        'IN PROGRESS' => const Color(0xFFFFF3E0),
        'READY' => const Color(0xFFE8F5E9),
        'OVERDUE' => const Color(0xFFFFECEC),
        'DELIVERED' => const Color(0xFFE8F5E9),
        _ => c.divider.withValues(alpha: 0.3),
      };

  Color _statusColor(String s, AppColorScheme c) => switch (s) {
        'IN PROGRESS' => const Color(0xFFF57C00),
        'READY' => const Color(0xFF2E7D32),
        'OVERDUE' => const Color(0xFFE53935),
        'DELIVERED' => const Color(0xFF2E7D32),
        _ => c.gray,
      };
}
