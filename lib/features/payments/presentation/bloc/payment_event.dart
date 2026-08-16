import 'package:equatable/equatable.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class LoadOrderPayments extends PaymentEvent {
  final String orderId;

  const LoadOrderPayments(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class LoadCustomerKhata extends PaymentEvent {
  final String customerId;

  const LoadCustomerKhata(this.customerId);

  @override
  List<Object?> get props => [customerId];
}

class LoadDailyCashbook extends PaymentEvent {
  const LoadDailyCashbook();
}

class LoadFilteredFinance extends PaymentEvent {
  final DateTime? startDate;
  final DateTime? endDate;
  final String filterName;

  const LoadFilteredFinance({
    this.startDate,
    this.endDate,
    this.filterName = 'This Month',
  });

  @override
  List<Object?> get props => [startDate, endDate, filterName];
}

class AddPaymentTransactionEvent extends PaymentEvent {
  final String orderId;
  final String? customerId;
  final String? customerName;
  final String? customerPhone;
  final double amount;
  final int paymentMode;
  final String? paymentModeName;
  final String? paymentStage;
  final String? notes;
  final String? referenceNumber;

  const AddPaymentTransactionEvent({
    required this.orderId,
    this.customerId,
    this.customerName,
    this.customerPhone,
    required this.amount,
    required this.paymentMode,
    this.paymentModeName,
    this.paymentStage,
    this.notes,
    this.referenceNumber,
  });

  @override
  List<Object?> get props => [
        orderId,
        customerId,
        customerName,
        customerPhone,
        amount,
        paymentMode,
        paymentModeName,
        paymentStage,
        notes,
        referenceNumber,
      ];
}
