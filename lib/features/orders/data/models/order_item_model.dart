import '../../domain/entities/order_item_entity.dart';

class OrderItemModel extends OrderItemEntity {
  const OrderItemModel({
    required super.id,
    required super.orderId,
    super.templateId,
    required super.garmentName,
    super.quantity = 1,
    super.unitPrice = 0.0,
    super.measurements = const {},
    super.measurementNotes = const {},
    super.status = 'PENDING',
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: (json['id'] as String?) ?? '',
      orderId: (json['order_id'] as String?) ?? '',
      templateId: json['template_id'] as String?,
      garmentName: (json['garment_name'] as String?) ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      unitPrice: (json['unit_price'] as num?)?.toDouble() ?? 0.0,
      measurements: Map<String, String>.from(json['measurements'] as Map? ?? {}),
      measurementNotes: Map<String, String>.from(json['measurement_notes'] as Map? ?? {}),
      status: (json['status'] as String?) ?? 'PENDING',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      if (orderId.isNotEmpty) 'order_id': orderId,
      if (templateId != null && templateId!.isNotEmpty) 'template_id': templateId,
      'garment_name': garmentName,
      'quantity': quantity,
      'unit_price': unitPrice,
      'measurements': measurements,
      'measurement_notes': measurementNotes,
      'status': status,
    };
  }
}
