import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/common_methods.dart';
import 'package:tailoring_flutter/l10n/app_localizations.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../../../routes/app_router.dart';
import '../../../../core/service/storage_service.dart';
import '../../../../core/utility/dependency_injection.dart';
import '../../domain/entities/order_entity.dart';
import '../bloc/order_bloc.dart';
import '../bloc/order_event.dart';
import '../bloc/order_state.dart';
import '../bloc/order_wizard_bloc.dart';

class CreateOrderPaymentScreen extends StatefulWidget {
  const CreateOrderPaymentScreen({super.key});

  @override
  State<CreateOrderPaymentScreen> createState() =>
      _CreateOrderPaymentScreenState();
}

class _CreateOrderPaymentScreenState extends State<CreateOrderPaymentScreen> {
  int _paymentMode = 0; // 0 Cash, 1 Card, 2 UPI, 3 Not Specified, 4+ Custom
  final List<Map<String, dynamic>> _paymentModes = [
    {'label': 'Cash', 'icon': Icons.attach_money},
    {'label': 'Card', 'icon': Icons.credit_card},
    {'label': 'Online/UPI', 'icon': Icons.qr_code_scanner},
    {'label': 'Not Specified', 'icon': Icons.help_outline},
  ];
  late TextEditingController _advanceController;
  late TextEditingController _totalController;
  late TextEditingController _externalChargesController;
  
  // Track controllers for each garment line item
  final Map<String, TextEditingController> _itemControllers = {};
  
  late double _balanceDue;
  String? _advanceError;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    final d = getIt<OrderWizardBloc>().state.formData;
    
    // Initialize line item controllers
    for (var g in d.garmentTypes) {
      final linePrice = d.garmentPrices[g] ?? (d.garmentQuantities[g] ?? 1) * 0.0; 
      _itemControllers[g] = TextEditingController(text: linePrice.toStringAsFixed(0));
      _itemControllers[g]!.addListener(_calculateTotal);
    }

    final total = d.totalAmount;
    _totalController = TextEditingController(text: total.toStringAsFixed(2));
    final advance = d.advancePaid;
    _advanceController = TextEditingController(text: advance > 0 ? advance.toStringAsFixed(0) : '');
    final external = d.externalCharges;
    _externalChargesController = TextEditingController(text: external > 0 ? external.toStringAsFixed(0) : '');
    
    _balanceDue = (total - advance).clamp(0, double.infinity);
    _paymentMode = d.paymentMode;
    
