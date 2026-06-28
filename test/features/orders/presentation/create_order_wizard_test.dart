import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tailoring_flutter/core/service/storage_service.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tailoring_flutter/features/orders/presentation/create_order/create_order_items_screen.dart';
import 'package:tailoring_flutter/features/orders/presentation/take_measurements_screen.dart';
import 'package:tailoring_flutter/features/orders/presentation/create_order/create_order_payment_screen.dart';
import 'package:tailoring_flutter/features/orders/presentation/bloc/order_wizard_bloc.dart';
import 'package:tailoring_flutter/features/orders/presentation/bloc/order_bloc.dart';
import 'package:tailoring_flutter/features/orders/presentation/bloc/order_event.dart';
import 'package:tailoring_flutter/features/orders/presentation/bloc/order_state.dart';
import 'package:tailoring_flutter/features/templates/presentation/bloc/template_bloc.dart';
import 'package:tailoring_flutter/features/templates/presentation/bloc/template_event.dart';
import 'package:tailoring_flutter/features/templates/presentation/bloc/template_state.dart';
import 'package:tailoring_flutter/core/utility/dependency_injection.dart';
import 'package:tailoring_flutter/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tailoring_flutter/features/orders/data/order_form_data.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:tailoring_flutter/features/templates/domain/entities/template.dart';
import 'package:tailoring_flutter/features/onboarding/presentation/bloc/walkthrough_cubit.dart';
import '../../../test_helpers.dart';

class MockOrderBloc extends MockBloc<OrderEvent, OrderState> implements OrderBloc {}
class MockTemplateBloc extends MockBloc<TemplateEvent, TemplateState> implements TemplateBloc {}
class MockWalkthroughCubit extends MockBloc<WalkthroughState, WalkthroughState> implements WalkthroughCubit {}

