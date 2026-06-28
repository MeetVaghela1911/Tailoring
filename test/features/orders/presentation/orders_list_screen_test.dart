import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:tailoring_flutter/features/orders/presentation/orders_list_screen.dart';
import 'package:tailoring_flutter/features/orders/presentation/bloc/order_bloc.dart';
import 'package:tailoring_flutter/features/orders/presentation/bloc/order_event.dart';
import 'package:tailoring_flutter/features/orders/presentation/bloc/order_state.dart';
import 'package:tailoring_flutter/features/onboarding/presentation/bloc/walkthrough_cubit.dart';
import 'package:tailoring_flutter/features/orders/domain/entities/order_entity.dart';
import 'package:tailoring_flutter/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:tailoring_flutter/features/orders/presentation/bloc/order_wizard_bloc.dart';
import '../../../test_helpers.dart';
import 'package:tailoring_flutter/core/utility/dependency_injection.dart';

class MockOrderBloc extends Mock implements OrderBloc {}

void main() {
  late FakeOrderBloc fakeOrderBloc;
  late FakeWalkthroughCubit fakeWalkthroughCubit;
  late MockOrderWizardBloc mockOrderWizardBloc;

  setUpAll(() {
    TestHelper.registerFallbackValues();
    registerFallbackValue(OrderInitial());
    registerFallbackValue(LoadOrders());
  });

  setUp(() {
    fakeOrderBloc = FakeOrderBloc(OrderInitial());
    fakeWalkthroughCubit = FakeWalkthroughCubit(WalkthroughInitial());
    mockOrderWizardBloc = MockOrderWizardBloc();
    
    // Set viewport size
    final window = TestWidgetsFlutterBinding.ensureInitialized().platformDispatcher.implicitView!;
    window.physicalSize = const Size(1080, 2400);
    window.devicePixelRatio = 1.0;

    // Register dependencies in getIt
    if (getIt.isRegistered<OrderWizardBloc>()) {
      getIt.unregister<OrderWizardBloc>();
    }
    getIt.registerSingleton<OrderWizardBloc>(mockOrderWizardBloc);
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: ShowCaseWidget(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider<OrderBloc>.value(value: fakeOrderBloc),
            BlocProvider<WalkthroughCubit>.value(value: fakeWalkthroughCubit),
          ],
          child: const OrdersListScreen(),
        ),
      ),
    );
  }

  final tOrders = [
    OrderEntity(
      id: '1',
      customerName: 'John Doe',
      customerPhone: '1234567890',
      garmentTypes: const ['Shirt'],
      specialInstructions: '',
      measurements: const {},
      priorityIndex: 0,
      assignedTailor: '',
      totalAmount: 1000,
      advancePaid: 500,
      paymentMode: 0,
      status: 'Pending',
      deliveryDate: DateTime.now().add(const Duration(days: 2)),
      createdAt: DateTime.now(),
    ),
    OrderEntity(
      id: '2',
      customerName: 'Jane Smith',
      customerPhone: '9876543210',
      garmentTypes: const ['Trousers'],
      specialInstructions: 'Slim fit',
      measurements: const {'waist': '32', 'length': '40'},
      priorityIndex: 1,
      assignedTailor: '',
      totalAmount: 1200,
      advancePaid: 500,
      paymentMode: 0,
      status: 'Overdue',
      deliveryDate: DateTime.now().subtract(const Duration(days: 2)),
      createdAt: DateTime.now(),
    ),
  ];

  testWidgets('renders screen title', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();
    expect(find.text('ORDERS'), findsOneWidget);
  });

  testWidgets('renders empty state when no orders', (WidgetTester tester) async {
    fakeOrderBloc.emit(const OrdersLoaded([]));
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();
    expect(find.text('No orders found'), findsOneWidget);
  });

  testWidgets('renders list of orders', (WidgetTester tester) async {
    fakeOrderBloc.emit(OrdersLoaded(tOrders));
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    
    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('Jane Smith'), findsOneWidget);
  });

  testWidgets('filters orders based on search', (WidgetTester tester) async {
    fakeOrderBloc.emit(OrdersLoaded(tOrders));
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'John');
    await tester.pumpAndSettle();

    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('Jane Smith'), findsNothing);
  });

  testWidgets('identifies overdue orders', (WidgetTester tester) async {
    fakeOrderBloc.emit(OrdersLoaded(tOrders));
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.textContaining('Overdue by 2 days'), findsOneWidget);
  });
}

class FakeOrderBloc extends Fake implements OrderBloc {
  OrderState _state;
  final List<OrderEvent> addedEvents = [];

  FakeOrderBloc(this._state);

  @override
  OrderState get state => _state;

  @override
  Stream<OrderState> get stream => Stream.value(_state);

  @override
  void emit(OrderState newState) {
    _state = newState;
  }

  @override
  void add(OrderEvent event) {
    addedEvents.add(event);
  }

  @override
  Future<void> close() async {}
}
