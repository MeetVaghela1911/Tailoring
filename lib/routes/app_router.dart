import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/utility/dependency_injection.dart';
import '../core/services/analytics_service.dart';
import '../core/observers/analytics_route_observer.dart';
import '../main.dart';
import '../features/auth/bloc/auth_bloc.dart';
import '../features/auth/bloc/auth_state.dart';

import '../features/customers/domain/entities/customer.dart';
import '../features/splash/presentation/splash_screen.dart';
import '../features/splash/presentation/welcome_screen.dart';
import '../features/onboarding/presentation/role_selection_screen.dart';
import '../features/onboarding/presentation/shop_setup_screen.dart';
import '../features/onboarding/presentation/all_set_screen.dart';
import '../features/onboarding/presentation/tutorial_manual_screen.dart';
import '../features/onboarding/presentation/select_language_screen.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/signup_screen.dart';
import '../features/onboarding/presentation/profile_screen.dart';
import '../features/onboarding/presentation/shop_details_screen.dart';
import '../features/onboarding/presentation/privacy_security_screen.dart';
import '../features/onboarding/presentation/help_guide_screen.dart';
import '../features/onboarding/presentation/subscription/subscription_screen.dart';
import '../features/dashboard/presentation/home_screen.dart';
import '../features/orders/presentation/create_order/create_order_customer_screen.dart';
import '../features/orders/presentation/create_order/create_order_items_screen.dart';
import '../features/orders/presentation/create_order/create_order_schedule_screen.dart';
import '../features/orders/presentation/create_order/create_order_payment_screen.dart';
import '../features/orders/presentation/create_order/create_order_success_screen.dart';
import '../features/orders/presentation/take_measurements_screen.dart';
import '../features/templates/presentation/add_template_details_screen.dart';
import '../features/templates/presentation/add_template_fields_screen.dart';
import '../features/orders/data/order_form_data.dart';
import '../features/customers/presentation/customers_list_screen.dart';
import '../features/customers/presentation/add_edit_customer_screen.dart';
import '../features/templates/presentation/template_detail_screen.dart';
import '../features/templates/domain/entities/template.dart';
import '../features/orders/presentation/order_detail_screen.dart';
import '../features/orders/domain/entities/order_entity.dart';
import '../features/payments/presentation/screens/finance_management_screen.dart';
import '../core/services/app_update_service.dart';


/// Route path constants
class AppRoutes {
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String roleSelection = '/role-selection';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String shopSetup = '/shop-setup';
  static const String allSet = '/all-set';
  static const String selectLanguage = '/select-language';
  static const String home = '/home';
  static const String customers = '/customers';
  static const String addCustomer = '/customers/add';
  static const String editCustomer = '/customers/edit';
  static const String createOrder = '/create-order';
  static const String createOrderItems = '/create-order/items';
  static const String createOrderMeasurements = '/create-order/measurements';
  static const String createOrderSchedule = '/create-order/schedule';
  static const String createOrderPayment = '/create-order/payment';
  static const String createOrderSuccess = '/create-order/success';

  // Template flow
  static const String addTemplate = '/templates/add';
  static const String addTemplateFields = '/templates/add/fields';
  static const String templateDetail = '/templates/detail';
  static const String orderDetail = '/orders/detail';
  static const String financeManagement = '/finance-management';

  // Settings & Profile
  static const String profile = '/profile';
  static const String shopDetails = '/shop-details';
  static const String subscription = '/subscription';
  static const String privacySecurity = '/privacy-security';
  static const String helpGuide = '/help-guide';
  static const String tutorial = '/tutorial';

  /// List of routes that don't require authentication
  static const List<String> publicRoutes = [
    splash,
    welcome,
    login,
    signup,
    roleSelection,
  ];
}

/// A [Listenable] that notifies listeners whenever a [Stream] emits a value.
/// Used to refresh [GoRouter] when [AuthBloc] state changes.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}



