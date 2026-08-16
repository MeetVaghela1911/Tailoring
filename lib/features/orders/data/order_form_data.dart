import 'dart:io';
import 'package:equatable/equatable.dart';

/// Shared data object passed between the multi-step create/edit order flow.
/// All fields are final to ensure immutability.
class OrderFormData extends Equatable {
  // Step 1 — Customer
  final String? customerName;
  final String? customerPhone;
  final String? customerId;

  // Step 2 — Garments & Design
  final List<String> garmentTypes;
  final Map<String, double> garmentPrices;
  final Map<String, int> garmentQuantities;
  final String specialInstructions;
  // File picked by user (not yet uploaded)
  final File? referenceImageFile;
  // reference image path (if any, e.g. Supabase URL)
  final String? referenceImagePath;

  // Step 3 — Measurements
  // garment → measurement map (e.g. "Blouse" → "Bust:36\"")
  final Map<String, String> measurements;

  // Step 4 — Schedule & Assign
  final DateTime? deliveryDate;
  final int priorityIndex;   // 0=Normal, 1=High, 2=Urgent
  final String assignedTailor;

  // Step 5 — Payment
  final double totalAmount;
  final double advancePaid;
  final double externalCharges;
  final int paymentMode;     // 0=Cash, 1=Card, 2=UPI/Online
  final String status;
  final Map<String, String> measurementNotes;

  /// Whether this form is editing an existing order (vs creating new).
  final bool isEditing;
  final String? existingOrderRef;

  const OrderFormData({
    this.customerName,
    this.customerPhone,
    this.customerId,
    this.garmentTypes = const [],
    this.garmentQuantities = const {},
    this.garmentPrices = const {},
    this.specialInstructions = '',
    this.referenceImageFile,
    this.referenceImagePath,
    this.measurements = const {},
    this.deliveryDate,
    this.priorityIndex = 1, // 1=Normal, 2=High, 3=Urgent
    this.assignedTailor = '',
    this.totalAmount = 0,
    this.advancePaid = 0,
    this.externalCharges = 0,
    this.paymentMode = 0, // 0=Cash, 1=Card, 2=Online/UPI
    this.status = 'NOT STARTED',
    this.measurementNotes = const {},
    this.isEditing = false,
    this.existingOrderRef,
  });

  // Convenience — display priority as string
  String get priorityLabel {
    switch (priorityIndex) {
      case 1: return 'Normal';
      case 2: return 'High';
      case 3: return 'Urgent';
      default: return 'Normal';
    }
  }

  // Convenience — display payment mode as string
  String get paymentModeLabel {
    switch (paymentMode) {
      case 0: return 'Cash';
      case 1: return 'Card';
      case 2: return 'Online / UPI';
      default: return 'Cash';
    }
  }

  // Balance due
  double get balanceDue => (totalAmount - advancePaid).clamp(0, double.infinity);

  // Create a copy with updated fields
  OrderFormData copyWith({
    String? customerName,
    String? customerPhone,
    String? customerId,
    List<String>? garmentTypes,
    Map<String, int>? garmentQuantities,
    Map<String, double>? garmentPrices,
    String? specialInstructions,
    File? referenceImageFile,
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
    bool? isEditing,
    String? existingOrderRef,
  }) {
    return OrderFormData(
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerId: customerId ?? this.customerId,
      garmentTypes: garmentTypes ?? this.garmentTypes,
      garmentQuantities: garmentQuantities ?? this.garmentQuantities,
      garmentPrices: garmentPrices ?? this.garmentPrices,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      referenceImageFile: referenceImageFile ?? this.referenceImageFile,
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
      isEditing: isEditing ?? this.isEditing,
      existingOrderRef: existingOrderRef ?? this.existingOrderRef,
    );
  }

  @override
  List<Object?> get props => [
        customerName,
        customerPhone,
        customerId,
        garmentTypes,
        garmentQuantities,
        garmentPrices,
        specialInstructions,
        referenceImageFile,
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
        isEditing,
        existingOrderRef,
      ];
}
