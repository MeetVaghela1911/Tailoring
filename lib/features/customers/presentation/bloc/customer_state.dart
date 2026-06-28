import 'package:equatable/equatable.dart';
import '../../domain/entities/customer.dart';

abstract class CustomerState extends Equatable {
  const CustomerState();

  @override
  List<Object?> get props => [];
}

class CustomerInitial extends CustomerState {}

class CustomerLoading extends CustomerState {}

class CustomersLoaded extends CustomerState {
  final List<Customer> customers;
  final String? message;
  const CustomersLoaded(this.customers, {this.message});

  @override
  List<Object?> get props => [customers, message];
}

class CustomerAddSuccess extends CustomersLoaded {
  final Customer customer;
  const CustomerAddSuccess(super.customers, this.customer);
  @override
  List<Object?> get props => [customers, customer];
}

class CustomerUpdateSuccess extends CustomersLoaded {
  final Customer customer;
  const CustomerUpdateSuccess(super.customers, this.customer);
  @override
  List<Object?> get props => [customers, customer];
}

class CustomerDeleteSuccess extends CustomersLoaded {
  final String id;
  const CustomerDeleteSuccess(super.customers, this.id);
  @override
  List<Object?> get props => [customers, id];
}

class CustomerError extends CustomerState {
  final String message;
  const CustomerError(this.message);

  @override
  List<Object> get props => [message];
}
