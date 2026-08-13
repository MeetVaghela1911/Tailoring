import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../domain/usecases/add_customer_usecase.dart';
import '../../domain/usecases/delete_customer_usecase.dart';
import '../../domain/usecases/get_customers_usecase.dart';
import '../../domain/usecases/update_customer_usecase.dart';
import '../../../../core/usecase/usecase.dart';
import 'customer_event.dart';
import 'customer_state.dart';
import '../../domain/entities/customer.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final GetCustomersUseCase getCustomersUseCase;
  final AddCustomerUseCase addCustomerUseCase;
  final UpdateCustomerUseCase updateCustomerUseCase;
  final DeleteCustomerUseCase deleteCustomerUseCase;

  CustomerBloc({
    required this.getCustomersUseCase,
    required this.addCustomerUseCase,
    required this.updateCustomerUseCase,
    required this.deleteCustomerUseCase,
  }) : super(CustomerInitial()) {
    on<LoadCustomers>(_onLoadCustomers);
    on<AddCustomer>(_onAddCustomer);
    on<UpdateCustomer>(_onUpdateCustomer);
    on<DeleteCustomer>(_onDeleteCustomer);
  }

  Future<void> _onLoadCustomers(
    LoadCustomers event,
    Emitter<CustomerState> emit,
  ) async {
    emit(CustomerLoading());
    final result = await getCustomersUseCase(NoParams());
    result.fold(
      (failure) => emit(CustomerError(failure.message)),
      (customers) => emit(CustomersLoaded(customers)),
    );
  }

  Future<void> _onAddCustomer(
    AddCustomer event,
    Emitter<CustomerState> emit,
  ) async {
    final currentState = state;
    List<Customer> currentCustomers = [];
    if (currentState is CustomersLoaded) {
      currentCustomers = List<Customer>.from(currentState.customers);
    }

    final customerToAdd = event.customer.id.trim().isEmpty
        ? event.customer.copyWith(id: const Uuid().v4())
        : event.customer;

    // Optimistic Update
    final optimisticList = List<Customer>.from(currentCustomers)..add(customerToAdd);
    emit(CustomersLoaded(optimisticList));

    final result = await addCustomerUseCase(customerToAdd);
    result.fold(
      (failure) {
        // Revert on failure
        emit(CustomerError(failure.message));
        emit(CustomersLoaded(currentCustomers));
      },
      (savedCustomer) {
        final updatedList = optimisticList.map((c) {
          if (c.id == customerToAdd.id || (c.id.isEmpty && c.name == savedCustomer.name)) {
            return savedCustomer;
          }
          return c;
        }).toList();
        emit(CustomerAddSuccess(updatedList, savedCustomer));
      },
    );
  }

  Future<void> _onUpdateCustomer(
    UpdateCustomer event,
    Emitter<CustomerState> emit,
  ) async {
    final currentState = state;
    List<Customer> currentCustomers = [];
    if (currentState is CustomersLoaded) {
      currentCustomers = List<Customer>.from(currentState.customers);
    }

    // Optimistic Update
    final optimisticList = currentCustomers.map<Customer>((c) {
      return c.id == event.customer.id ? event.customer : c;
    }).toList();
    emit(CustomersLoaded(optimisticList));

    final result = await updateCustomerUseCase(event.customer);
    result.fold(
      (failure) {
        // Revert on failure
        emit(CustomerError(failure.message));
        emit(CustomersLoaded(currentCustomers));
      },
      (_) => emit(CustomerUpdateSuccess(optimisticList, event.customer)),
    );
  }

  Future<void> _onDeleteCustomer(
    DeleteCustomer event,
    Emitter<CustomerState> emit,
  ) async {
    if (event.id.trim().isEmpty) return;

    final currentState = state;
    List<Customer> currentCustomers = [];
    if (currentState is CustomersLoaded) {
      currentCustomers = List<Customer>.from(currentState.customers);
    }

    // Optimistic Update
    final optimisticList = currentCustomers.where((c) => c.id != event.id).toList();
    emit(CustomersLoaded(optimisticList));

    final result = await deleteCustomerUseCase(event.id);
    result.fold(
      (failure) {
        // Revert on failure
        emit(CustomerError(failure.message));
        emit(CustomersLoaded(currentCustomers));
      },
      (_) => emit(CustomerDeleteSuccess(optimisticList, event.id)),
    );
  }
}
