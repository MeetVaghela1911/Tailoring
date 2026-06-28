import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../../core/services/analytics_service.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/common_methods.dart';
import 'package:tailoring_flutter/l10n/app_localizations.dart';
import '../../../routes/app_router.dart';
import '../../orders/presentation/orders_list_screen.dart';
import '../../templates/presentation/templates_screen.dart';
import '../../customers/presentation/customers_list_screen.dart';
import '../../onboarding/presentation/settings_screen.dart';
import '../../orders/presentation/bloc/order_bloc.dart';
import '../../orders/presentation/bloc/order_event.dart';
import '../../orders/presentation/bloc/order_state.dart';
import '../../orders/domain/entities/order_entity.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_state.dart';
import '../../../core/utility/dependency_injection.dart';
import '../../orders/presentation/bloc/order_wizard_bloc.dart';
import '../../customers/presentation/bloc/customer_bloc.dart';
import '../../customers/presentation/bloc/customer_state.dart';
import '../../templates/presentation/bloc/template_bloc.dart';
import '../../templates/presentation/bloc/template_state.dart';
import '../../customers/presentation/bloc/customer_event.dart';
import '../../templates/presentation/bloc/template_event.dart';
import '../../onboarding/presentation/bloc/walkthrough_cubit.dart';
import '../../onboarding/presentation/utils/walkthrough_keys.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _bottomNavIndex = 0;
  String? _ordersStatusFilter;

  int _customersCount = 0;
  int _templatesCount = 0;
  int _ordersCount = 0;

  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(LoadOrders());
    context.read<CustomerBloc>().add(LoadCustomers());
    context.read<TemplateBloc>().add(LoadTemplates());
  }

  void _triggerWalkthroughCheck() {
    context.read<WalkthroughCubit>().checkWalkthroughState(
      customersCount: _customersCount,
      templatesCount: _templatesCount,
      ordersCount: _ordersCount,
    );
  }

  void _logTabVisit(int index) {
    final tabNames = [
      'home_overview',
      'home_orders',
      'home_templates',
      'home_customers',
      'home_settings',
    ];
    if (index < tabNames.length) {
      getIt<AnalyticsService>().trackPageVisit('tab_${tabNames[index]}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = getThemeBaseColors(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: isDark ? c.cardDark : Colors.white,
        systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
    );

    return PopScope(
      canPop: _bottomNavIndex == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _bottomNavIndex != 0) {
          setState(() {
            _bottomNavIndex = 0;
            _ordersStatusFilter = null;
          });
          _logTabVisit(0);
        }
      },
      child: MultiBlocListener(
        listeners: [
          BlocListener<CustomerBloc, CustomerState>(
            listener: (context, state) {
              if (state is CustomersLoaded) {
                _customersCount = state.customers.length;
                _triggerWalkthroughCheck();
              }
            },
          ),
          BlocListener<TemplateBloc, TemplateState>(
            listener: (context, state) {
              if (state is TemplatesLoaded) {
                _templatesCount = state.templates.length;
                _triggerWalkthroughCheck();
              }
            },
          ),
          BlocListener<OrderBloc, OrderState>(
            listener: (context, state) {
              if (state is OrdersLoaded) {
                _ordersCount = state.orders.length;
                _triggerWalkthroughCheck();
              }
            },
          ),
          BlocListener<WalkthroughCubit, WalkthroughState>(
            listener: (context, state) {
              final cubit = context.read<WalkthroughCubit>();
              if (state is WalkthroughStepCreateCustomer) {
                if (!cubit.isCustomerShown) {
                  cubit.markCustomerShown();
                  setState(() {
                    _bottomNavIndex = 0;
                  });
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ShowcaseView.get().startShowCase([WalkthroughKeys.homeAddCustomerFab]);
                  });
                }
              } else if (state is WalkthroughStepCreateTemplate) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_bottomNavIndex == 0) {
                    if (!cubit.isTemplateTabShown) {
                      cubit.markTemplateTabShown();
                      ShowcaseView.get().startShowCase([WalkthroughKeys.bottomNavTemplates]);
                    }
                  } else if (_bottomNavIndex == 2) {
                    if (!cubit.isTemplateScreenShown) {
                      cubit.markTemplateScreenShown();
                      ShowcaseView.get().startShowCase([
                        WalkthroughKeys.templatesQuickStart,
                        WalkthroughKeys.templatesAddButton,
                      ]);
                    }
                  }
                });
              } else if (state is WalkthroughStepCreateOrder) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_bottomNavIndex == 1) {
                    if (!cubit.isOrderScreenShown) {
                      cubit.markOrderScreenShown();
                      ShowcaseView.get().startShowCase([WalkthroughKeys.ordersAddButton]);
                    }
                  } else {
                    if (!cubit.isOrderTabShown) {
                      cubit.markOrderTabShown();
                      ShowcaseView.get().startShowCase([WalkthroughKeys.bottomNavOrders]);
                    }
                  }
                });
              }
            },
          ),
        ],
        child: Builder(
          builder: (context) {
            return Scaffold(
              backgroundColor: c.background,
              body: Stack(
                children: [
                  IndexedStack(
                    index: _bottomNavIndex,
                    children: [
                      _buildHomeContent(c),
                      OrdersListScreen(
                        initialStatusFilter: _ordersStatusFilter,
                        isActive: _bottomNavIndex == 1,
                      ),
                      const TemplatesScreen(),
                      const CustomersListScreen(),
                      const SettingsScreen(),
                    ],
                  ),
                ],
              ),
              bottomNavigationBar: _buildBottomNav(c),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHomeContent(AppColorScheme c) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final topGradientColor = isDark
        ? c.colorPrimaryDark.withValues(alpha: 0.8)
        : c.colorAccent.withValues(alpha: 0.95);
    final midGradientColor = isDark
        ? c.colorPrimaryDark.withValues(alpha: 0.4)
        : c.colorAccent.withValues(alpha: 0.2);
    final l10n = AppLocalizations.of(context);

    return Stack(
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
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            children: [
              _buildHeaderInfo(c),
              const SizedBox(height: 32),
              Text(
                l10n.overview,
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: c.textDark),
              ),
              const SizedBox(height: 16),
              BlocBuilder<OrderBloc, OrderState>(
                builder: (context, state) {
                  if (state is OrdersLoaded) {
                    return _buildOverviewGrid(c, state.orders);
                  }
                  return _buildOverviewGrid(c, []); // Empty/Loading fallback
                },
              ),
              const SizedBox(height: 36),
              _buildQuickActions(c),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderInfo(AppColorScheme c) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.ownerDashboard.toUpperCase(),
          style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: c.textDark.withValues(alpha: 0.6)),
        ),
        const SizedBox(height: 8),
        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            String userName = 'Owner';
            if (state is AuthAuthenticated) {
              final user = state.user;
              final fullName = user.profile?.fullName ?? user.name ?? '';
              if (fullName.isNotEmpty) {
                userName = fullName.split(' ').first;
              }
            }
            return Text(
              '${l10n.welcome},\n$userName',
              style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: c.textDark, height: 1.2),
            );
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Container(
              width: 8, height: 8,
              decoration: BoxDecoration(color: c.green, shape: BoxShape.circle, boxShadow: [BoxShadow(color: c.green.withValues(alpha: 0.4), blurRadius: 4)]),
            ),
            const SizedBox(width: 8),
            Text(l10n.shopCurrentlyOpen, style: GoogleFonts.poppins(fontSize: 13, color: c.textDark.withValues(alpha: 0.7))),
            Text(' ${l10n.open}', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: c.textDark)),
          ],
        ),
      ],
    );
  }

  void _navigateToOrdersWithFilter(String filter) {
    setState(() {
      _ordersStatusFilter = filter;
      _bottomNavIndex = 1;
    });
  }

  Widget _buildOverviewGrid(AppColorScheme c, List<OrderEntity> orders) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final l10n = AppLocalizations.of(context);
    
    final todayDeliveries = orders.where((o) => o.deliveryDate != null && 
        DateTime(o.deliveryDate!.year, o.deliveryDate!.month, o.deliveryDate!.day) == today).length;
    
    final overdue = orders.where((o) => o.status != 'COMPLETED' && o.deliveryDate != null && 
        o.deliveryDate!.isBefore(today)).length;
    
    final inProgress = orders.where((o) => o.status == 'IN PROGRESS').length;

    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: _overviewCard(
                    c,
                    iconBg: const Color(0xFFD1E9F4),
                    iconColor: c.colorPrimary,
                    icon: Icons.local_shipping_outlined,
                    title: l10n.todaysDeliveries,
                    value: todayDeliveries.toString(),
                    onTap: () => _navigateToOrdersWithFilter('DELIVERY_TODAY'),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: _overviewCard(
                    c,
                    iconBg: const Color(0xFFFDE8E8),
                    iconColor: c.red,
                    icon: Icons.warning_amber_rounded,
                    title: l10n.overdue,
                    value: overdue.toString(),
                    valueColor: overdue > 0 ? c.red : null,
                    onTap: () => _navigateToOrdersWithFilter('OVERDUE'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: _overviewCard(
                    c,
                    iconBg: const Color(0xFFFEF0D4),
                    iconColor: Colors.orange,
                    icon: Icons.content_cut,
                    title: l10n.inProgress,
                    value: inProgress.toString(),
                    onTap: () => _navigateToOrdersWithFilter('IN PROGRESS'),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: _overviewCard(
                    c,
                    iconBg: const Color(0xFFDAF5E1),
                    iconColor: c.green,
                    icon: Icons.monitor_outlined,
                    title: l10n.estimatedRevenue,
                    value: "Coming Soon",
                    // value: "₹${(revenue / 1000).toStringAsFixed(1)}k",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _overviewCard(AppColorScheme c, {required Color iconBg, required Color iconColor, required IconData icon, required String title, required String value, Color? valueColor, String? badgeText, Color? badgeColor, VoidCallback? onTap, GlobalKey? showcaseKey, String? showcaseDesc}) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Widget card = GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? c.cardDark : c.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 15, offset: const Offset(0, 4))],
          border: Border.all(color: c.divider.withValues(alpha: 0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                if (badgeText != null)
                  Text(badgeText, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: badgeColor)),
              ],
            ),
            const SizedBox(height: 16),
            Text(title, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w500, color: c.textDark.withValues(alpha: 0.6))),
            const SizedBox(height: 4),
            Text(value, style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: valueColor ?? c.textDark)),
          ],
        ),
      ),
    );

    if (showcaseKey != null && showcaseDesc != null) {
      return Showcase(
        key: showcaseKey,
        description: showcaseDesc,
        targetBorderRadius: BorderRadius.circular(20),
        targetPadding: const EdgeInsets.all(8),
        disposeOnTap: true,
        onTargetClick: onTap,
        child: card,
      );
    }

    return card;
  }

  Widget _buildQuickActions(AppColorScheme c) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.quickActions,
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: c.textDark),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _actionButton(
              c, 
              Icons.add, 
              l10n.newOrder, 
              () {
                getIt<OrderWizardBloc>().add(const StartOrderWizard());
                context.push(AppRoutes.createOrder);
              },
              showcaseKey: WalkthroughKeys.homeNewOrderQuickAction,
              showcaseDesc: l10n.walkthroughOrdersAdd,
            ),
            const SizedBox(width: 16),
            _actionButton(
              c, 
              Icons.person_add_alt, 
              l10n.addCust, 
              () => context.push(AppRoutes.addCustomer),
              showcaseKey: WalkthroughKeys.homeAddCustomerFab,
              showcaseDesc: l10n.walkthroughAddCustFab,
            ),
          ],
        ),
      ],
    );
  }

  Widget _actionButton(AppColorScheme c, IconData icon, String label, VoidCallback onTap, {GlobalKey? showcaseKey, String? showcaseDesc}) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    bool isPrimary = icon == Icons.add;
    
    Widget btn = GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.26,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        decoration: BoxDecoration(
          color: isPrimary ? c.colorPrimary : (isDark ? c.cardDark : Colors.white),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 15, offset: const Offset(0, 4))],
          border: Border.all(color: isPrimary ? c.colorPrimary : c.divider.withValues(alpha: 0.5)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isPrimary ? Colors.white.withValues(alpha: 0.25) : c.colorPrimary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: isPrimary ? Colors.white : c.colorPrimary, size: 24),
            ),
            const SizedBox(height: 12),
            Text(label, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: isPrimary ? Colors.white : c.textDark), textAlign: TextAlign.center, maxLines: 1),
          ],
        ),
      ),
    );

    if (showcaseKey != null && showcaseDesc != null) {
      return Showcase(
        key: showcaseKey,
        description: showcaseDesc,
        targetBorderRadius: BorderRadius.circular(20),
        targetPadding: const EdgeInsets.all(8),
        disposeOnTap: true,
        onTargetClick: onTap,
        child: btn,
      );
    }
    return btn;
  }

  Widget _buildBottomNav(AppColorScheme c) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? c.cardDark : Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 20, offset: const Offset(0, -4))],
      ),
      child: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _navItem(c, 0, Icons.home_filled, AppLocalizations.of(context).home),
              _navItem(
                c, 1, Icons.receipt_long_outlined, l10n.orders,
                showcaseKey: WalkthroughKeys.bottomNavOrders,
                showcaseDesc: l10n.walkthroughNavOrders,
              ),
              _navItem(
                c, 2, Icons.dashboard_outlined, l10n.templates, 
                showcaseKey: WalkthroughKeys.bottomNavTemplates, 
                showcaseDesc: l10n.walkthroughNavTemplates,
              ),
              _navItem(c, 3, Icons.group_outlined, AppLocalizations.of(context).customers),
              _navItem(c, 4, Icons.settings_outlined, AppLocalizations.of(context).settings),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(AppColorScheme c, int index, IconData icon, String label, {GlobalKey? showcaseKey, String? showcaseDesc}) {
    bool isSelected = _bottomNavIndex == index;
    Widget item = GestureDetector(
      onTap: () {
        setState(() {
          _bottomNavIndex = index;
        });
        _logTabVisit(index);
        
        // Re-evaluate walkthrough if changing tabs
        final cubit = context.read<WalkthroughCubit>();
        final walkthroughState = cubit.state;
        if (walkthroughState is WalkthroughStepCreateCustomer && index == 0) {
          if (!cubit.isCustomerShown) {
            cubit.markCustomerShown();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ShowcaseView.get().startShowCase([WalkthroughKeys.homeAddCustomerFab]);
            });
          }
        } else if (walkthroughState is WalkthroughStepCreateTemplate && index == 2) {
          if (!cubit.isTemplateScreenShown) {
            cubit.markTemplateScreenShown();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ShowcaseView.get().startShowCase([
                WalkthroughKeys.templatesQuickStart,
                WalkthroughKeys.templatesAddButton,
              ]);
            });
          }
        } else if (walkthroughState is WalkthroughStepCreateOrder && index == 1) {
          if (!cubit.isOrderScreenShown) {
            cubit.markOrderScreenShown();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ShowcaseView.get().startShowCase([WalkthroughKeys.ordersAddButton]);
            });
          }
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? c.colorPrimary : c.gray, size: 24),
            const SizedBox(height: 2),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 4, height: 4,
              decoration: BoxDecoration(
                color: isSelected ? c.colorPrimary : Colors.transparent,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? c.colorPrimary : c.gray,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (showcaseKey != null && showcaseDesc != null) {
      return Expanded(
        child: Showcase(
          key: showcaseKey,
          description: showcaseDesc,
          targetBorderRadius: BorderRadius.circular(12),
          targetPadding: const EdgeInsets.all(6),
          child: item,
        ),
      );
    }

    return Expanded(child: item);
  }
}
