import '../../domain/entities/order_entity.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    super.customerId,
    super.customerName,
    super.customerPhone,
    required super.garmentTypes,
    super.garmentQuantities = const {},
    super.garmentPrices = const {},
    required super.specialInstructions,
    super.referenceImagePath,
    required super.measurements,
    super.deliveryDate,
    required super.priorityIndex,
    required super.assignedTailor,
    required super.totalAmount,
    required super.advancePaid,
    super.externalCharges = 0.0,
    required super.paymentMode,
    required super.status,
    super.measurementNotes = const {},
    required super.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      customerId: json['customer_id'] as String?,
      customerName: json['customer_name'] as String?,
      customerPhone: json['customer_phone'] as String?,
      garmentTypes: List<String>.from(json['garment_types'] as List),
      garmentQuantities: Map<String, int>.from(json['garment_quantities'] as Map? ?? {}),
      garmentPrices: (json['garment_prices'] as Map<String, dynamic>?)?.map((k, v) => MapEntry(k, (v as num).toDouble())) ?? {},
      specialInstructions: json['special_instructions'] as String? ?? '',
      referenceImagePath: json['reference_image_path'] as String?,
      measurements: Map<String, String>.from(json['measurements'] as Map),
      deliveryDate: json['delivery_date'] != null
          ? DateTime.parse(json['delivery_date'] as String)
          : null,
      priorityIndex: (json['priority_index'] as num?)?.toInt() ?? 1,
      assignedTailor: json['assigned_tailor'] as String? ?? 'Sarah Jenkins',
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      advancePaid: (json['advance_paid'] as num?)?.toDouble() ?? 0.0,
      externalCharges: (json['external_charges'] as num?)?.toDouble() ?? 0.0,
      paymentMode: (json['payment_mode'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? 'NOT STARTED',
      measurementNotes: Map<String, String>.from(json['measurement_notes'] as Map? ?? {}),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'customer_id': customerId,
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'garment_types': garmentTypes,
      'garment_quantities': garmentQuantities,
      'garment_prices': garmentPrices,
      'special_instructions': specialInstructions,
      'reference_image_path': referenceImagePath,
      'measurements': measurements,
      'delivery_date': deliveryDate?.toIso8601String(),
      'priority_index': priorityIndex,
      'assigned_tailor': assignedTailor,
      'total_amount': totalAmount,
      'advance_paid': advancePaid,
      'external_charges': externalCharges,
      'payment_mode': paymentMode,
      'status': status,
      'measurement_notes': measurementNotes,
      'created_at': createdAt.toIso8601String(),
    };
  }

  OrderEntity toEntity() {
    return OrderEntity(
      id: id,
      customerId: customerId,
      customerName: customerName,
      customerPhone: customerPhone,
      garmentTypes: garmentTypes,
      garmentQuantities: garmentQuantities,
      specialInstructions: specialInstructions,
      referenceImagePath: referenceImagePath,
      measurements: measurements,
      deliveryDate: deliveryDate,
      priorityIndex: priorityIndex,
      assignedTailor: assignedTailor,
      totalAmount: totalAmount,
      advancePaid: advancePaid,
      externalCharges: externalCharges,
      paymentMode: paymentMode,
      status: status,
      measurementNotes: measurementNotes,
      createdAt: createdAt,
    );
  }

  factory OrderModel.fromEntity(OrderEntity entity) {
    return OrderModel(
      id: entity.id,
      customerId: entity.customerId,
      customerName: entity.customerName,
      customerPhone: entity.customerPhone,
      garmentTypes: entity.garmentTypes,
      garmentQuantities: entity.garmentQuantities,
      specialInstructions: entity.specialInstructions,
      referenceImagePath: entity.referenceImagePath,
      measurements: entity.measurements,
      deliveryDate: entity.deliveryDate,
      priorityIndex: entity.priorityIndex,
      assignedTailor: entity.assignedTailor,
      totalAmount: entity.totalAmount,
      advancePaid: entity.advancePaid,
      externalCharges: entity.externalCharges,
      paymentMode: entity.paymentMode,
      status: entity.status,
      measurementNotes: entity.measurementNotes,
      createdAt: entity.createdAt,
    );
  }
}
