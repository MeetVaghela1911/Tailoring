import 'package:equatable/equatable.dart';
import '../../domain/entities/payment_transaction.dart';
import '../../domain/repositories/payment_repository.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class OrderPaymentsLoaded extends PaymentState {
  final String orderId;
  final List<PaymentTransaction> payments;

  const OrderPaymentsLoaded({required this.orderId, required this.payments});

  @override
  List<Object?> get props => [orderId, payments];
}

class CustomerKhataLoaded extends PaymentState {
  final CustomerKhataSummary summary;

  const CustomerKhataLoaded(this.summary);

  @override
  List<Object?> get props => [summary];
}

class DailyCashbookLoaded extends PaymentState {
  final DailyCashbookSummary summary;

  const DailyCashbookLoaded(this.summary);

  @override
  List<Object?> get props => [summary];
}

class FilteredFinanceLoaded extends PaymentState {
  final FilteredFinanceSummary summary;

  const FilteredFinanceLoaded(this.summary);

  @override
  List<Object?> get props => [summary];
}

class PaymentAddedSuccess extends PaymentState {
  final PaymentTransaction transaction;

  const PaymentAddedSuccess(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

class PaymentError extends PaymentState {
  final String message;

  const PaymentError(this.message);

  @override
  List<Object?> get props => [message];
}
