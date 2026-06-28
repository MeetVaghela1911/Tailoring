import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tailoring_flutter/features/orders/presentation/order_detail_screen.dart';
import 'package:tailoring_flutter/features/orders/domain/entities/order_entity.dart';
import 'package:tailoring_flutter/features/orders/presentation/bloc/order_bloc.dart';
import 'package:tailoring_flutter/features/orders/presentation/bloc/order_event.dart';
import 'package:tailoring_flutter/features/orders/presentation/bloc/order_state.dart';
import 'package:tailoring_flutter/features/orders/presentation/bloc/order_wizard_bloc.dart';
import 'package:tailoring_flutter/core/utility/dependency_injection.dart';
import 'package:tailoring_flutter/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tailoring_flutter/features/orders/data/order_form_data.dart';
import '../../../test_helpers.dart';


void main() {
  late MockOrderBloc mockOrderBloc;
  late MockOrderWizardBloc mockOrderWizardBloc;
  late OrderEntity testOrder;

  setUpAll(() {
    TestHelper.registerFallbackValues();
  });

  setUp(() {
    mockOrderBloc = MockOrderBloc();
    mockOrderWizardBloc = MockOrderWizardBloc();
    
    // Set viewport size
    final window = TestWidgetsFlutterBinding.ensureInitialized().platformDispatcher.implicitView!;
    window.physicalSize = const Size(1080, 2400);
    window.devicePixelRatio = 1.0;

    if (getIt.isRegistered<OrderWizardBloc>()) {
      getIt.unregister<OrderWizardBloc>();
    }
    getIt.registerSingleton<OrderWizardBloc>(mockOrderWizardBloc);

    testOrder = OrderEntity(
      id: 'order_12345678',
      customerId: 'cust_1',
      customerName: 'John Doe',
      customerPhone: '1234567890',
      garmentTypes: const ['Shirt'],
      garmentQuantities: const {'Shirt': 1},
      garmentPrices: const {'Shirt': 500},
      specialInstructions: 'Large buttons',
      measurements: const {'Shirt': 'Neck: 15, Chest: 40'},
      deliveryDate: DateTime.now().add(const Duration(days: 7)),
      priorityIndex: 1, // High
      assignedTailor: 'Master Ji',
      totalAmount: 500,
      advancePaid: 200,
      paymentMode: 0, // Cash
      status: 'IN PROGRESS',
      createdAt: DateTime.now(),
      measurementNotes: const {},
    );

    when(() => mockOrderBloc.state).thenReturn(OrderInitial());
    when(() => mockOrderWizardBloc.state).thenReturn(
      const OrderWizardState(formData: OrderFormData()),
    );
  });

  Widget createWidgetUnderTest({OrderEntity? order}) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: BlocProvider<OrderBloc>.value(
        value: mockOrderBloc,
        child: OrderDetailScreen(order: order ?? testOrder),
      ),
    );
  }

  testWidgets('renders order details correctly', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('#ORDER_12'), findsOneWidget); 
    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('1234567890'), findsOneWidget);
    expect(find.text('Shirt'), findsOneWidget);
    expect(find.text('Large buttons'), findsOneWidget);
    expect(find.text('Master Ji'), findsOneWidget);
    
    expect(find.textContaining('500.00'), findsAtLeastNWidgets(1));
    expect(find.textContaining('200.00'), findsOneWidget);
    expect(find.textContaining('300.00'), findsOneWidget);
  });

  testWidgets('shows delete confirmation dialog', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();

    expect(find.text('Delete Order?'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);
  });

  testWidgets('status picker updates order status', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    await tester.tap(find.text('In Progress'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ready').last);
    await tester.pumpAndSettle();

    verify(() => mockOrderBloc.add(any(that: isA<UpdateOrder>()))).called(1);
  });

  testWidgets('renders overdue status badge', (tester) async {
    final overdueOrder = testOrder.copyWith(
      deliveryDate: DateTime.now().subtract(const Duration(days: 1)),
      status: 'OVERDUE',
    );

    await tester.pumpWidget(createWidgetUnderTest(order: overdueOrder));
    await tester.pumpAndSettle();

    expect(find.text('Overdue'), findsOneWidget);
  });
}
