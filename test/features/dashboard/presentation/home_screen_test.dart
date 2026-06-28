import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tailoring_flutter/core/services/analytics_service.dart';
import 'package:tailoring_flutter/core/utility/dependency_injection.dart';
import 'package:tailoring_flutter/features/auth/bloc/auth_bloc.dart';
import 'package:tailoring_flutter/features/auth/bloc/auth_state.dart';
import 'package:tailoring_flutter/features/customers/presentation/bloc/customer_bloc.dart';
import 'package:tailoring_flutter/features/customers/presentation/bloc/customer_state.dart';
import 'package:tailoring_flutter/features/dashboard/presentation/home_screen.dart';
import 'package:tailoring_flutter/features/onboarding/presentation/bloc/walkthrough_cubit.dart';
import 'package:tailoring_flutter/features/orders/presentation/bloc/order_bloc.dart';
import 'package:tailoring_flutter/features/orders/presentation/bloc/order_state.dart';
import 'package:tailoring_flutter/features/orders/presentation/bloc/order_wizard_bloc.dart';
import 'package:tailoring_flutter/features/templates/presentation/bloc/template_bloc.dart';
import 'package:tailoring_flutter/features/templates/presentation/bloc/template_state.dart';
import 'package:tailoring_flutter/l10n/app_localizations.dart';

// Mocks
class MockCustomerBloc extends Mock implements CustomerBloc {}
class MockTemplateBloc extends Mock implements TemplateBloc {}
class MockOrderBloc extends Mock implements OrderBloc {}
class MockAuthBloc extends Mock implements AuthBloc {}
class MockWalkthroughCubit extends Mock implements WalkthroughCubit {}
class MockAnalyticsService extends Mock implements AnalyticsService {}
class MockOrderWizardBloc extends Mock implements OrderWizardBloc {}

void main() {
  late MockCustomerBloc mockCustomerBloc;
  late MockTemplateBloc mockTemplateBloc;
  late MockOrderBloc mockOrderBloc;
  late MockAuthBloc mockAuthBloc;
  late MockWalkthroughCubit mockWalkthroughCubit;
  late MockAnalyticsService mockAnalyticsService;

  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
    getIt.registerLazySingleton<AnalyticsService>(() => MockAnalyticsService());
    getIt.registerLazySingleton<OrderWizardBloc>(() => MockOrderWizardBloc());
  });

  setUp(() {
    mockCustomerBloc = MockCustomerBloc();
    mockTemplateBloc = MockTemplateBloc();
    mockOrderBloc = MockOrderBloc();
    mockAuthBloc = MockAuthBloc();
    mockWalkthroughCubit = MockWalkthroughCubit();
    mockAnalyticsService = getIt<AnalyticsService>() as MockAnalyticsService;

    // Default states
    when(() => mockCustomerBloc.state).thenReturn(CustomerInitial());
    when(() => mockCustomerBloc.stream).thenAnswer((_) => const Stream.empty());

    when(() => mockTemplateBloc.state).thenReturn(TemplateInitial());
    when(() => mockTemplateBloc.stream).thenAnswer((_) => const Stream.empty());

    when(() => mockOrderBloc.state).thenReturn(OrderInitial());
    when(() => mockOrderBloc.stream).thenAnswer((_) => const Stream.empty());

    when(() => mockAuthBloc.state).thenReturn(AuthInitial());
    when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream.empty());

    when(() => mockWalkthroughCubit.state).thenReturn(WalkthroughInitial());
    when(() => mockWalkthroughCubit.stream).thenAnswer((_) => const Stream.empty());
    
    // Default analytics
    when(() => mockAnalyticsService.trackPageVisit(any())).thenAnswer((_) async {});
  });

  tearDownAll(() {
    getIt.reset();
  });

  Widget buildTestWidget() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: ShowCaseWidget(
        builder: (context) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<CustomerBloc>.value(value: mockCustomerBloc),
              BlocProvider<TemplateBloc>.value(value: mockTemplateBloc),
              BlocProvider<OrderBloc>.value(value: mockOrderBloc),
              BlocProvider<AuthBloc>.value(value: mockAuthBloc),
              BlocProvider<WalkthroughCubit>.value(value: mockWalkthroughCubit),
            ],
            child: const HomeScreen(),
          );
        },
      ),
    );
  }

  group('HomeScreen Widget Tests', () {
    testWidgets('renders basic dashboard layout correctly', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Check header
      expect(find.textContaining('OWNER DASHBOARD'), findsOneWidget);
      expect(find.textContaining('Welcome,'), findsOneWidget);

      await tester.drag(find.byType(ListView), const Offset(0, -500));
      await tester.pumpAndSettle();

      // Check quick actions
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.person_add_alt), findsOneWidget);

      // Check bottom nav items
      expect(find.byIcon(Icons.home_filled), findsOneWidget);
      expect(find.byIcon(Icons.receipt_long_outlined), findsOneWidget);
      expect(find.byIcon(Icons.dashboard_outlined), findsOneWidget);
      expect(find.byIcon(Icons.group_outlined), findsOneWidget);
      expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
    });

    testWidgets('overview grid loads with defaults when OrderInitial', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Today\'s Deliveries'), findsOneWidget);
      expect(find.text('Overdue'), findsOneWidget);
      expect(find.text('In Progress'), findsOneWidget);
      expect(find.text('0'), findsNWidgets(3)); // 0 for deliveries, overdue, in progress
    });
    
    testWidgets('navigates to different tabs on bottom navigation click', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Initially on Home (index 0)
      expect(find.text('OWNER DASHBOARD'), findsOneWidget);

      // Tap Orders tab
      await tester.tap(find.byIcon(Icons.receipt_long_outlined));
      await tester.pumpAndSettle();

      // Verify Orders tab is visible (it should show a specific text from OrdersListScreen)
      // We can check if `OWNER DASHBOARD` is gone to verify it switched.
      expect(find.text('OWNER DASHBOARD'), findsNothing);
      verify(() => mockAnalyticsService.trackPageVisit('tab_home_orders')).called(1);

      // Tap Customers tab
      await tester.tap(find.byIcon(Icons.group_outlined));
      await tester.pumpAndSettle();
      verify(() => mockAnalyticsService.trackPageVisit('tab_home_customers')).called(1);
    });
  });
}
