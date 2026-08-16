import '../../domain/entities/payment_transaction.dart';

class PaymentTransactionModel extends PaymentTransaction {
  const PaymentTransactionModel({
    required super.id,
    required super.orderId,
    super.customerId,
    super.customerName,
    super.customerPhone,
    required super.amount,
    required super.paymentMode,
    super.paymentModeName,
    super.paymentStage,
    super.notes,
    super.referenceNumber,
    required super.createdAt,
  });

  factory PaymentTransactionModel.fromJson(Map<String, dynamic> json) {
    return PaymentTransactionModel(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      customerId: json['customer_id'] as String?,
      customerName: json['customer_name'] as String?,
      customerPhone: json['customer_phone'] as String?,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      paymentMode: (json['payment_mode'] as num?)?.toInt() ?? 1,
      paymentModeName: json['payment_mode_name'] as String?,
      paymentStage: json['payment_stage'] as String?,
      notes: json['notes'] as String?,
      referenceNumber: json['reference_number'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      if (customerId != null) 'customer_id': customerId,
      if (customerName != null) 'customer_name': customerName,
      if (customerPhone != null) 'customer_phone': customerPhone,
      'amount': amount,
      'payment_mode': paymentMode,
      if (paymentModeName != null) 'payment_mode_name': paymentModeName,
      if (paymentStage != null) 'payment_stage': paymentStage,
      if (notes != null) 'notes': notes,
      if (referenceNumber != null) 'reference_number': referenceNumber,
      'created_at': createdAt.toIso8601String(),
    };
  }

  PaymentTransaction toEntity() => PaymentTransaction(
        id: id,
        orderId: orderId,
        customerId: customerId,
        customerName: customerName,
        customerPhone: customerPhone,
        amount: amount,
        paymentMode: paymentMode,
        paymentModeName: paymentModeName,
        paymentStage: paymentStage,
        notes: notes,
        referenceNumber: referenceNumber,
        createdAt: createdAt,
      );

  factory PaymentTransactionModel.fromEntity(PaymentTransaction entity) {
    return PaymentTransactionModel(
      id: entity.id,
      orderId: entity.orderId,
      customerId: entity.customerId,
      customerName: entity.customerName,
      customerPhone: entity.customerPhone,
      amount: entity.amount,
      paymentMode: entity.paymentMode,
      paymentModeName: entity.paymentModeName,
      paymentStage: entity.paymentStage,
      notes: entity.notes,
      referenceNumber: entity.referenceNumber,
      createdAt: entity.createdAt,
    );
  }
}
