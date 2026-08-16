import 'package:equatable/equatable.dart';
import 'order_item_entity.dart';

class OrderEntity extends Equatable {
  final String id;
  final int? orderNumber;
  final String? shopId;
  final String? customerId;
  final String? customerName;
  final String? customerPhone;
  final List<String> garmentTypes;
  final Map<String, int> garmentQuantities;
  final Map<String, double> garmentPrices;
  final String specialInstructions;
  final String? referenceImagePath;
  final Map<String, String> measurements;
  final DateTime? deliveryDate;
  final int priorityIndex;
  final String assignedTailor;
  final double totalAmount;
  final double advancePaid;
  final double externalCharges;
  final int paymentMode;
  final String status;
  final Map<String, String> measurementNotes;
  final DateTime createdAt;
  final List<OrderItemEntity> items;
  final bool isDeleted;

  const OrderEntity({
    required this.id,
    this.orderNumber,
    this.shopId,
    this.customerId,
    this.customerName,
    this.customerPhone,
    required this.garmentTypes,
    this.garmentQuantities = const {},
    this.garmentPrices = const {},
    required this.specialInstructions,
    this.referenceImagePath,
    required this.measurements,
    this.deliveryDate,
    required this.priorityIndex,
    this.assignedTailor = '',
    required this.totalAmount,
    required this.advancePaid,
    this.externalCharges = 0.0,
    required this.paymentMode,
    required this.status,
    this.measurementNotes = const {},
    required this.createdAt,
    this.items = const [],
    this.isDeleted = false,
  });

  double get balanceDue => (totalAmount - advancePaid).clamp(0, double.infinity);

  OrderEntity copyWith({
    String? id,
    int? orderNumber,
    String? shopId,
    String? customerId,
    String? customerName,
    String? customerPhone,
    List<String>? garmentTypes,
    Map<String, int>? garmentQuantities,
    Map<String, double>? garmentPrices,
    String? specialInstructions,
    String? referenceImagePath,
    Map<String, String>? measurements,
    DateTime? deliveryDate,
    int? priorityIndex,
    String? assignedTailor,
    double? totalAmount,
    double? advancePaid,
    double? externalCharges,
    int? paymentMode,
    String? status,
    Map<String, String>? measurementNotes,
    DateTime? createdAt,
    List<OrderItemEntity>? items,
    bool? isDeleted,
  }) {
    return OrderEntity(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      shopId: shopId ?? this.shopId,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      garmentTypes: garmentTypes ?? this.garmentTypes,
      garmentQuantities: garmentQuantities ?? this.garmentQuantities,
      garmentPrices: garmentPrices ?? this.garmentPrices,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      referenceImagePath: referenceImagePath ?? this.referenceImagePath,
      measurements: measurements ?? this.measurements,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      priorityIndex: priorityIndex ?? this.priorityIndex,
      assignedTailor: assignedTailor ?? this.assignedTailor,
      totalAmount: totalAmount ?? this.totalAmount,
      advancePaid: advancePaid ?? this.advancePaid,
      externalCharges: externalCharges ?? this.externalCharges,
      paymentMode: paymentMode ?? this.paymentMode,
      status: status ?? this.status,
      measurementNotes: measurementNotes ?? this.measurementNotes,
      createdAt: createdAt ?? this.createdAt,
      items: items ?? this.items,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  List<Object?> get props => [
    id,
    orderNumber,
    shopId,
    customerId,
    customerName,
    customerPhone,
    garmentTypes,
    garmentQuantities,
    garmentPrices,
    specialInstructions,
    referenceImagePath,
    measurements,
    deliveryDate,
    priorityIndex,
    assignedTailor,
    totalAmount,
    advancePaid,
    externalCharges,
    paymentMode,
    status,
    measurementNotes,
    createdAt,
    items,
    isDeleted,
  ];
}
