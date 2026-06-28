import 'package:equatable/equatable.dart';

class OrderEntity extends Equatable {
  final String id;
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

  const OrderEntity({
    required this.id,
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
    required this.assignedTailor,
    required this.totalAmount,
    required this.advancePaid,
    this.externalCharges = 0.0,
    required this.paymentMode,
    required this.status,
    this.measurementNotes = const {},
    required this.createdAt,
  });

  double get balanceDue => (totalAmount - advancePaid).clamp(0, double.infinity);

  OrderEntity copyWith({
    String? id,
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
  }) {
    return OrderEntity(
      id: id ?? this.id,
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
    );
  }

  @override
  List<Object?> get props => [
    id,
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
  ];
}
