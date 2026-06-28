import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:tailoring_flutter/features/customers/presentation/customers_list_screen.dart';
import 'package:tailoring_flutter/features/customers/presentation/add_edit_customer_screen.dart';
import 'package:tailoring_flutter/features/customers/presentation/bloc/customer_bloc.dart';
import 'package:tailoring_flutter/features/customers/presentation/bloc/customer_event.dart';
import 'package:tailoring_flutter/features/customers/presentation/bloc/customer_state.dart';
import 'package:tailoring_flutter/features/onboarding/presentation/bloc/walkthrough_cubit.dart';
import 'package:tailoring_flutter/features/customers/domain/entities/customer.dart';
import 'package:tailoring_flutter/core/utility/dependency_injection.dart';
import 'package:tailoring_flutter/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:tailoring_flutter/routes/app_router.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:tailoring_flutter/core/service/storage_service.dart';
import '../../../test_helpers.dart';

void main() {
  late MockCustomerBloc mockCustomerBloc;
  late FakeWalkthroughCubit fakeWalkthroughCubit;
  late MockStorageService mockStorageService;

  setUpAll(() {
    TestHelper.registerFallbackValues();
    registerFallbackValue(AddCustomer(Customer(id: '', name: '', phoneNumber: '', createdAt: DateTime.now())));
  });

  setUp(() {
    mockCustomerBloc = MockCustomerBloc();
    fakeWalkthroughCubit = FakeWalkthroughCubit(WalkthroughInitial());
    mockStorageService = MockStorageService();
    
    if (!getIt.isRegistered<StorageService>()) {
      getIt.registerSingleton<StorageService>(mockStorageService);
    }

    when(() => mockStorageService.uploadImage(
      file: any(named: 'file'),
      bucket: any(named: 'bucket'),
      fileName: any(named: 'fileName'),
    )).thenAnswer((_) async => 'https://example.com/image.jpg');

    when(() => mockCustomerBloc.state).thenReturn(CustomerInitial());
  });

  tearDown(() {
    getIt.reset();
  });

  Widget wrapWithBloc(Widget child, {GoRouter? router}) {
    if (router != null) {
      return MultiBlocProvider(
        providers: [
          BlocProvider<CustomerBloc>.value(value: mockCustomerBloc),
          BlocProvider<WalkthroughCubit>.value(value: fakeWalkthroughCubit),
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
      );
    }

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
            BlocProvider<CustomerBloc>.value(value: mockCustomerBloc),
            BlocProvider<WalkthroughCubit>.value(value: fakeWalkthroughCubit),
          ],
          child: child,
        ),
      ),
    );
  }

  group('CustomersListScreen', () {
    testWidgets('shows loading state', (tester) async {
      when(() => mockCustomerBloc.state).thenReturn(CustomerLoading());
      
      await tester.pumpWidget(wrapWithBloc(const CustomersListScreen()));
      
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows empty state when no customers', (tester) async {
      when(() => mockCustomerBloc.state).thenReturn(const CustomersLoaded([]));
      
      await tester.pumpWidget(wrapWithBloc(const CustomersListScreen()));
      await tester.pumpAndSettle();
      
      expect(find.text('No customers found'), findsOneWidget);
    });

    testWidgets('shows list of customers and filters', (tester) async {
      final customers = [
        Customer(id: '1', name: 'John Doe', phoneNumber: '1234567890', createdAt: DateTime.now()),
        Customer(id: '2', name: 'Jane Smith', phoneNumber: '0987654321', createdAt: DateTime.now()),
      ];
      when(() => mockCustomerBloc.state).thenReturn(CustomersLoaded(customers));
      
      await tester.pumpWidget(wrapWithBloc(const CustomersListScreen()));
      await tester.pumpAndSettle();
      
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('Jane Smith'), findsOneWidget);
      
      // Search
      await tester.enterText(find.byType(TextField), 'John');
      await tester.pumpAndSettle();
      
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('Jane Smith'), findsNothing);
    });
  });

  group('AddEditCustomerScreen', () {
    testWidgets('validation errors for empty fields', (tester) async {
      await tester.pumpWidget(wrapWithBloc(const AddEditCustomerScreen()));
      await tester.pumpAndSettle();

      final saveButton = find.byType(ElevatedButton);
      await tester.ensureVisible(saveButton);
      await tester.tap(saveButton);
      await tester.pumpAndSettle();
      
      expect(find.textContaining('Name'), findsWidgets);
      expect(find.textContaining('Phone'), findsWidgets);
    });

    testWidgets('successfully adds customer', (tester) async {
      final stateController = StreamController<CustomerState>();
      whenListen(
        mockCustomerBloc,
        stateController.stream,
        initialState: CustomerInitial(),
      );

      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(path: '/', builder: (context, state) => const Scaffold(body: Text('Home'))),
          GoRoute(
            path: AppRoutes.addCustomer,
            builder: (context, state) => const AddEditCustomerScreen(),
          ),
        ],
      );

      await tester.pumpWidget(wrapWithBloc(const SizedBox(), router: router));
      await tester.pumpAndSettle();
      
      router.push(AppRoutes.addCustomer);
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).at(0), 'Alice');
      await tester.enterText(find.byType(TextField).at(1), '5551234');
      await tester.pumpAndSettle();
      
      final saveButton = find.byType(ElevatedButton);
      await tester.ensureVisible(saveButton);
      await tester.tap(saveButton);
      await tester.pump(const Duration(milliseconds: 100)); 
      
      final customer = Customer(id: '3', name: 'Alice', phoneNumber: '5551234', createdAt: DateTime.now());
      stateController.add(CustomerAddSuccess(const [], customer));
      await tester.pumpAndSettle();
      
      verify(() => mockCustomerBloc.add(any())).called(1);
      expect(find.text('Home'), findsOneWidget);
      
      stateController.close();
    });

    testWidgets('handles error state', (tester) async {
      final stateController = StreamController<CustomerState>();
      whenListen(
        mockCustomerBloc,
        stateController.stream,
        initialState: CustomerInitial(),
      );

      await tester.pumpWidget(wrapWithBloc(const AddEditCustomerScreen()));
      await tester.pumpAndSettle();
      
      await tester.enterText(find.byType(TextField).at(0), 'Alice');
      await tester.enterText(find.byType(TextField).at(1), '5551234');
      await tester.pumpAndSettle();

      final saveButton = find.text('Add Customer');
      await tester.ensureVisible(saveButton);
      await tester.tap(saveButton);
      await tester.pump();
      
      stateController.add(const CustomerError('Failed to add customer'));
      await tester.pumpAndSettle();
      
      expect(find.text('Failed to add customer'), findsOneWidget);
      
      stateController.close();
    });
  });
}