class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    observers: [AnalyticsRouteObserver(getIt<AnalyticsService>())],
    refreshListenable: Listenable.merge([
      GoRouterRefreshStream(getIt<AuthBloc>().stream),
      appLocaleProvider,
      getIt<AppUpdateService>(),
    ]),
    redirect: (context, state) {
      final updateService = getIt<AppUpdateService>();
      if (updateService.isUpdateRequired) {
        // If an update is required, force stay on the splash screen
        return AppRoutes.splash;
      }

      final authState = getIt<AuthBloc>().state;
      final bool loggingIn = AppRoutes.publicRoutes.contains(state.matchedLocation);

      if (authState is AuthUnauthenticated) {
        // If not authenticated and trying to access a protected route, redirect to welcome
        return loggingIn ? null : AppRoutes.welcome;
      }

      if (authState is AuthAuthenticated) {
        final hasShop = authState.user.shop != null;
        // Allow authenticated users without shop data to reach onboarding
        final onboardingRoutes = [AppRoutes.shopSetup, AppRoutes.allSet];
        final isOnboardingRoute = onboardingRoutes.contains(state.matchedLocation);

        if (loggingIn) {
          // User is on a public/auth route — redirect based on shop status
          return hasShop ? AppRoutes.home : AppRoutes.shopSetup;
        }
        if (isOnboardingRoute && hasShop) {
          // User already has shop data but is on onboarding — send to home
          return AppRoutes.home;
        }
        return null;
      }

      // No redirect
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: AppRoutes.splash,
        pageBuilder: (context, state) =>
            _animatedPage(state: state, child: const SplashScreen()),
      ),
      GoRoute(
        path: AppRoutes.welcome,
        name: AppRoutes.welcome,
        pageBuilder: (context, state) =>
            _animatedPage(state: state, child: const WelcomeScreen()),
      ),
      GoRoute(
        path: AppRoutes.roleSelection,
        name: AppRoutes.roleSelection,
        pageBuilder: (context, state) =>
            _animatedPage(state: state, child: const RoleSelectionScreen()),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: AppRoutes.login,
        pageBuilder: (context, state) =>
            _animatedPage(state: state, child: const LoginScreen()),
      ),
      GoRoute(
        path: AppRoutes.signup,
        name: AppRoutes.signup,
        pageBuilder: (context, state) =>
            _animatedPage(state: state, child: const SignupScreen()),
      ),
      GoRoute(
        path: AppRoutes.shopSetup,
        name: AppRoutes.shopSetup,
        pageBuilder: (context, state) =>
            _animatedPage(state: state, child: const ShopSetupScreen()),
      ),
      GoRoute(
        path: AppRoutes.allSet,
        name: AppRoutes.allSet,
        pageBuilder: (context, state) =>
            _animatedPage(state: state, child: const AllSetScreen()),
      ),
      GoRoute(
        path: AppRoutes.selectLanguage,
        name: AppRoutes.selectLanguage,
        pageBuilder: (context, state) =>
            _animatedPage(state: state, child: const SelectLanguageScreen()),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: AppRoutes.home,
        pageBuilder: (context, state) =>
            _animatedPage(state: state, child: const HomeScreen()),
      ),
      GoRoute(
        path: AppRoutes.customers,
        name: AppRoutes.customers,
        pageBuilder: (context, state) =>
            _animatedPage(state: state, child: const CustomersListScreen()),
      ),
      GoRoute(
        path: AppRoutes.addCustomer,
        name: AppRoutes.addCustomer,
        pageBuilder: (context, state) =>
            _animatedPage(state: state, child: const AddEditCustomerScreen()),
      ),
      GoRoute(
        path: AppRoutes.editCustomer,
        name: AppRoutes.editCustomer,
        pageBuilder: (context, state) {
          final customer = state.extra as Customer?;
          return _animatedPage(
            state: state,
            child: AddEditCustomerScreen(customer: customer),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.createOrder,
        name: AppRoutes.createOrder,
        pageBuilder: (context, state) {
          return _animatedPage(
            state: state,
            child: const CreateOrderCustomerScreen(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.createOrderItems,
        name: AppRoutes.createOrderItems,
        pageBuilder: (context, state) {
          return _animatedPage(
            state: state,
            child: const CreateOrderItemsScreen(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.createOrderMeasurements,
        name: AppRoutes.createOrderMeasurements,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return _animatedPage(
            state: state,
            child: TakeMeasurementsScreen(
              garmentTypes: extra['garmentTypes'] as List<String>? ?? [],
              initialData: extra['initialData'] as OrderFormData?, // Keep for template flow
              isOrderFlow: extra['isOrderFlow'] as bool? ?? false,
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.createOrderSchedule,
        name: AppRoutes.createOrderSchedule,
        pageBuilder: (context, state) {
          return _animatedPage(
            state: state,
            child: const CreateOrderScheduleScreen(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.createOrderPayment,
        name: AppRoutes.createOrderPayment,
        pageBuilder: (context, state) {
          return _animatedPage(
            state: state,
            child: const CreateOrderPaymentScreen(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.createOrderSuccess,
        name: AppRoutes.createOrderSuccess,
        pageBuilder: (context, state) {
          final order = state.extra as OrderEntity?;
          return _animatedPage(
            state: state,
            child: CreateOrderSuccessScreen(order: order),
          );
        },
      ),

      // ── Template flow ─────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.addTemplate,
        name: AppRoutes.addTemplate,
        pageBuilder: (context, state) =>
            _animatedPage(state: state, child: const AddTemplateDetailsScreen()),
      ),
      GoRoute(
        path: AppRoutes.addTemplateFields,
        name: AppRoutes.addTemplateFields,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return _animatedPage(
            state: state,
            child: AddTemplateFieldsScreen(
              templateName: extra['name'] as String? ?? '',
              category: extra['category'] as String? ?? '',
              iconCodePoint: extra['iconCodePoint'] as int? ?? Icons.checkroom.codePoint,
              iconFontFamily: extra['iconFontFamily'] as String?,
              basePrice: (extra['basePrice'] as num?)?.toDouble() ?? 0.0,
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.templateDetail,
        name: AppRoutes.templateDetail,
        pageBuilder: (context, state) {
          final template = state.extra as Template;
          return _animatedPage(
            state: state,
            child: TemplateDetailScreen(template: template),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.orderDetail,
        name: AppRoutes.orderDetail,
        pageBuilder: (context, state) {
          final order = state.extra as OrderEntity;
          return _animatedPage(
            state: state,
            child: OrderDetailScreen(order: order),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.financeManagement,
        name: AppRoutes.financeManagement,
        pageBuilder: (context, state) =>
            _animatedPage(state: state, child: const FinanceManagementScreen()),
      ),

      // ── Settings & Profile ───────────────────────────────────────────
      GoRoute(
        path: AppRoutes.profile,
        name: AppRoutes.profile,
        pageBuilder: (context, state) =>
            _animatedPage(state: state, child: const ProfileScreen()),
      ),
      GoRoute(
        path: AppRoutes.shopDetails,
        name: AppRoutes.shopDetails,
        pageBuilder: (context, state) =>
            _animatedPage(state: state, child: const ShopDetailsScreen()),
      ),
      GoRoute(
        path: AppRoutes.subscription,
        name: AppRoutes.subscription,
        pageBuilder: (context, state) =>
            _animatedPage(state: state, child: const SubscriptionScreen()),
      ),
      GoRoute(
        path: AppRoutes.privacySecurity,
        name: AppRoutes.privacySecurity,
        pageBuilder: (context, state) =>
            _animatedPage(state: state, child: const PrivacySecurityScreen()),
      ),
      GoRoute(
        path: AppRoutes.helpGuide,
        name: AppRoutes.helpGuide,
        pageBuilder: (context, state) =>
            _animatedPage(state: state, child: const HelpGuideScreen()),
      ),
      GoRoute(
        path: AppRoutes.tutorial,
        name: AppRoutes.tutorial,
        pageBuilder: (context, state) =>
            _animatedPage(state: state, child: const TutorialManualScreen()),
      ),
    ],
  );

  static CustomTransitionPage _animatedPage({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      name: state.name ?? state.matchedLocation,
      arguments: state.extra,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
