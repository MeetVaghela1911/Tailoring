import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/common_methods.dart';
import '../../../../core/utility/dependency_injection.dart';
import '../../../payments/presentation/bloc/payment_bloc.dart';
import '../../../payments/presentation/bloc/payment_event.dart';
import '../../../payments/presentation/bloc/payment_state.dart';

class CustomerKhataCard extends StatefulWidget {
  final String customerId;

  const CustomerKhataCard({super.key, required this.customerId});

  @override
  State<CustomerKhataCard> createState() => _CustomerKhataCardState();
}

class _CustomerKhataCardState extends State<CustomerKhataCard> {
  late PaymentBloc _paymentBloc;

  @override
  void initState() {
    super.initState();
    _paymentBloc = getIt<PaymentBloc>();
    _paymentBloc.add(LoadCustomerKhata(widget.customerId));
  }

  @override
  Widget build(BuildContext context) {
    final c = getThemeBaseColors(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<PaymentBloc, PaymentState>(
      bloc: _paymentBloc,
      builder: (context, state) {
        if (state is PaymentLoading) {
          return Container(
            height: 60,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(strokeWidth: 2),
          );
        }

        if (state is CustomerKhataLoaded) {
          final summary = state.summary;
          final bool hasDue = summary.totalOutstandingDue > 0;

          return Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: hasDue ? c.red.withValues(alpha: 0.3) : c.divider.withValues(alpha: 0.4),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.account_balance_wallet,
                      color: hasDue ? c.red : c.colorPrimary,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Ledger (Khata)',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: c.textDark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: hasDue
                            ? c.red.withValues(alpha: 0.1)
                            : c.colorPrimary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        hasDue ? 'Udhar / Due' : 'All Settled',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: hasDue ? c.red : c.colorPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _infoStat('Orders', '${summary.totalOrdersCount}', c),
                    _divider(c),
                    _infoStat('Billed', '₹${summary.totalOrderVolume.toStringAsFixed(0)}', c),
                    _divider(c),
                    _infoStat('Paid', '₹${summary.totalPaidAmount.toStringAsFixed(0)}', c),
                    _divider(c),
                    _infoStat(
                      'Outstanding',
                      '₹${summary.totalOutstandingDue.toStringAsFixed(0)}',
                      c,
                      isAlert: hasDue,
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _infoStat(String label, String value, AppColorScheme c, {bool isAlert = false}) {
    return Expanded(
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: GoogleFonts.poppins(fontSize: 10, color: c.gray, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isAlert ? c.red : c.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider(AppColorScheme c) => Container(
        height: 20,
        width: 1,
        color: c.divider.withValues(alpha: 0.4),
      );
}
