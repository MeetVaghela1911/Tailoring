import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:tailoring_flutter/features/customers/presentation/bloc/customer_bloc.dart';
import 'package:tailoring_flutter/features/customers/presentation/bloc/customer_event.dart';
import 'package:tailoring_flutter/features/customers/presentation/bloc/customer_state.dart';
import 'package:tailoring_flutter/features/customers/domain/entities/customer.dart';
import 'package:tailoring_flutter/core/error/failures.dart';
import '../../../../test_helpers.dart';

void main() {
  late CustomerBloc customerBloc;
  late MockGetCustomersUseCase mockGetCustomersUseCase;
  late MockAddCustomerUseCase mockAddCustomerUseCase;
  late MockUpdateCustomerUseCase mockUpdateCustomerUseCase;
  late MockDeleteCustomerUseCase mockDeleteCustomerUseCase;

  final tCustomer = Customer(
    id: '1',
    name: 'John Doe',
    phoneNumber: '1234567890',
    createdAt: DateTime.now(),
  );
  final tCustomers = [tCustomer];

  setUpAll(() {
    TestHelper.registerFallbackValues();
  });

  setUp(() {
    mockGetCustomersUseCase = MockGetCustomersUseCase();
    mockAddCustomerUseCase = MockAddCustomerUseCase();
    mockUpdateCustomerUseCase = MockUpdateCustomerUseCase();
    mockDeleteCustomerUseCase = MockDeleteCustomerUseCase();

    customerBloc = CustomerBloc(
      getCustomersUseCase: mockGetCustomersUseCase,
      addCustomerUseCase: mockAddCustomerUseCase,
      updateCustomerUseCase: mockUpdateCustomerUseCase,
      deleteCustomerUseCase: mockDeleteCustomerUseCase,
    );
  });

  tearDown(() {
    customerBloc.close();
  });

  test('initial state should be CustomerInitial', () {
    expect(customerBloc.state, isA<CustomerInitial>());
  });

  group('LoadCustomers', () {
    blocTest<CustomerBloc, CustomerState>(
      'emits [CustomerLoading, CustomersLoaded] when loading is successful',
      build: () {
        when(() => mockGetCustomersUseCase(any())).thenAnswer((_) async => Right(tCustomers));
        return customerBloc;
      },
      act: (bloc) => bloc.add(LoadCustomers()),
      expect: () => [
        CustomerLoading(),
        CustomersLoaded(tCustomers),
      ],
    );

    blocTest<CustomerBloc, CustomerState>(
      'emits [CustomerLoading, CustomerError] when loading fails',
      build: () {
        when(() => mockGetCustomersUseCase(any())).thenAnswer((_) async => const Left(ServerFailure('Failed to load')));
        return customerBloc;
      },
      act: (bloc) => bloc.add(LoadCustomers()),
      expect: () => [
        CustomerLoading(),
        const CustomerError('Failed to load'),
      ],
    );
  });

  group('AddCustomer (Optimistic)', () {
    final newCustomer = Customer(
      id: '2',
      name: 'Jane Doe',
      phoneNumber: '0987654321',
      createdAt: DateTime.now(),
    );

    blocTest<CustomerBloc, CustomerState>(
      'emits [CustomersLoaded (optimistic), CustomerAddSuccess] when successful',
      build: () {
        when(() => mockAddCustomerUseCase(any())).thenAnswer((_) async => Right(newCustomer));
        return customerBloc;
      },
      seed: () => CustomersLoaded(tCustomers),
      act: (bloc) => bloc.add(AddCustomer(newCustomer)),
      expect: () => [
        CustomersLoaded([...tCustomers, newCustomer]),
        CustomerAddSuccess([...tCustomers, newCustomer], newCustomer),
      ],
    );

    blocTest<CustomerBloc, CustomerState>(
      'assigns a non-empty UUID when adding customer with empty ID',
      build: () {
        when(() => mockAddCustomerUseCase(any())).thenAnswer((invocation) async {
          final Customer passedCust = invocation.positionalArguments.first as Customer;
          return Right(passedCust);
        });
        return customerBloc;
      },
      seed: () => CustomersLoaded(tCustomers),
      act: (bloc) => bloc.add(AddCustomer(Customer(
        id: '',
        name: 'Empty ID Customer',
        phoneNumber: '9999999999',
        createdAt: DateTime.now(),
      ))),
      verify: (_) {
        final captured = verify(() => mockAddCustomerUseCase(captureAny())).captured.single as Customer;
        expect(captured.id, isNotEmpty);
      },
    );

    blocTest<CustomerBloc, CustomerState>(
      'emits [CustomersLoaded (optimistic), CustomerError, CustomersLoaded (reverted)] when failure occurs',
      build: () {
        when(() => mockAddCustomerUseCase(any())).thenAnswer((_) async => const Left(ServerFailure('Add failed')));
        return customerBloc;
      },
      seed: () => CustomersLoaded(tCustomers),
      act: (bloc) => bloc.add(AddCustomer(newCustomer)),
      expect: () => [
        CustomersLoaded([...tCustomers, newCustomer]),
        const CustomerError('Add failed'),
        CustomersLoaded(tCustomers),
      ],
    );
  });

  group('UpdateCustomer (Optimistic)', () {
    final updatedCustomer = Customer(
      id: '1',
      name: 'John Updated',
      phoneNumber: '1234567890',
      createdAt: DateTime.now(),
    );

    blocTest<CustomerBloc, CustomerState>(
      'emits [CustomersLoaded (optimistic), CustomerUpdateSuccess] when successful',
      build: () {
        when(() => mockUpdateCustomerUseCase(any())).thenAnswer((_) async => Right(updatedCustomer));
        return customerBloc;
      },
      seed: () => CustomersLoaded(tCustomers),
      act: (bloc) => bloc.add(UpdateCustomer(updatedCustomer)),
      expect: () => [
        CustomersLoaded([updatedCustomer]),
        CustomerUpdateSuccess([updatedCustomer], updatedCustomer),
      ],
    );

    blocTest<CustomerBloc, CustomerState>(
      'emits [CustomersLoaded (optimistic), CustomerError, CustomersLoaded (reverted)] when failure occurs',
      build: () {
        when(() => mockUpdateCustomerUseCase(any())).thenAnswer((_) async => const Left(ServerFailure('Update failed')));
        return customerBloc;
      },
      seed: () => CustomersLoaded(tCustomers),
      act: (bloc) => bloc.add(UpdateCustomer(updatedCustomer)),
      expect: () => [
        CustomersLoaded([updatedCustomer]),
        const CustomerError('Update failed'),
        CustomersLoaded(tCustomers),
      ],
    );
  });

  group('DeleteCustomer (Optimistic)', () {
    blocTest<CustomerBloc, CustomerState>(
      'emits [CustomersLoaded (optimistic), CustomerDeleteSuccess] when successful',
      build: () {
        when(() => mockDeleteCustomerUseCase(any())).thenAnswer((_) async => const Right(null));
        return customerBloc;
      },
      seed: () => CustomersLoaded(tCustomers),
      act: (bloc) => bloc.add(const DeleteCustomer('1')),
      expect: () => [
        CustomersLoaded([]),
        const CustomerDeleteSuccess([], '1'),
      ],
    );

    blocTest<CustomerBloc, CustomerState>(
      'emits [CustomersLoaded (optimistic), CustomerError, CustomersLoaded (reverted)] when failure occurs',
      build: () {
        when(() => mockDeleteCustomerUseCase(any())).thenAnswer((_) async => const Left(ServerFailure('Delete failed')));
        return customerBloc;
      },
      seed: () => CustomersLoaded(tCustomers),
      act: (bloc) => bloc.add(const DeleteCustomer('1')),
      expect: () => [
        CustomersLoaded([]),
        const CustomerError('Delete failed'),
        CustomersLoaded(tCustomers),
      ],
    );
  });
}
