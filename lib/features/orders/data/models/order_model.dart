import '../../domain/entities/order_entity.dart';
import 'order_item_model.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    super.orderNumber,
    super.shopId,
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
    super.assignedTailor = '',
    required super.totalAmount,
    required super.advancePaid,
    super.externalCharges = 0.0,
    required super.paymentMode,
    required super.status,
    super.measurementNotes = const {},
    required super.createdAt,
    super.items = const [],
    super.isDeleted = false,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    List<OrderItemModel> itemsList = [];
    if (json['items'] != null && json['items'] is List) {
      itemsList = (json['items'] as List)
          .map((i) => OrderItemModel.fromJson(i as Map<String, dynamic>))
          .toList();
    }

    // Customer relation fallback if joined
    String? cName = json['customer_name'] as String?;
    String? cPhone = json['customer_phone'] as String?;
    if (json['customer'] != null && json['customer'] is Map) {
      final cust = json['customer'] as Map<String, dynamic>;
      cName ??= cust['name'] as String?;
      cPhone ??= cust['phone_number'] as String?;
    }

    final rawGarmentTypes = json['garment_types'] != null
        ? List<String>.from(json['garment_types'] as List)
        : itemsList.map((e) => e.garmentName).toList();

    final mappedGarmentTypes = rawGarmentTypes.map((g) {
      if (itemsList.isNotEmpty) {
        final itemMatch = itemsList.where(
          (i) => (i.templateId == g || i.garmentName.toLowerCase() == g.toLowerCase() || i.id == g) &&
                 i.templateId != null && i.templateId!.isNotEmpty,
        ).firstOrNull;
        if (itemMatch != null && itemMatch.templateId != null && itemMatch.templateId!.isNotEmpty) {
          return itemMatch.templateId!;
        }
      }
      return g;
    }).toList();

    final mergedTypes = mappedGarmentTypes.isNotEmpty ? mappedGarmentTypes : itemsList.map((e) => e.garmentName).toList();
    
    final mergedMeasurements = <String, String>{};
    if (json['measurements'] != null && json['measurements'] is Map) {
      (json['measurements'] as Map).forEach((k, v) {
        if (v != null) mergedMeasurements[k.toString()] = v.toString();
      });
    }

    final mergedNotes = <String, String>{};
    if (json['measurement_notes'] != null && json['measurement_notes'] is Map) {
      (json['measurement_notes'] as Map).forEach((k, v) {
        if (v != null) mergedNotes[k.toString()] = v.toString();
      });
    }

    final mergedQuantities = <String, int>{};
    if (json['garment_quantities'] != null && json['garment_quantities'] is Map) {
      (json['garment_quantities'] as Map).forEach((k, v) {
        if (v is num) mergedQuantities[k.toString()] = v.toInt();
      });
    }

    final mergedPrices = <String, double>{};
    if (json['garment_prices'] != null && json['garment_prices'] is Map) {
      (json['garment_prices'] as Map).forEach((k, v) {
        if (v is num) mergedPrices[k.toString()] = v.toDouble();
      });
    }

    for (var i in itemsList) {
      if (i.garmentName.isNotEmpty) {
        mergedQuantities.putIfAbsent(i.garmentName, () => i.quantity);
        mergedPrices.putIfAbsent(i.garmentName, () => i.unitPrice);
        if (i.templateId != null && i.templateId!.isNotEmpty) {
          mergedQuantities.putIfAbsent(i.templateId!, () => i.quantity);
        }

        if (i.measurements.isNotEmpty) {
          i.measurements.forEach((k, v) {
            if (v.isNotEmpty) {
              if (mergedTypes.contains(k) || k == i.garmentName) {
                mergedMeasurements[k] = v;
              } else {
                mergedMeasurements[i.garmentName] = v;
              }
              if (i.templateId != null && i.templateId!.isNotEmpty) {
                mergedMeasurements[i.templateId!] = v;
              }
            }
          });
        }

        if (i.measurementNotes.isNotEmpty) {
          i.measurementNotes.forEach((k, v) {
            if (v.isNotEmpty) {
              if (mergedTypes.contains(k) || k == i.garmentName) {
                mergedNotes[k] = v;
              } else {
                mergedNotes[i.garmentName] = v;
              }
              if (i.templateId != null && i.templateId!.isNotEmpty) {
                mergedNotes[i.templateId!] = v;
              }
            }
          });
        }
      }
    }

    return OrderModel(
      id: json['id'] as String,
      orderNumber: (json['order_number'] as num?)?.toInt(),
      shopId: json['shop_id'] as String?,
      customerId: json['customer_id'] as String?,
      customerName: cName,
      customerPhone: cPhone,
      garmentTypes: mergedTypes,
      garmentQuantities: mergedQuantities,
      garmentPrices: mergedPrices,
      specialInstructions: json['special_instructions'] as String? ?? '',
      referenceImagePath: json['reference_image_path'] as String?,
      measurements: mergedMeasurements,
      deliveryDate: json['delivery_date'] != null
          ? DateTime.parse(json['delivery_date'] as String)
          : null,
      priorityIndex: (json['priority_index'] as num?)?.toInt() ?? 1,
      assignedTailor: json['assigned_tailor'] as String? ?? '',
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      advancePaid: (json['advance_paid'] as num?)?.toDouble() ?? 0.0,
      externalCharges: (json['external_charges'] as num?)?.toDouble() ?? 0.0,
      paymentMode: (json['payment_mode'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? 'NOT STARTED',
      measurementNotes: mergedNotes,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      items: itemsList,
      isDeleted: json['is_deleted'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      if (shopId != null && shopId!.isNotEmpty) 'shop_id': shopId,
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
      if (items.isNotEmpty)
        'items': items.map((e) => (e is OrderItemModel ? e : OrderItemModel(
          id: e.id,
          orderId: e.orderId,
          templateId: e.templateId,
          garmentName: e.garmentName,
          quantity: e.quantity,
          unitPrice: e.unitPrice,
          measurements: e.measurements,
          measurementNotes: e.measurementNotes,
          status: e.status,
        )).toJson()).toList(),
      'is_deleted': isDeleted,
    };
  }

  OrderEntity toEntity() {
    return OrderEntity(
      id: id,
      orderNumber: orderNumber,
      shopId: shopId,
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
      items: items,
      isDeleted: isDeleted,
    );
  }

  factory OrderModel.fromEntity(OrderEntity entity) {
    return OrderModel(
      id: entity.id,
      orderNumber: entity.orderNumber,
      shopId: entity.shopId,
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
      items: entity.items,
      isDeleted: entity.isDeleted,
    );
  }
}
