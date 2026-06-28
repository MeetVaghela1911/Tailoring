import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:tailoring_flutter/features/customers/presentation/add_edit_customer_screen.dart';
import 'package:tailoring_flutter/features/customers/presentation/bloc/customer_bloc.dart';
import 'package:tailoring_flutter/features/customers/presentation/bloc/customer_event.dart';
import 'package:tailoring_flutter/features/customers/presentation/bloc/customer_state.dart';
import 'package:tailoring_flutter/features/onboarding/presentation/bloc/walkthrough_cubit.dart';
import 'package:tailoring_flutter/features/customers/domain/entities/customer.dart';
import 'package:tailoring_flutter/core/utility/dependency_injection.dart';
import 'package:tailoring_flutter/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:tailoring_flutter/core/service/storage_service.dart';
import '../../../test_helpers.dart';

void main() {
  late MockCustomerBloc mockCustomerBloc;
  late FakeWalkthroughCubit fakeWalkthroughCubit;
  late MockStorageService mockStorageService;

  setUpAll(() {
    registerFallbackValue(LoadCustomers());
    registerFallbackValue(AddCustomer(Customer(id: '', name: '', phoneNumber: '', createdAt: DateTime.now())));
    registerFallbackValue(UpdateCustomer(Customer(id: '', name: '', phoneNumber: '', createdAt: DateTime.now())));
  });

  setUp(() {
    mockCustomerBloc = MockCustomerBloc();
    fakeWalkthroughCubit = FakeWalkthroughCubit(WalkthroughInitial());
    mockStorageService = MockStorageService();
    
    if (getIt.isRegistered<StorageService>()) {
      getIt.unregister<StorageService>();
    }
    getIt.registerSingleton<StorageService>(mockStorageService);
    
    // Default state
    when(() => mockCustomerBloc.state).thenReturn(CustomerInitial());
  });

  Widget wrapWithBloc(Widget child) {
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

  testWidgets('AddEditCustomerScreen validation - empty fields', (tester) async {
    await tester.pumpWidget(wrapWithBloc(const AddEditCustomerScreen()));
    await tester.pumpAndSettle();

    // Scroll to bottom to find Save button
    final saveBtn = find.text('Save Customer');
    await tester.ensureVisible(saveBtn);
    await tester.tap(saveBtn);
    await tester.pump();

    // Verify error messages
    expect(find.text('Name is required'), findsOneWidget);
    expect(find.text('Phone is required'), findsOneWidget);
    
    // Verify no event dispatched
    verifyNever(() => mockCustomerBloc.add(any()));
  });

  testWidgets('AddEditCustomerScreen - successful addition', (tester) async {
    await tester.pumpWidget(wrapWithBloc(const AddEditCustomerScreen()));
    await tester.pumpAndSettle();

    // Fill fields using hint text
    await tester.enterText(find.widgetWithText(TextFormField, 'e.g. John Doe'), 'New Customer');
    await tester.enterText(find.widgetWithText(TextFormField, 'e.g. +91 98765 43210'), '1234567890');
    
    // Mock success state emission
    whenListen(
      mockCustomerBloc,
      Stream.fromIterable([
        CustomerInitial(),
        CustomerAddSuccess([], Customer(id: '1', name: 'New Customer', phoneNumber: '1234567890', createdAt: DateTime.now())),
      ]),
    );

    // Scroll to bottom and tap Save
    final saveBtn = find.text('Save Customer');
    await tester.ensureVisible(saveBtn);
    await tester.tap(saveBtn);
    await tester.pump();

    // Verify AddCustomer event dispatched
    verify(() => mockCustomerBloc.add(any(that: isA<AddCustomer>()))).called(1);
  });

  testWidgets('AddEditCustomerScreen - edit mode and update', (tester) async {
    final existingCustomer = Customer(
      id: 'cust_1',
      name: 'Existing Name',
      phoneNumber: '0987654321',
      createdAt: DateTime.now(),
    );

    await tester.pumpWidget(wrapWithBloc(AddEditCustomerScreen(customer: existingCustomer)));
    await tester.pumpAndSettle();

    // Verify initial values
    expect(find.text('Existing Name'), findsOneWidget);
    expect(find.text('0987654321'), findsOneWidget);

    // Change name
    await tester.enterText(find.widgetWithText(TextFormField, 'e.g. John Doe'), 'Updated Name');

    // Mock success state
    whenListen(
      mockCustomerBloc,
      Stream.fromIterable([
        CustomerInitial(),
        CustomerUpdateSuccess([], existingCustomer.copyWith(name: 'Updated Name')),
      ]),
    );

    // Find and tap Update button (at the top, usually visible)
    final updateBtn = find.text('Update Customer');
    await tester.ensureVisible(updateBtn);
    await tester.tap(updateBtn);
    await tester.pump();

    // Verify UpdateCustomer event
    verify(() => mockCustomerBloc.add(any(that: isA<UpdateCustomer>()))).called(1);
  });

  testWidgets('AddEditCustomerScreen - show error from BLoC', (tester) async {
    whenListen(
      mockCustomerBloc,
      Stream.fromIterable([
        const CustomerError('Failed to save customer'),
      ]),
      initialState: CustomerInitial(),
    );

    await tester.pumpWidget(wrapWithBloc(const AddEditCustomerScreen()));
    await tester.pump(); 
    await tester.pumpAndSettle();

    // Verify SnackBar with error message
    expect(find.text('Failed to save customer'), findsOneWidget);
  });
}
