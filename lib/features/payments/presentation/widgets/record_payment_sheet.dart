import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/common_methods.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../../../core/utility/dependency_injection.dart';
import '../../../orders/data/datasources/lookup_remote_data_source.dart';
import '../../../orders/data/models/payment_mode_model.dart';
import '../../../orders/domain/entities/order_entity.dart';
import '../bloc/payment_bloc.dart';
import '../bloc/payment_event.dart';
import '../bloc/payment_state.dart';

class RecordPaymentSheet extends StatefulWidget {
  final OrderEntity order;

  const RecordPaymentSheet({super.key, required this.order});

  @override
  State<RecordPaymentSheet> createState() => _RecordPaymentSheetState();
}

class _RecordPaymentSheetState extends State<RecordPaymentSheet> {
  late TextEditingController _amountController;
  late TextEditingController _notesController;
  late TextEditingController _refController;

  int? _selectedPaymentMode;
  String? _selectedStage;

  List<String> _stages = [];
  List<PaymentModeModel> _paymentModes = [];
  bool _isLoadingLookups = true;

  @override
  void initState() {
    super.initState();
    final remaining = widget.order.balanceDue;
    _amountController = TextEditingController(
      text: remaining > 0 ? remaining.toStringAsFixed(0) : '',
    );
    _notesController = TextEditingController();
    _refController = TextEditingController();

    _loadLookupsFromDb();
  }

  Future<void> _loadLookupsFromDb() async {
    try {
      final lookupDs = getIt<LookupRemoteDataSource>();
      final modes = await lookupDs.getPaymentModes();
      final stages = await lookupDs.getPaymentStages();

      if (mounted) {
        setState(() {
          _paymentModes = modes;
          _stages = stages;
          if (modes.isNotEmpty) {
            _selectedPaymentMode = modes.first.id;
          }
          if (stages.isNotEmpty) {
            if (widget.order.balanceDue <= 0) {
              _selectedStage = stages.last;
            } else if (widget.order.advancePaid == 0) {
              _selectedStage = stages.first;
            } else {
              _selectedStage = stages.length > 2 ? stages[2] : stages.last;
            }
          }
          _isLoadingLookups = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoadingLookups = false);
      }
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    _refController.dispose();
    super.dispose();
  }

  void _onSavePayment() {
    final amt = double.tryParse(_amountController.text.trim()) ?? 0.0;
    if (amt <= 0) {
      showAppSnackBar(context, message: 'Please enter a valid payment amount', isError: true);
      return;
    }

    if (amt > widget.order.balanceDue && widget.order.balanceDue > 0) {
      showAppSnackBar(
        context,
        message: 'Payment amount cannot exceed remaining balance (₹${widget.order.balanceDue.toStringAsFixed(2)})',
        isError: true,
      );
      return;
    }

    final modeId = _selectedPaymentMode ?? 1;
    final modeModel = _paymentModes.firstWhere(
      (m) => m.id == modeId,
      orElse: () => PaymentModeModel(id: modeId, name: modeId == 1 ? 'Cash' : modeId == 2 ? 'Card' : 'UPI / Online'),
    );

    context.read<PaymentBloc>().add(
          AddPaymentTransactionEvent(
            orderId: widget.order.id,
            customerId: widget.order.customerId,
            customerName: widget.order.customerName,
            customerPhone: widget.order.customerPhone,
            amount: amt,
            paymentMode: modeId,
            paymentModeName: modeModel.name,
            paymentStage: _selectedStage ?? 'Partial Payment',
            notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
            referenceNumber: _refController.text.trim().isNotEmpty ? _refController.text.trim() : null,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final c = getThemeBaseColors(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<PaymentBloc, PaymentState>(
      listener: (context, state) {
        if (state is PaymentAddedSuccess) {
          showAppSnackBar(context, message: 'Payment recorded successfully! ₹${state.transaction.amount.toStringAsFixed(0)}');
          Navigator.pop(context, true);
        } else if (state is PaymentError) {
          showAppSnackBar(context, message: state.message, isError: true);
        }
      },
      child: Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        decoration: BoxDecoration(
          color: isDark ? c.cardDark : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: _isLoadingLookups
            ? Container(
                height: 200,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.payment, color: c.colorPrimary, size: 22),
                            const SizedBox(width: 8),
                            Text(
                              'Record Payment',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: c.textDark,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.close, color: c.gray),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Outstanding balance info pill
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: c.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: c.red.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Remaining Balance Due:',
                            style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: c.red),
                          ),
                          Text(
                            '₹${widget.order.balanceDue.toStringAsFixed(0)}',
                            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: c.red),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Amount Input Field
                    Text(
                      'Amount Paid (₹)',
                      style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: c.gray),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: c.textDark),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.currency_rupee, color: c.colorPrimary),
                        hintText: 'Enter amount',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Payment Stage Choice Chips (Strictly from DB)
                    if (_stages.isNotEmpty) ...[
                      Text(
                        'Payment Stage / Reason',
                        style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: c.gray),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _stages.map((stage) {
                          final isSelected = _selectedStage == stage;
                          return ChoiceChip(
                            label: Text(
                              stage,
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                color: isSelected ? Colors.white : c.textDark,
                              ),
                            ),
                            selected: isSelected,
                            selectedColor: c.colorPrimary,
                            backgroundColor: c.gray.withValues(alpha: 0.08),
                            side: BorderSide(
                              color: isSelected ? c.colorPrimary : c.divider.withValues(alpha: 0.5),
                            ),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            onSelected: (_) {
                              setState(() => _selectedStage = stage);
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Payment Mode Selection (Strictly from DB)
                    if (_paymentModes.isNotEmpty) ...[
                      Text(
                        'Payment Mode',
                        style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: c.gray),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: _paymentModes.map((mode) {
                          final icon = mode.id == 1
                              ? Icons.money
                              : mode.id == 2
                                  ? Icons.credit_card
                                  : Icons.qr_code;
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: _modeChip(c, mode.id, icon, mode.name),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Notes & Reference Fields
                    TextField(
                      controller: _refController,
                      style: GoogleFonts.poppins(fontSize: 13, color: c.textDark),
                      decoration: InputDecoration(
                        labelText: 'Transaction / UTR / Receipt Ref (Optional)',
                        labelStyle: GoogleFonts.poppins(fontSize: 12, color: c.gray),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _notesController,
                      style: GoogleFonts.poppins(fontSize: 13, color: c.textDark),
                      decoration: InputDecoration(
                        labelText: 'Note (Optional)',
                        labelStyle: GoogleFonts.poppins(fontSize: 12, color: c.gray),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Save Action Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: c.colorPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        onPressed: _onSavePayment,
                        child: Text(
                          'Confirm & Save Payment',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _modeChip(AppColorScheme c, int modeId, IconData icon, String label) {
    bool isSelected = _selectedPaymentMode == modeId;
    return GestureDetector(
      onTap: () => setState(() => _selectedPaymentMode = modeId),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? c.colorPrimary : Colors.transparent,
          border: Border.all(color: isSelected ? c.colorPrimary : c.divider),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: isSelected ? Colors.white : c.textDark),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : c.textDark,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
