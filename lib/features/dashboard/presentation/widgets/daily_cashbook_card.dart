import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/common_methods.dart';
import '../../../../core/utility/dependency_injection.dart';
import '../../../payments/presentation/bloc/payment_bloc.dart';
import '../../../payments/presentation/bloc/payment_event.dart';
import '../../../payments/presentation/bloc/payment_state.dart';

class DailyCashbookCard extends StatefulWidget {
  const DailyCashbookCard({super.key});

  @override
  State<DailyCashbookCard> createState() => _DailyCashbookCardState();
}

class _DailyCashbookCardState extends State<DailyCashbookCard> {
  late PaymentBloc _paymentBloc;

  @override
  void initState() {
    super.initState();
    _paymentBloc = getIt<PaymentBloc>();
    _paymentBloc.add(const LoadDailyCashbook());
  }

  @override
  Widget build(BuildContext context) {
    final c = getThemeBaseColors(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<PaymentBloc, PaymentState>(
      bloc: _paymentBloc,
      builder: (context, state) {
        if (state is DailyCashbookLoaded) {
          final s = state.summary;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [c.cardDark, c.cardDark.withValues(alpha: 0.8)]
                    : [c.white, Colors.blue.shade50.withValues(alpha: 0.4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: c.divider.withValues(alpha: 0.3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: c.colorPrimary.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.point_of_sale, color: c.colorPrimary, size: 18),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Today's Cashbook",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: c.textDark,
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () => _paymentBloc.add(const LoadDailyCashbook()),
                      child: Icon(Icons.refresh, size: 18, color: c.gray),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Collected Today',
                            style: GoogleFonts.poppins(fontSize: 11, color: c.gray, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '₹${s.totalCollected.toStringAsFixed(0)}',
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: c.colorPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 36, width: 1,
                      color: c.divider.withValues(alpha: 0.4),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pending Receivables',
                            style: GoogleFonts.poppins(fontSize: 11, color: c.gray, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '₹${s.pendingReceivables.toStringAsFixed(0)}',
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: s.pendingReceivables > 0 ? c.red : c.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 12),

                // Mode Breakdown Chips
                Row(
                  children: [
                    Expanded(child: _modeBadge(c, Icons.attach_money, 'Cash', '₹${s.cashCollected.toStringAsFixed(0)}')),
                    const SizedBox(width: 6),
                    Expanded(child: _modeBadge(c, Icons.qr_code, 'UPI', '₹${s.upiCollected.toStringAsFixed(0)}')),
                    const SizedBox(width: 6),
                    Expanded(child: _modeBadge(c, Icons.credit_card, 'Card', '₹${s.cardCollected.toStringAsFixed(0)}')),
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

  Widget _modeBadge(AppColorScheme c, IconData icon, String label, String amount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: c.gray.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: c.gray),
          const SizedBox(width: 3),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$label: ',
                    style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w500, color: c.gray),
                  ),
                  Text(
                    amount,
                    style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: c.textDark),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
