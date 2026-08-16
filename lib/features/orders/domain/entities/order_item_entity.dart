import 'package:equatable/equatable.dart';

class OrderItemEntity extends Equatable {
  final String id;
  final String orderId;
  final String? templateId;
  final String garmentName;
  final int quantity;
  final double unitPrice;
  final Map<String, String> measurements;
  final Map<String, String> measurementNotes;
  final String status;

  const OrderItemEntity({
    required this.id,
    required this.orderId,
    this.templateId,
    required this.garmentName,
    this.quantity = 1,
    this.unitPrice = 0.0,
    this.measurements = const {},
    this.measurementNotes = const {},
    this.status = 'PENDING',
  });

  @override
  List<Object?> get props => [
        id,
        orderId,
        templateId,
        garmentName,
        quantity,
        unitPrice,
        measurements,
        measurementNotes,
        status,
      ];
}
