import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/common_methods.dart';
import '../../../../core/utility/dependency_injection.dart';
import '../../../../routes/app_router.dart';
import '../../../payments/presentation/bloc/payment_bloc.dart';
import '../../../payments/presentation/bloc/payment_event.dart';
import '../../../payments/presentation/bloc/payment_state.dart';

class FinanceHubCard extends StatefulWidget {
  const FinanceHubCard({super.key});

  @override
  State<FinanceHubCard> createState() => _FinanceHubCardState();
}

class _FinanceHubCardState extends State<FinanceHubCard> {
  late PaymentBloc _paymentBloc;

  @override
  void initState() {
    super.initState();
    _paymentBloc = getIt<PaymentBloc>();
    _paymentBloc.add(const LoadFilteredFinance(filterName: 'This Month'));
  }

  @override
  Widget build(BuildContext context) {
    final c = getThemeBaseColors(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<PaymentBloc, PaymentState>(
      bloc: _paymentBloc,
      builder: (context, state) {
        if (state is FilteredFinanceLoaded) {
          final s = state.summary;

          return GestureDetector(
            onTap: () => context.push(AppRoutes.financeManagement),
            child: Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [c.cardDark, c.cardDark.withValues(alpha: 0.85)]
                      : [c.white, c.white.withValues(alpha: 0.95)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isDark ? Colors.transparent : c.divider.withValues(alpha: 0.5),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 15,
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
                              color: isDark 
                                  ? Colors.white.withValues(alpha: 0.15)
                                  : c.colorPrimary.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.account_balance_wallet_outlined, 
                              color: isDark ? Colors.white : c.colorPrimary, 
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Finance & Payment Hub',
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : c.textDark,
                                ),
                              ),
                              Text(
                                'Tap to open full report →',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: isDark 
                                      ? Colors.white70 
                                      : c.textDark.withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios, 
                        size: 16, 
                        color: isDark 
                            ? Colors.white.withValues(alpha: 0.7) 
                            : c.textDark.withValues(alpha: 0.4),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Collected (This Month)',
                              style: GoogleFonts.poppins(
                                fontSize: 11, 
                                color: isDark 
                                    ? Colors.white70 
                                    : c.textDark.withValues(alpha: 0.6), 
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '₹${s.totalCollected.toStringAsFixed(0)}',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.greenAccent.shade200 : c.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 32, width: 1,
                        color: isDark 
                            ? Colors.white.withValues(alpha: 0.2) 
                            : c.divider,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pending Dues',
                              style: GoogleFonts.poppins(
                                fontSize: 11, 
                                color: isDark 
                                    ? Colors.white70 
                                    : c.textDark.withValues(alpha: 0.6), 
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '₹${s.pendingReceivables.toStringAsFixed(0)}',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: s.pendingReceivables > 0 
                                    ? (isDark ? Colors.orangeAccent : Colors.orange) 
                                    : (isDark ? Colors.white : c.textDark),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
