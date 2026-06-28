import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../onboarding/presentation/utils/walkthrough_keys.dart';

import '../../../core/utils/snackbar_utils.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/common_methods.dart';
import 'package:tailoring_flutter/l10n/app_localizations.dart';
import '../../../routes/app_router.dart';
import '../domain/entities/order_entity.dart';
import 'bloc/order_bloc.dart';
import 'bloc/order_event.dart';
import 'bloc/order_state.dart';
import '../../../core/utility/dependency_injection.dart';
import 'bloc/order_wizard_bloc.dart';
import '../../../core/widgets/app_empty_state.dart';

class OrdersListScreen extends StatefulWidget {
  final String? initialStatusFilter;
  final bool isActive;

  const OrdersListScreen({
    super.key,
    this.initialStatusFilter,
    this.isActive = false,
  });

  @override
  State<OrdersListScreen> createState() => _OrdersListScreenState();
}

class _OrdersListScreenState extends State<OrdersListScreen> {
  int _tabIndex = 0;
  List<String> _tabs = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _setInitialTab();
    context.read<OrderBloc>().add(LoadOrders());
  }

  Future<void> _checkAndShowWhatsAppGuide() async {
    if (!widget.isActive) return;
    final state = context.read<OrderBloc>().state;
    if (state is OrdersLoaded && state.orders.length == 1) {
      final prefs = await SharedPreferences.getInstance();
      final shown = prefs.getBool('walkthrough_whatsapp_done') ?? false;
      if (!shown) {
        await prefs.setBool('walkthrough_whatsapp_done', true);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ShowcaseView.get().startShowCase([WalkthroughKeys.orderWhatsAppGuide]);
        });
      }
    }
  }

  void _setInitialTab() {
    if (widget.initialStatusFilter != null) {
      switch (widget.initialStatusFilter) {
        case 'IN PROGRESS':
          _tabIndex = 1;
          break;
        case 'READY':
          _tabIndex = 2;
          break;
        case 'DELIVERED':
          _tabIndex = 3;
          break;
        default:
          _tabIndex = 0;
      }
    }
  }

  @override
  void didUpdateWidget(covariant OrdersListScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialStatusFilter != oldWidget.initialStatusFilter) {
      setState(() => _setInitialTab());
    }
    if (widget.isActive && !oldWidget.isActive) {
      _checkAndShowWhatsAppGuide();
    }
  }

  List<OrderEntity> _filterOrders(List<OrderEntity> orders) {
    var filtered = orders;
    
    // Tab filter
    switch (_tabIndex) {
      case 1: // In Progress
        filtered = filtered.where((o) => o.status == 'IN PROGRESS').toList();
        break;
      case 2: // Ready for Tri.
        filtered = filtered.where((o) => o.status == 'READY').toList();
        break;
      case 3: // Delivered
        filtered = filtered.where((o) => o.status == 'DELIVERED').toList();
        break;
    }

    // Search filter
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      filtered = filtered.where((o) => 
        (o.customerName?.toLowerCase().contains(q) ?? false) ||
        o.garmentTypes.any((t) => t.toLowerCase().contains(q))
      ).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    _tabs = [l10n.allOrders, l10n.inProgress, l10n.readyForTrial, l10n.delivered];
    final c = getThemeBaseColors(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final topGradient = isDark
        ? c.colorPrimaryDark.withValues(alpha: 0.8)
        : c.colorAccent.withValues(alpha: 0.95);
    final midGradient = isDark
        ? c.colorPrimaryDark.withValues(alpha: 0.4)
        : c.colorAccent.withValues(alpha: 0.2);

    return Scaffold(
      backgroundColor: c.background,
      body: Stack(
        children: [
          Positioned(
            top: 0, left: 0, right: 0,
            height: MediaQuery.of(context).size.height * 0.40,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [topGradient, midGradient, c.background.withValues(alpha: 0.0)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          SafeArea(
            child: BlocListener<OrderBloc, OrderState>(
              listener: (context, state) {
                if (state is OrdersLoaded) {
                  _checkAndShowWhatsAppGuide();
                }
              },
              child: BlocBuilder<OrderBloc, OrderState>(
                builder: (context, state) {
                  final filtered = state is OrdersLoaded ? _filterOrders(state.orders) : <OrderEntity>[];
                
                return CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeader(c, isDark, l10n),
                            const SizedBox(height: 18),
                            _buildSearchBar(c, isDark, l10n),
                            const SizedBox(height: 16),
                            _buildTabChips(c, l10n),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),

                    if (state is OrderLoading)
                      const SliverToBoxAdapter(
                        child: Center(child: Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: CircularProgressIndicator(),
                        )),
                      )
                    else if (state is OrderError)
                      SliverToBoxAdapter(
                        child: Center(child: Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Text(state.message, style: GoogleFonts.poppins(color: c.red)),
                        )),
                      )
                    else if (state is OrdersLoaded)
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final o = filtered[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: GestureDetector(
                                  onTap: () async {
                                    await context.push(AppRoutes.orderDetail, extra: o);
                                  },
                                  child: _buildOrderCard(c, isDark, o, l10n, isFirstItem: index == 0),
                                ),
                              );
                            },
                            childCount: filtered.length,
                          ),
                        ),
                      ),
                    
                    if (state is OrdersLoaded && filtered.isEmpty)
                      SliverToBoxAdapter(
                        child: AppEmptyState(
                          icon: Icons.inventory_2_outlined,
                          title: l10n.noOrdersFound,
                          message: _searchQuery.isEmpty 
                            ? 'Tap the + button to create a new order and start tracking your work.'
                            : 'No orders match your search criteria.',
                        ),
                      ),
                    
                    const SliverToBoxAdapter(child: SizedBox(height: 100)),
                  ],
                );
              },
            ),
          ),
          ),
          _buildFAB(c),
        ],
      ),
    );
  }

  Widget _buildHeader(AppColorScheme c, bool isDark, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.orders.toUpperCase(),
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: c.textDark.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          l10n.shopOrders,
          style: GoogleFonts.poppins(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: c.textDark,
            height: 1.15,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(AppColorScheme c, bool isDark, AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? c.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        onChanged: (v) => setState(() => _searchQuery = v),
        style: GoogleFonts.poppins(fontSize: 14, color: c.textDark),
        decoration: InputDecoration(
          hintText: l10n.searchPlaceholder,
          hintStyle: GoogleFonts.poppins(fontSize: 13, color: c.gray),
          prefixIcon: Icon(Icons.search, color: c.gray, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildTabChips(AppColorScheme c, AppLocalizations l10n) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_tabs.length, (i) {
          final sel = _tabIndex == i;
          return GestureDetector(
            onTap: () => setState(() => _tabIndex = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
              decoration: BoxDecoration(
                color: sel ? c.colorPrimary : Colors.transparent,
                border: Border.all(color: sel ? c.colorPrimary : c.divider),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                _tabs[i],
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: sel ? Colors.white : c.textDark,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildOrderCard(AppColorScheme c, bool isDark, OrderEntity o, AppLocalizations l10n, {bool isFirstItem = false}) {
    final statusColor = _getStatusColor(o.status, c);
    final statusBg = _getStatusBg(o.status, c);
    final accentColor = _getAccentColor(o.status, c);
    final dueInfo = _getDueInfo(o, l10n);

    return Stack(
      children: [
        Positioned(
          left: 0, top: 0, bottom: 0,
          child: Container(
            width: 45,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 4),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: isDark ? c.cardDark : Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: -32, right: -32,
                child: Container(
                  width: 90, height: 90,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          o.customerName ?? 'No Name',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: c.textDark,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: statusBg,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            o.status == 'IN PROGRESS' ? l10n.inProgress.toUpperCase() : 
                            o.status == 'READY' ? l10n.readyForTrial.toUpperCase() :
                            o.status == 'DELIVERED' ? l10n.delivered.toUpperCase() :
                            o.status.toUpperCase(),
                            style: GoogleFonts.poppins(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.4,
                              color: statusColor,
                            ),
                          ),
                        ),
                        const Spacer(),
                        if (isFirstItem)
                          Showcase(
                            key: WalkthroughKeys.orderWhatsAppGuide,
                            description: l10n.walkthroughWhatsApp,
                            targetBorderRadius: BorderRadius.circular(18),
                            targetPadding: const EdgeInsets.all(6),
                            child: GestureDetector(
                              onTap: () async {
                                if (o.customerPhone != null && o.customerPhone!.isNotEmpty) {
                                  final phone = o.customerPhone!.replaceAll(RegExp(r'[^\d+]'), '');
                                  final url = Uri.parse('https://wa.me/$phone');
                                  if (await canLaunchUrl(url)) {
                                    await launchUrl(url, mode: LaunchMode.externalApplication);
                                  } else {
                                    if (!mounted) return;
                                    showAppSnackBar(context, message: 'Could not launch WhatsApp', isError: true);
                                  }
                                } else {
                                  if (!mounted) return;
                                  showAppSnackBar(context, message: 'No phone number available', isError: true);
                                }
                              },
                              child: Container(
                                width: 36, height: 36,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF25D366).withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const FaIcon(
                                  FontAwesomeIcons.whatsapp,
                                  color: Color(0xFF25D366),
                                  size: 16,
                                ),
                              ),
                            ),
                          )
                        else
                          GestureDetector(
                            onTap: () async {
                              if (o.customerPhone != null && o.customerPhone!.isNotEmpty) {
                                final phone = o.customerPhone!.replaceAll(RegExp(r'[^\d+]'), '');
                                final url = Uri.parse('https://wa.me/$phone');
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(url, mode: LaunchMode.externalApplication);
                                } else {
                                  if (!mounted) return;
                                  showAppSnackBar(context, message: 'Could not launch WhatsApp', isError: true);
                                }
                              } else {
                                if (!mounted) return;
                                showAppSnackBar(context, message: 'No phone number available', isError: true);
                              }
                            },
                            child: Container(
                              width: 36, height: 36,
                              decoration: BoxDecoration(
                                color: const Color(0xFF25D366).withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const FaIcon(
                                FontAwesomeIcons.whatsapp,
                                color: Color(0xFF25D366),
                                size: 16,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '#${o.id.length > 8 ? o.id.substring(0, 8).toUpperCase() : o.id.toUpperCase()} • ${o.garmentTypes.join(", ")}',
                      style: GoogleFonts.poppins(fontSize: 12.5, color: c.gray),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(dueInfo.icon, size: 14, color: dueInfo.color),
                        const SizedBox(width: 5),
                        Text(
                          dueInfo.label,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: dueInfo.color,
                          ),
                        ),
                        const Spacer(),
                        if (o.status == 'IN PROGRESS')
                          _buildShortProgressBar(0.5, accentColor), // Placeholder progress
                        if (o.status == 'READY')
                          _buildMarkDeliveredButton(c, l10n),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShortProgressBar(double progress, Color color) {
    return Container(
      width: 90, height: 6,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: progress.clamp(0.0, 1.0),
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMarkDeliveredButton(AppColorScheme c, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        l10n.markDelivered,
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildFAB(AppColorScheme c) {
    final l10n = AppLocalizations.of(context);
    return Positioned(
      bottom: 24, right: 20,
      child: Showcase(
        key: WalkthroughKeys.ordersAddButton,
        description: l10n.walkthroughOrdersAdd,
        targetBorderRadius: BorderRadius.circular(20),
        targetPadding: const EdgeInsets.all(8),
        child: GestureDetector(
          onTap: () {
            getIt<OrderWizardBloc>().add(const StartOrderWizard());
            context.push(AppRoutes.createOrder);
          },
          child: Container(
            width: 56, height: 56,
            decoration: BoxDecoration(
              color: c.colorPrimary,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: c.colorPrimary.withValues(alpha: 0.45),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 28),
          ),
        ),
      ),
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  Color _getStatusColor(String status, AppColorScheme c) {
    switch (status) {
      case 'IN PROGRESS': return const Color(0xFFF57C00);
      case 'READY': return const Color(0xFF2E7D32);
      case 'OVERDUE': return const Color(0xFFE53935);
      case 'DELIVERED': return const Color(0xFF2E7D32);
      default: return c.gray;
    }
  }

  Color _getStatusBg(String status, AppColorScheme c) {
    switch (status) {
      case 'IN PROGRESS': return const Color(0xFFFFF3E0);
      case 'READY': return const Color(0xFFE8F5E9);
      case 'OVERDUE': return const Color(0xFFFFECEC);
      case 'DELIVERED': return const Color(0xFFE8F5E9);
      default: return c.divider.withValues(alpha: 0.3);
    }
  }

  Color _getAccentColor(String status, AppColorScheme c) {
    switch (status) {
      case 'IN PROGRESS': return c.colorPrimary;
      case 'READY': return const Color(0xFF43A047);
      case 'OVERDUE': return const Color(0xFFE53935);
      case 'DELIVERED': return Colors.grey;
      default: return c.colorPrimary;
    }
  }

  _DueInfo _getDueInfo(OrderEntity o, AppLocalizations l10n) {
    if (o.status == 'DELIVERED') {
      return _DueInfo(l10n.delivered, Colors.grey, Icons.check_circle_outline);
    }
    if (o.deliveryDate == null) {
      return _DueInfo(l10n.noDueDate, Colors.grey, Icons.calendar_today_outlined);
    }
    
    final now = DateTime.now();
    final diff = o.deliveryDate!.difference(now).inDays;
    
    if (diff < 0) {
      return _DueInfo(l10n.overdueBy(diff.abs()), const Color(0xFFE53935), Icons.access_time_outlined);
    } else if (diff == 0) {
      return _DueInfo(l10n.dueToday, const Color(0xFFF57C00), Icons.access_time_outlined);
    } else {
      return _DueInfo(l10n.dueIn(diff), AppColors.light.colorPrimary, Icons.calendar_today_outlined);
    }
  }
}

class _DueInfo {
  final String label;
  final Color color;
  final IconData icon;
  _DueInfo(this.label, this.color, this.icon);
}