    _advanceController.addListener(_updateBalance);
    _externalChargesController.addListener(_calculateTotal);
  }

  void _calculateTotal() {
    double itemSum = 0;
    _itemControllers.forEach((_, ctrl) {
      itemSum += double.tryParse(ctrl.text) ?? 0.0;
    });
    
    final external = double.tryParse(_externalChargesController.text) ?? 0.0;
    final grandTotal = itemSum + external;
    
    _totalController.text = grandTotal.toStringAsFixed(2);
    _updateBalance();
  }

  void _updateBalance() {
    final t = double.tryParse(_totalController.text) ?? 0.0;
    final a = double.tryParse(_advanceController.text) ?? 0.0;
    setState(() {
      if (a > t && t > 0) {
        _advanceError = 'Advance amount cannot exceed grand total (₹${t.toStringAsFixed(2)})';
      } else {
        _advanceError = null;
      }
      _balanceDue = (t - a).clamp(0, double.infinity);
    });
  }

  void _showAddPaymentModeDialog() {
    final nameCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Add Payment Mode',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: nameCtrl,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'e.g., Paytm, Cheque, Net Banking',
            hintStyle: GoogleFonts.poppins(fontSize: 13),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: GoogleFonts.poppins(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              final text = nameCtrl.text.trim();
              if (text.isNotEmpty) {
                setState(() {
                  _paymentModes.add({
                    'label': text,
                    'icon': Icons.account_balance_wallet_outlined,
                  });
                  _paymentMode = _paymentModes.length - 1;
                });
              }
              Navigator.pop(ctx);
            },
            child: Text('Add', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _advanceController.dispose();
    _totalController.dispose();
    _externalChargesController.dispose();
    _itemControllers.forEach((_, ctrl) => ctrl.dispose());
    super.dispose();
  }

  Future<void> _onCreateOrder() async {
    final d = getIt<OrderWizardBloc>().state.formData;
    final total = double.tryParse(_totalController.text) ?? 0.0;
    final advance = double.tryParse(_advanceController.text) ?? 0.0;
    final external = double.tryParse(_externalChargesController.text) ?? 0.0;

    if (advance > total && total > 0) {
      showAppSnackBar(
        context,
        message: 'Advance amount cannot be greater than grand total (₹${total.toStringAsFixed(2)})',
        isError: true,
      );
      return;
    }
    
    // Collect edited garment prices
    final Map<String, double> editedPrices = {};
    _itemControllers.forEach((g, ctrl) {
      editedPrices[g] = double.tryParse(ctrl.text) ?? 0.0;
    });

    setState(() => _isUploading = true);
    String? imageUrl = d.referenceImagePath;

    try {
      if (d.referenceImageFile != null) {
        final storage = getIt<StorageService>();
        final fileName = 'order_${DateTime.now().millisecondsSinceEpoch}.jpg';
        imageUrl = await storage.uploadImage(
          file: d.referenceImageFile!,
          bucket: 'reference_images',
          fileName: fileName,
        );
      }

      final order = OrderEntity(
        id: d.isEditing ? d.existingOrderRef! : const Uuid().v4(),
        customerId: d.customerId,
        customerName: d.customerName,
        customerPhone: d.customerPhone,
        garmentTypes: d.garmentTypes,
        garmentQuantities: d.garmentQuantities,
        garmentPrices: editedPrices,
        specialInstructions: d.specialInstructions,
        referenceImagePath: imageUrl,
        measurements: d.measurements,
        deliveryDate: d.deliveryDate,
        priorityIndex: d.priorityIndex,
        assignedTailor: d.assignedTailor,
        totalAmount: total,
        advancePaid: advance,
        externalCharges: external,
        paymentMode: _paymentMode,
        status: d.isEditing ? d.status : 'NOT STARTED',
        measurementNotes: d.measurementNotes,
        createdAt: DateTime.now(),
      );

      if (!mounted) return;
      if (d.isEditing) {
        context.read<OrderBloc>().add(UpdateOrder(order));
      } else {
        context.read<OrderBloc>().add(CreateOrder(order));
      }
    } catch (e) {
      if (!mounted) return;
      showAppSnackBar(context, message: AppLocalizations.of(context).uploadError(e.toString()), isError: true);
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = getThemeBaseColors(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final topGradientColor = isDark
        ? c.colorPrimaryDark.withValues(alpha: 0.8)
        : c.colorAccent.withValues(alpha: 0.95);
    final midGradientColor = isDark
        ? c.colorPrimaryDark.withValues(alpha: 0.4)
        : c.colorAccent.withValues(alpha: 0.2);

    return BlocListener<OrderBloc, OrderState>(
      listener: (context, state) {
        if (state is OrderUpdateSuccess) {
          context.pop(true); // Pop Payment
          context.pop(true); // Pop Schedule
          context.pop(true); // Pop Measurements
          context.pop(true); // Pop Items
        } else if (state is OrderCreateSuccess) {
          context.push(AppRoutes.createOrderSuccess, extra: state.order);
        } else if (state is OrderError) {
          showAppSnackBar(context, message: state.message, isError: true);
        }
      },
      child: Scaffold(
        backgroundColor: c.background,
        body: Stack(
          children: [
            Positioned(
              top: 0, left: 0, right: 0,
              height: MediaQuery.of(context).size.height * 0.45,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [topGradientColor, midGradientColor, c.background.withValues(alpha: 0.0)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  _buildHeader(c),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                      children: [
                        _buildOrderSummary(c),
                        const SizedBox(height: 24),
                        _buildPaymentDetails(c),
                        const SizedBox(height: 32),
                        _buildBottomActions(c),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AppColorScheme c) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppBackButton(onTap: () => context.pop()),
              Text(
                getIt<OrderWizardBloc>().state.formData.isEditing
                    ? '${AppLocalizations.of(context).order.toUpperCase()} #${getIt<OrderWizardBloc>().state.formData.existingOrderRef?.substring(0, 8).toUpperCase()}'
                    : AppLocalizations.of(context).newOrder,
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: c.textDark),
              ),
              const SizedBox(width: 40),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _stepLabel(c, AppLocalizations.of(context).customer, false),
              _stepLabel(c, AppLocalizations.of(context).measurements, false),
              _stepLabel(c, AppLocalizations.of(context).items, false),
              _stepLabel(c, AppLocalizations.of(context).payment, true),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(5, (index) {
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: index < 4 ? 6 : 0),
                  height: 5,
                  decoration: BoxDecoration(
                    color: c.colorPrimary,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              AppLocalizations.of(context).step5of5,
              style: GoogleFonts.poppins(fontSize: 11, color: c.textDark.withValues(alpha: 0.6), fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context).reviewAndPayment,
            style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600, color: c.textDark),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context).finalizeDetailsCollectAdvance,
            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: c.textDark.withValues(alpha: 0.8)),
          ),
        ],
      ),
    );
  }

  Widget _stepLabel(AppColorScheme c, String text, bool active) => Text(
    text,
    style: GoogleFonts.poppins(fontSize: 11, fontWeight: active ? FontWeight.bold : FontWeight.normal, color: active ? c.textDark : c.textDark.withValues(alpha: 0.6)),
  );

  Widget _buildOrderSummary(AppColorScheme c) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final d = getIt<OrderWizardBloc>().state.formData;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? c.cardDark : c.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: c.black.withValues(alpha: 0.04), blurRadius: 15, offset: const Offset(0, 6)),
        ],
        border: Border.all(color: c.divider.withValues(alpha: 0.3)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.list_alt, color: c.colorPrimary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context).orderSummary,
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: c.textDark),
                  ),
                ],
              ),
              if (d.isEditing)
                Text(
                  '#${d.existingOrderRef!.substring(0, 8).toUpperCase()}',
                  style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: c.gray),
                ),
            ],
          ),
          const SizedBox(height: 20),
          ...d.garmentTypes.map((g) {
            final qty = d.garmentQuantities[g] ?? 1;
            final lineTotal = double.tryParse(_itemControllers[g]?.text ?? '') ?? (d.garmentPrices[g] ?? 0.0);
            final unitPrice = qty > 0 ? lineTotal / qty : lineTotal;
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: c.colorPrimary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(g[0].toUpperCase(), style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: c.colorPrimary)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${getLocalizedTemplateName(g, g, AppLocalizations.of(context))} (${AppLocalizations.of(context).qty(qty)})', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: c.textDark)),
                        if (unitPrice > 0)
                          Text(
                            '₹${unitPrice.toStringAsFixed(0)} × $qty',
                            style: GoogleFonts.poppins(fontSize: 11, color: c.gray, fontWeight: FontWeight.w500),
                          ),
                      ],
                    ),
                  ),
                    Container(
                      width: 90,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: isDark ? c.black.withValues(alpha: 0.2) : c.gray.withValues(alpha: 0.05),
                        border: Border.all(color: c.divider.withValues(alpha: 0.5)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('₹', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: c.textDark.withValues(alpha: 0.7))),
                          const SizedBox(width: 4),
                          Expanded(
                            child: TextField(
                              controller: _itemControllers[g],
                              textAlign: TextAlign.end,
                              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: c.textDark),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
            child: Divider(thickness: 0.5, color: Color(0x1A000000)), // 0.1 alpha black-ish
          ),
          
          // Re-adding external charges here as per request "before grand total"
          _buildExternalChargesSection(c),
          
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
            child: Divider(thickness: 0.5, color: Color(0x1A000000)),
          ),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context).grandTotal,
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: c.textDark),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('₹', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: c.colorPrimary)),
                  const SizedBox(width: 4),
                  Text(
                    _totalController.text,
                    style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: c.colorPrimary),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExternalChargesSection(AppColorScheme c) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: c.gray.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Icon(Icons.add_circle_outline, size: 20, color: c.gray),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context).externalCharges,
                    style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: c.textDark.withValues(alpha: 0.8)),
                  ),
                  Text(AppLocalizations.of(context).additionalServices, style: GoogleFonts.poppins(fontSize: 11, color: c.gray)),
                ],
              ),
            ],
          ),
          Container(
            width: 90,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? c.black.withValues(alpha: 0.2) : c.gray.withValues(alpha: 0.05),
              border: Border.all(color: c.divider.withValues(alpha: 0.5)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('₹', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: c.textDark.withValues(alpha: 0.7))),
                const SizedBox(width: 4),
                Expanded(
                  child: TextField(
                    controller: _externalChargesController,
                    textAlign: TextAlign.end,
                    style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: c.textDark),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      hintText: '0',
                      hintStyle: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: c.gray),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentDetails(AppColorScheme c) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? c.cardDark : c.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: c.black.withValues(alpha: 0.04), blurRadius: 15, offset: const Offset(0, 6)),
        ],
        border: Border.all(color: c.divider.withValues(alpha: 0.3)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.payment, color: c.colorPrimary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Payment Details',
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: c.textDark),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            AppLocalizations.of(context).advanceAmountCap,
            style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: c.textDark.withValues(alpha: 0.6), letterSpacing: 1.0),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: _advanceError != null ? c.red : c.divider),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Text('₹ ', style: GoogleFonts.poppins(fontSize: 18, color: c.gray)),
                Expanded(
                  child: TextField(
                    controller: _advanceController,
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: c.textDark),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '0.00',
                      hintStyle: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: c.gray),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_advanceError != null) ...[
            const SizedBox(height: 6),
            Text(
              _advanceError!,
              style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: c.red),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context).balanceDue, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: c.red)),
              Text('₹${_balanceDue.toStringAsFixed(2)}', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: c.red)),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24.0),
            child: Divider(),
          ),
          Text(
            AppLocalizations.of(context).paymentModeCap,
            style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: c.textDark.withValues(alpha: 0.6), letterSpacing: 1.0),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...List.generate(_paymentModes.length, (index) {
                final mode = _paymentModes[index];
                return SizedBox(
                  width: (MediaQuery.of(context).size.width - 56) / 3 - 6,
                  child: _buildPaymentModeBtn(
                    c,
                    index,
                    mode['icon'] as IconData,
                    mode['label'] as String,
                  ),
                );
              }),
              SizedBox(
                width: (MediaQuery.of(context).size.width - 56) / 3 - 6,
                child: GestureDetector(
                  onTap: _showAddPaymentModeDialog,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: c.colorPrimary, width: 1.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.add_circle_outline, color: c.colorPrimary, size: 24),
                        const SizedBox(height: 8),
                        Text(
                          '+ Add Mode',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: c.colorPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentModeBtn(AppColorScheme c, int index, IconData icon, String label) {
    bool isSelected = _paymentMode == index;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _paymentMode = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? c.colorPrimary : Colors.transparent,
          border: Border.all(color: isSelected ? c.colorPrimary : c.divider),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? Colors.white : c.textDark, size: 24),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.poppins(fontSize: 11, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500, color: isSelected ? Colors.white : c.textDark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActions(AppColorScheme c) {
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        final isLoading = state is OrderLoading || _isUploading;
        return Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: c.colorPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                onPressed: isLoading ? null : _onCreateOrder,
                child: isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            getIt<OrderWizardBloc>().state.formData.isEditing ? AppLocalizations.of(context).saveChanges : AppLocalizations.of(context).createOrder,
                            style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
                        ],
                      ),
              ),
            ),
          ],
        );
      },
    );
  }
}