void main() {
  late MockOrderBloc mockOrderBloc;
  late MockTemplateBloc mockTemplateBloc;
  late OrderWizardBloc realOrderWizardBloc;
  late MockWalkthroughCubit mockWalkthroughCubit;

  setUpAll(() {
    TestHelper.registerFallbackValues();
  });

  setUp(() {
    mockOrderBloc = MockOrderBloc();
    mockTemplateBloc = MockTemplateBloc();
    realOrderWizardBloc = OrderWizardBloc();
    mockWalkthroughCubit = MockWalkthroughCubit();
    
    final window = TestWidgetsFlutterBinding.ensureInitialized().platformDispatcher.implicitView!;
    window.physicalSize = const Size(1080, 2400);
    window.devicePixelRatio = 1.0;

    if (getIt.isRegistered<OrderWizardBloc>()) {
      getIt.unregister<OrderWizardBloc>();
    }
    getIt.registerSingleton<OrderWizardBloc>(realOrderWizardBloc);

    if (getIt.isRegistered<WalkthroughCubit>()) {
      getIt.unregister<WalkthroughCubit>();
    }
    getIt.registerSingleton<WalkthroughCubit>(mockWalkthroughCubit);

    when(() => mockTemplateBloc.state).thenReturn(const TemplatesLoaded([
      Template(id: '1', name: 'Shirt', category: 'Men', fields: [], iconCodePoint: 0),
      Template(id: '2', name: 'Pant', category: 'Men', fields: [], iconCodePoint: 0),
    ]));
    when(() => mockOrderBloc.state).thenReturn(OrderInitial());
    when(() => mockWalkthroughCubit.state).thenReturn(WalkthroughInitial());
  });

  tearDown(() {
    getIt.reset();
  });

  Widget wrapWithBlocs(Widget child, {GoRouter? router}) {
    final widget = MultiBlocProvider(
      providers: [
        BlocProvider<TemplateBloc>.value(value: mockTemplateBloc),
        BlocProvider<OrderBloc>.value(value: mockOrderBloc),
        BlocProvider<WalkthroughCubit>.value(value: mockWalkthroughCubit),
      ],
      child: child,
    );

    if (router != null) {
      return ShowCaseWidget(
        builder: (context) => MaterialApp.router(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en')],
          routerConfig: router,
        ),
      );
    }

    return ShowCaseWidget(
      builder: (context) => MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
        home: widget,
      ),
    );
  }

  testWidgets('Wizard Step 1: Items Screen persistence', (tester) async {
    
    // For MaterialApp.router to work with mockRouter, we need to set up its delegate and provider
    // Or simpler, just use a real GoRouter with a dummy route.
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (context, state) => const CreateOrderItemsScreen()),
        GoRoute(path: '/measurements', builder: (context, state) => const Text('Measurements Screen')),
      ],
    );

    await tester.pumpWidget(MultiBlocProvider(
      providers: [
        BlocProvider<TemplateBloc>.value(value: mockTemplateBloc),
        BlocProvider<OrderBloc>.value(value: mockOrderBloc),
        BlocProvider<WalkthroughCubit>.value(value: mockWalkthroughCubit),
      ],
      child: ShowCaseWidget(
        builder: (context) => MaterialApp.router(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en')],
          routerConfig: router,
        ),
      ),
    ));
    await tester.pumpAndSettle();

    // Select Shirt
    await tester.tap(find.text('Shirt'));
    await tester.pump();

    // Enter special instructions
    await tester.enterText(find.byType(TextField), 'Test instructions');
    await tester.pump();

    // Tap Next
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Verify Bloc state
    expect(realOrderWizardBloc.state.formData.garmentTypes, contains('Shirt'));
    expect(realOrderWizardBloc.state.formData.specialInstructions, 'Test instructions');
  });

  testWidgets('Wizard Step 2: Measurements Screen persistence', (tester) async {
    // Pre-fill Step 1 data
    realOrderWizardBloc.add(const UpdateOrderData(OrderFormData(
      garmentTypes: ['Shirt'],
      garmentQuantities: {'Shirt': 1},
    )));
    
    await tester.pumpWidget(wrapWithBlocs(const TakeMeasurementsScreen(
      garmentTypes: ['Shirt'],
      isOrderFlow: true,
    )));
    await tester.pumpAndSettle();

    expect(find.textContaining('Measurement'), findsWidgets);
  });

  testWidgets('Wizard Step 4: Payment Screen and Order Submission', (tester) async {
    // Pre-fill all data up to Step 4
    realOrderWizardBloc.add(UpdateOrderData(OrderFormData(
      existingOrderRef: 'temp_id',
      customerId: 'cust_1',
      customerName: 'Test Customer',
      garmentTypes: const ['Shirt'],
      garmentQuantities: const {'Shirt': 1},
      garmentPrices: const {'Shirt': 1000},
      totalAmount: 1000,
      deliveryDate: DateTime.now().add(const Duration(days: 5)),
    )));

    await tester.pumpWidget(wrapWithBlocs(const CreateOrderPaymentScreen()));
    await tester.pumpAndSettle();

    // Verify amount is shown
    expect(find.textContaining('1000'), findsWidgets);

    // Enter advance
    // The advance controller is the one with '0.00' (initial value)
    await tester.enterText(find.widgetWithText(TextField, '0.00'), '500');
    await tester.pump();

    // Tap "Create Order" or "Save Changes"
    await tester.tap(find.widgetWithText(ElevatedButton, 'Create Order'));
    await tester.pumpAndSettle();

    // Verify CreateOrder event dispatched to OrderBloc
    verify(() => mockOrderBloc.add(any(that: isA<CreateOrder>()))).called(1);
  });

  testWidgets('Wizard Step 1: Validation - no garment selected', (tester) async {
    await tester.pumpWidget(wrapWithBlocs(const CreateOrderItemsScreen()));
    await tester.pumpAndSettle();

    // Tap Next without selecting anything
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Verify SnackBar or error message
    // Note: showAppSnackBar uses ScaffoldMessenger
    expect(find.byType(SnackBar), findsOneWidget);
    
    // Check if navigation didn't happen (still on Step 1)
    expect(find.byType(CreateOrderItemsScreen), findsOneWidget);
  });

  testWidgets('Wizard Step 4: Submission with Image', (tester) async {
    final mockStorage = MockStorageService();
    if (getIt.isRegistered<StorageService>()) {
      getIt.unregister<StorageService>();
    }
    getIt.registerSingleton<StorageService>(mockStorage);

    when(() => mockStorage.uploadImage(
      file: any(named: 'file'),
      bucket: any(named: 'bucket'),
      fileName: any(named: 'fileName'),
    )).thenAnswer((_) async => 'https://example.com/image.jpg');

    // Pre-fill with a mock file
    realOrderWizardBloc.add(UpdateOrderData(OrderFormData(
      existingOrderRef: 'temp_id',
      customerId: 'cust_1',
      garmentTypes: const ['Shirt'],
      referenceImageFile: File('test_assets/dummy.jpg'),
      totalAmount: 1000,
    )));

    await tester.pumpWidget(wrapWithBlocs(const CreateOrderPaymentScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ElevatedButton, 'Create Order'));
    await tester.pump();

    // Verify storage was called
    verify(() => mockStorage.uploadImage(
      file: any(named: 'file'),
      bucket: 'reference_images',
      fileName: any(named: 'fileName'),
    )).called(1);

    // Verify CreateOrder dispatched with image URL
    verify(() => mockOrderBloc.add(any(that: isA<CreateOrder>().having(
      (e) => e.order.referenceImagePath, 'imagePath', 'https://example.com/image.jpg'
    )))).called(1);
  });
}
