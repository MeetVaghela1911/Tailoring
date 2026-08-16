import 'package:equatable/equatable.dart';

class PaymentTransaction extends Equatable {
  final String id;
  final String orderId;
  final String? customerId;
  final String? customerName;
  final String? customerPhone;
  final double amount;
  final int paymentMode; // 1=Cash, 2=Card, 3=Online/UPI
  final String? paymentModeName;
  final String? paymentStage; // e.g. "Advance", "Fitting", "Delivery Balance"
  final String? notes;
  final String? referenceNumber;
  final DateTime createdAt;

  const PaymentTransaction({
    required this.id,
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
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
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
        createdAt,
      ];
}
