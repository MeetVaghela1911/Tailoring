import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/services/receipt_pdf_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/common_methods.dart';
import '../../../../core/utility/dependency_injection.dart';
import '../../../../core/widgets/app_back_button.dart';

import '../../../orders/domain/entities/order_entity.dart';
import '../../../orders/presentation/bloc/order_bloc.dart';
import '../../../orders/presentation/bloc/order_event.dart';
import '../../domain/entities/payment_transaction.dart';
import '../../domain/repositories/payment_repository.dart';
import '../bloc/payment_bloc.dart';
import '../bloc/payment_event.dart';
import '../bloc/payment_state.dart';
import '../widgets/record_payment_sheet.dart';

class FinanceManagementScreen extends StatefulWidget {
  const FinanceManagementScreen({super.key});

  @override
  State<FinanceManagementScreen> createState() => _FinanceManagementScreenState();
}

class _FinanceManagementScreenState extends State<FinanceManagementScreen>
    with SingleTickerProviderStateMixin {
  late PaymentBloc _paymentBloc;
  late TabController _tabController;
  int _activeTabIndex = 0;

  String _selectedFilter = 'This Month';
  DateTime? _customStartDate;
  DateTime? _customEndDate;

  final List<String> _filters = [
    'This Month',
    'Today',
    'This Week',
    'Last Month',
    'Custom Range',
  ];

  @override
  void initState() {
    super.initState();
    _paymentBloc = getIt<PaymentBloc>();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (mounted) {
        setState(() => _activeTabIndex = _tabController.index);
      }
    });
    _applyFilter('This Month');
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _applyFilter(String filterName) {
    setState(() => _selectedFilter = filterName);

    final now = DateTime.now();
    DateTime? start;
    DateTime? end;

    if (filterName == 'Today') {
      start = DateTime(now.year, now.month, now.day);
      end = start.add(const Duration(days: 1)).subtract(const Duration(milliseconds: 1));
    } else if (filterName == 'This Week') {
      start = now.subtract(Duration(days: now.weekday - 1));
      start = DateTime(start.year, start.month, start.day);
      end = start.add(const Duration(days: 7)).subtract(const Duration(milliseconds: 1));
    } else if (filterName == 'This Month') {
      start = DateTime(now.year, now.month, 1);
      end = DateTime(now.year, now.month + 1, 1).subtract(const Duration(milliseconds: 1));
    } else if (filterName == 'Last Month') {
      start = DateTime(now.year, now.month - 1, 1);
      end = DateTime(now.year, now.month, 1).subtract(const Duration(milliseconds: 1));
    } else if (filterName == 'Custom Range') {
      if (_customStartDate != null && _customEndDate != null) {
        start = _customStartDate;
        end = _customEndDate;
      } else {
        _selectCustomDateRange();
        return;
      }
    }

    _paymentBloc.add(LoadFilteredFinance(
      startDate: start,
      endDate: end,
      filterName: filterName,
    ));
  }

  Future<void> _selectCustomDateRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDateRange: DateTimeRange(
        start: _customStartDate ?? now.subtract(const Duration(days: 30)),
        end: _customEndDate ?? now,
      ),
    );

    if (picked != null) {
      setState(() {
        _customStartDate = picked.start;
        _customEndDate = DateTime(picked.end.year, picked.end.month, picked.end.day, 23, 59, 59);
        _selectedFilter = 'Custom Range';
      });
      _paymentBloc.add(LoadFilteredFinance(
        startDate: _customStartDate,
        endDate: _customEndDate,
        filterName: 'Custom Range',
      ));
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

    return BlocProvider.value(
      value: _paymentBloc,
      child: Scaffold(
        backgroundColor: c.background,
        body: Stack(
          children: [
            // Smooth top header gradient background (Matching App Theme)
            Positioned(
              top: 0, left: 0, right: 0, height: 260,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      topGradientColor,
                      midGradientColor,
                      c.background.withValues(alpha: 0.0),
                    ],
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
                    child: BlocBuilder<PaymentBloc, PaymentState>(
                      bloc: _paymentBloc,
                      builder: (context, state) {
                        if (state is PaymentLoading) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (state is FilteredFinanceLoaded) {
                          final s = state.summary;
                          return RefreshIndicator(
                            color: c.colorPrimary,
                            onRefresh: () async => _applyFilter(_selectedFilter),
                            child: ListView(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              children: [
                                _buildDateFilterBar(c, isDark),
                                const SizedBox(height: 16),
                                _buildOverviewCards(c, isDark, s),
                                const SizedBox(height: 20),
                                _buildMethodBreakdown(c, isDark, s),
                                const SizedBox(height: 24),
                                _buildTabBarSection(c, isDark, s),
                              ],
                            ),
                          );
                        }

                        if (state is PaymentError) {
                          return Center(
                            child: Text(
                              state.message,
                              style: GoogleFonts.poppins(color: c.red),
                            ),
                          );
                        }

                        return const SizedBox.shrink();
                      },
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          AppBackButton(onTap: () => context.pop()),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FINANCE & PAYMENTS',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: c.colorPrimary,
                  ),
                ),
                Text(
                  'Finance Management',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: c.textDark,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _applyFilter(_selectedFilter),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: c.colorPrimary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.refresh, color: c.colorPrimary, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateFilterBar(AppColorScheme c, bool isDark) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, index) => const SizedBox(width: 8),
        itemBuilder: (ctx, index) {
          final filter = _filters[index];
          final isSelected = _selectedFilter == filter;
          String label = filter;
          if (filter == 'Custom Range' && _customStartDate != null && _customEndDate != null) {
            label = '${DateFormat('d MMM').format(_customStartDate!)} - ${DateFormat('d MMM').format(_customEndDate!)}';
          }

          return ChoiceChip(
            label: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : c.textDark,
              ),
            ),
            selected: isSelected,
            selectedColor: c.colorPrimary,
            backgroundColor: isDark ? c.cardDark : Colors.white,
            side: BorderSide(
              color: isSelected ? c.colorPrimary : c.divider.withValues(alpha: 0.5),
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            onSelected: (_) {
              if (filter == 'Custom Range') {
                _selectCustomDateRange();
              } else {
                _applyFilter(filter);
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildOverviewCards(AppColorScheme c, bool isDark, FilteredFinanceSummary s) {
    return Column(
      children: [
        // Main Total Collected Banner (Thematic Gradient)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                c.colorPrimary,
                c.colorPrimaryDark,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: c.colorPrimary.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'TOTAL COLLECTED REVENUE',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: Colors.white70,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      s.filterName,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '₹${s.totalCollected.toStringAsFixed(0)}',
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),

              // Collection efficiency progress bar
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: (s.collectionEfficiency / 100).clamp(0.0, 1.0),
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        color: Colors.white,
                        minHeight: 6,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${s.collectionEfficiency.toStringAsFixed(0)}% Collected',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Grid of Pending Receivables & Estimated Total
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? c.cardDark : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: s.pendingReceivables > 0
                        ? c.red.withValues(alpha: 0.3)
                        : c.divider.withValues(alpha: 0.4),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.pending_actions, size: 16, color: s.pendingReceivables > 0 ? c.red : c.gray),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Pending Dues',
                            style: GoogleFonts.poppins(fontSize: 11, color: c.gray, fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '₹${s.pendingReceivables.toStringAsFixed(0)}',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: s.pendingReceivables > 0 ? c.red : c.textDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? c.cardDark : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: c.divider.withValues(alpha: 0.4)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.trending_up, size: 16, color: c.colorPrimary),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Est. Revenue',
                            style: GoogleFonts.poppins(fontSize: 11, color: c.gray, fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '₹${s.estimatedTotalRevenue.toStringAsFixed(0)}',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: c.textDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMethodBreakdown(AppColorScheme c, bool isDark, FilteredFinanceSummary s) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? c.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: c.divider.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Mode Breakdown',
            style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: c.textDark),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _methodPill(c, Icons.attach_money, 'Cash', s.cashCollected, s.totalCollected),
              const SizedBox(width: 8),
              _methodPill(c, Icons.qr_code, 'UPI', s.upiCollected, s.totalCollected),
              const SizedBox(width: 8),
              _methodPill(c, Icons.credit_card, 'Card', s.cardCollected, s.totalCollected),
            ],
          ),
        ],
      ),
    );
  }

  Widget _methodPill(AppColorScheme c, IconData icon, String mode, double amount, double total) {
    final pct = total > 0 ? (amount / total * 100).toStringAsFixed(0) : '0';
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: c.colorPrimary.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: c.colorPrimary.withValues(alpha: 0.15)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 14, color: c.colorPrimary),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    mode,
                    style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: c.textDark),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                '₹${amount.toStringAsFixed(0)}',
                style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: c.textDark),
              ),
            ),
            Text(
              '$pct%',
              style: GoogleFonts.poppins(fontSize: 10, color: c.colorPrimary, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBarSection(AppColorScheme c, bool isDark, FilteredFinanceSummary s) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: isDark ? c.cardDark : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: c.divider.withValues(alpha: 0.4)),
          ),
          child: TabBar(
            controller: _tabController,
            onTap: (index) => setState(() => _activeTabIndex = index),
            dividerColor: Colors.transparent,
            dividerHeight: 0,
            labelColor: c.colorPrimary,
            unselectedLabelColor: c.gray,
            indicatorColor: c.colorPrimary,
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.tab,
            labelStyle: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold),
            unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500),
            tabs: [
              Tab(text: 'History (${s.transactions.length})'),
              Tab(text: 'Pending Dues (${s.pendingOrders.length})'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _activeTabIndex == 0
            ? _buildTransactionsList(c, isDark, s.transactions)
            : _buildPendingOrdersList(c, isDark, s.pendingOrders),
      ],
    );
  }

  Widget _buildTransactionsList(AppColorScheme c, bool isDark, List<PaymentTransaction> list) {
    if (list.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Icon(Icons.receipt_long_outlined, size: 40, color: c.gray.withValues(alpha: 0.5)),
            const SizedBox(height: 8),
            Text(
              'No payments recorded in this period',
              style: GoogleFonts.poppins(fontSize: 13, color: c.gray),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      separatorBuilder: (_, index) => const SizedBox(height: 10),
      itemBuilder: (ctx, index) {
        final item = list[index];
        final formattedDate = DateFormat('dd MMM yyyy, h:mm a').format(item.createdAt);

        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? c.cardDark : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: c.divider.withValues(alpha: 0.4)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: c.colorPrimary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Icon(
                  item.paymentMode == 1
                      ? Icons.attach_money
                      : item.paymentMode == 2
                          ? Icons.credit_card
                          : Icons.qr_code,
                  color: c.colorPrimary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.customerName ?? 'Order Payment',
                      style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: c.textDark),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${item.paymentStage ?? "Payment"} • $formattedDate',
                      style: GoogleFonts.poppins(fontSize: 11, color: c.gray),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '+₹${item.amount.toStringAsFixed(0)}',
                    style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: c.green),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: c.colorPrimary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      item.paymentModeName ?? (item.paymentMode == 1 ? 'Cash' : 'UPI'),
                      style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.bold, color: c.colorPrimary),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPendingOrdersList(AppColorScheme c, bool isDark, List<OrderEntity> orders) {
    if (orders.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Icon(Icons.check_circle_outline, size: 40, color: c.green),
            const SizedBox(height: 8),
            Text(
              'No pending dues in this period!',
              style: GoogleFonts.poppins(fontSize: 13, color: c.gray),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: orders.length,
      separatorBuilder: (_, index) => const SizedBox(height: 12),
      itemBuilder: (ctx, index) {
        final order = orders[index];
        final shortId = order.id.length > 8 ? order.id.substring(0, 8).toUpperCase() : order.id.toUpperCase();

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? c.cardDark : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: c.red.withValues(alpha: 0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      order.customerName ?? 'Customer',
                      style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: c.textDark),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '#$shortId',
                    style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: c.gray),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: ₹${order.totalAmount.toStringAsFixed(0)} | Paid: ₹${order.advancePaid.toStringAsFixed(0)}',
                    style: GoogleFonts.poppins(fontSize: 12, color: c.gray),
                  ),
                  Text(
                    'Due: ₹${order.balanceDue.toStringAsFixed(0)}',
                    style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: c.red),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: c.colorPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () async {
                        final result = await showModalBottomSheet<bool>(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (ctx) => BlocProvider.value(
                            value: _paymentBloc,
                            child: RecordPaymentSheet(order: order),
                          ),
                        );
                        if (result == true) {
                          _applyFilter(_selectedFilter);
                          if (mounted) {
                            context.read<OrderBloc>().add(LoadOrders());
                          }
                        }
                      },
                      icon: const Icon(Icons.payment, size: 16, color: Colors.white),
                      label: Text(
                        'Record Payment',
                        style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      ReceiptPdfService.showWhatsAppReceiptBottomSheet(context, order);
                    },
                    child: Container(
                      width: 42,
                      height: 42,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFF25D366).withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF25D366).withValues(alpha: 0.3)),
                      ),
                      child: const FaIcon(
                        FontAwesomeIcons.whatsapp,
                        color: Color(0xFF25D366),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
