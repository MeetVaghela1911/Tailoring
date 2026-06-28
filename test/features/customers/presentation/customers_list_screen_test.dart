import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tailoring_flutter/features/customers/presentation/customers_list_screen.dart';
import 'package:tailoring_flutter/features/customers/presentation/bloc/customer_bloc.dart';
import 'package:tailoring_flutter/features/customers/presentation/bloc/customer_event.dart';
import 'package:tailoring_flutter/features/customers/presentation/bloc/customer_state.dart';
import 'package:tailoring_flutter/features/customers/domain/entities/customer.dart';
import 'package:tailoring_flutter/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main() {
  late FakeCustomerBloc fakeCustomerBloc;

  setUp(() {
    fakeCustomerBloc = FakeCustomerBloc(CustomerInitial());
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
      home: BlocProvider<CustomerBloc>.value(
        value: fakeCustomerBloc,
        child: const CustomersListScreen(),
      ),
    );
  }

  testWidgets('renders customers list screen and loads customers', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    expect(fakeCustomerBloc.addedEvents.contains(LoadCustomers()), true);
  });

  testWidgets('shows loading indicator when state is CustomerLoading', (WidgetTester tester) async {
    fakeCustomerBloc = FakeCustomerBloc(CustomerLoading());
    await tester.pumpWidget(createWidgetUnderTest());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows empty state when no customers exist', (WidgetTester tester) async {
    fakeCustomerBloc = FakeCustomerBloc(const CustomersLoaded([]));
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.text('No customers found'), findsOneWidget);
  });

  testWidgets('shows list of customers when state is CustomersLoaded', (WidgetTester tester) async {
    final customers = [
      Customer(id: '1', name: 'John Doe', phoneNumber: '12345', createdAt: DateTime.now()),
      Customer(id: '2', name: 'Jane Smith', phoneNumber: '67890', createdAt: DateTime.now()),
    ];
    fakeCustomerBloc = FakeCustomerBloc(CustomersLoaded(customers));
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('Jane Smith'), findsOneWidget);
  });

  testWidgets('filters customers based on search query', (WidgetTester tester) async {
    final customers = [
      Customer(id: '1', name: 'John Doe', phoneNumber: '12345', createdAt: DateTime.now()),
      Customer(id: '2', name: 'Jane Smith', phoneNumber: '67890', createdAt: DateTime.now()),
    ];
    fakeCustomerBloc = FakeCustomerBloc(CustomersLoaded(customers));
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    await tester.enterText(find.byType(TextField), 'Jane');
    await tester.pump();

    expect(find.text('John Doe'), findsNothing);
    expect(find.text('Jane Smith'), findsOneWidget);
  });

  testWidgets('CRASH TEST: handles names with multiple spaces gracefully', (WidgetTester tester) async {
    final customers = [
      Customer(id: '1', name: 'John  Doe', phoneNumber: '12345', createdAt: DateTime.now()),
    ];
    fakeCustomerBloc = FakeCustomerBloc(CustomersLoaded(customers));
    
    // If this fails, it means the split(' ') logic crashed on the empty string between spaces
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.text('John  Doe'), findsOneWidget);
  });
}

class FakeCustomerBloc extends Fake implements CustomerBloc {
  final CustomerState _state;
  final List<CustomerEvent> addedEvents = [];

  FakeCustomerBloc(this._state);

  @override
  CustomerState get state => _state;

  @override
  Stream<CustomerState> get stream => const Stream.empty();

  @override
  void add(CustomerEvent event) {
    addedEvents.add(event);
  }

  @override
  Future<void> close() async {}
}
