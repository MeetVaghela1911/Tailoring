import 'dart:convert';
import 'package:isar_community/isar.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/database/local_database.dart';
import '../../../../core/error/exceptions.dart';
import '../models/order_local_model.dart';
import '../models/order_model.dart';

abstract class OrderLocalDataSource {
  Future<List<OrderModel>> getOrders();
  Future<OrderModel?> getOrderById(String id);
  Future<List<OrderModel>> getOrdersByCustomer(String customerId);
  Future<OrderModel> addOrder(OrderModel order);
  Future<OrderModel> updateOrder(OrderModel order);
  Future<void> deleteOrder(String id);
  Future<List<OrderLocalModel>> getUnsyncedOrders();
  Future<void> markAsSynced(String id);
  Future<void> upsertOrders(List<OrderModel> orders);
}

class OrderLocalDataSourceImpl implements OrderLocalDataSource {
  final LocalDatabase localDb;
  final Uuid _uuid = const Uuid();

  OrderLocalDataSourceImpl({required this.localDb});

  @override
  Future<List<OrderModel>> getOrders() async {
    try {
      final orders = await localDb.isar.orderLocalModels.where().findAll();
      return orders.map(_toOrderModel).toList();
    } catch (e) {
      throw CacheException('Failed to fetch orders from local database: $e');
    }
  }
  
  @override
  Future<OrderModel?> getOrderById(String id) async {
    final order = await localDb.isar.orderLocalModels.filter().remoteIdEqualTo(id).findFirst();
    if (order == null) return null;
    return _toOrderModel(order);
  }

  @override
  Future<List<OrderModel>> getOrdersByCustomer(String customerId) async {
    final orders = await localDb.isar.orderLocalModels.filter().customerIdEqualTo(customerId).findAll();
    return orders.map(_toOrderModel).toList();
  }

  @override
  Future<OrderModel> addOrder(OrderModel order) async {
    final String remoteId = order.id.isEmpty ? _uuid.v4() : order.id;

    final localModel = OrderLocalModel()
      ..remoteId = remoteId
      ..customerId = order.customerId
      ..customerName = order.customerName
      ..customerPhone = order.customerPhone
      ..garmentTypes = order.garmentTypes
      ..specialInstructions = order.specialInstructions
      ..referenceImagePath = order.referenceImagePath
      ..measurementsJson = jsonEncode(order.measurements)
      ..measurementNotesJson = jsonEncode(order.measurementNotes)
      ..garmentQuantitiesJson = jsonEncode(order.garmentQuantities)
      ..garmentPricesJson = jsonEncode(order.garmentPrices)
      ..deliveryDate = order.deliveryDate
      ..priorityIndex = order.priorityIndex
      ..assignedTailor = order.assignedTailor
      ..totalAmount = order.totalAmount
      ..advancePaid = order.advancePaid
      ..externalCharges = order.externalCharges
      ..paymentMode = order.paymentMode
      ..status = order.status
      ..createdAt = order.createdAt
      ..isSynced = false
      ..lastUpdated = DateTime.now();

    try {
      await localDb.isar.writeTxn(() async {
        await localDb.isar.orderLocalModels.put(localModel);
      });
    } catch (e) {
      throw CacheException('Failed to add order to local database: $e');
    }

    return _toOrderModel(localModel);
  }

  @override
  Future<OrderModel> updateOrder(OrderModel order) async {
    final existingLocal = await localDb.isar.orderLocalModels.filter().remoteIdEqualTo(order.id).findFirst();
    
    if (existingLocal == null) {
      throw Exception('Order not found in local database');
    }

    existingLocal
      ..customerId = order.customerId
      ..customerName = order.customerName
      ..customerPhone = order.customerPhone
      ..garmentTypes = order.garmentTypes
      ..specialInstructions = order.specialInstructions
      ..referenceImagePath = order.referenceImagePath
      ..measurementsJson = jsonEncode(order.measurements)
      ..measurementNotesJson = jsonEncode(order.measurementNotes)
      ..garmentQuantitiesJson = jsonEncode(order.garmentQuantities)
      ..garmentPricesJson = jsonEncode(order.garmentPrices)
      ..deliveryDate = order.deliveryDate
      ..priorityIndex = order.priorityIndex
      ..assignedTailor = order.assignedTailor
      ..totalAmount = order.totalAmount
      ..advancePaid = order.advancePaid
      ..externalCharges = order.externalCharges
      ..paymentMode = order.paymentMode
      ..status = order.status
      ..isSynced = false
      ..lastUpdated = DateTime.now();

    try {
      await localDb.isar.writeTxn(() async {
        await localDb.isar.orderLocalModels.put(existingLocal);
      });
    } catch (e) {
      throw CacheException('Failed to update order in local database: $e');
    }

    return _toOrderModel(existingLocal);
  }

  @override
  Future<void> deleteOrder(String id) async {
    try {
      await localDb.isar.writeTxn(() async {
        await localDb.isar.orderLocalModels.filter().remoteIdEqualTo(id).deleteAll();
      });
    } catch (e) {
      throw CacheException('Failed to delete order from local database: $e');
    }
  }

  @override
  Future<List<OrderLocalModel>> getUnsyncedOrders() async {
    return await localDb.isar.orderLocalModels.filter().isSyncedEqualTo(false).findAll();
  }

  @override
  Future<void> markAsSynced(String id) async {
    final order = await localDb.isar.orderLocalModels.filter().remoteIdEqualTo(id).findFirst();
    if (order != null) {
      order.isSynced = true;
      await localDb.isar.writeTxn(() async {
        await localDb.isar.orderLocalModels.put(order);
      });
    }
  }

  OrderModel _toOrderModel(OrderLocalModel local) {
    Map<String, String> parsedMeasurements = {};
    Map<String, int> parsedQuantities = {};
    try {
      final decodedMap = jsonDecode(local.measurementsJson) as Map<String, dynamic>;
      parsedMeasurements = decodedMap.map((key, value) => MapEntry(key, value.toString()));

      Map<String, String> parsedNotes = {};
      if (local.measurementNotesJson.isNotEmpty) {
        final decodedNotes = jsonDecode(local.measurementNotesJson) as Map<String, dynamic>;
        parsedNotes = decodedNotes.map((key, value) => MapEntry(key, value.toString()));
      }
      
      final qtyMap = jsonDecode(local.garmentQuantitiesJson) as Map<String, dynamic>;
      parsedQuantities = qtyMap.map((key, value) => MapEntry(key, (value as num).toInt()));

      final priceMap = jsonDecode(local.garmentPricesJson) as Map<String, dynamic>;
      final parsedPrices = priceMap.map((key, value) => MapEntry(key, (value as num).toDouble()));

      return OrderModel(
        id: local.remoteId,
        customerId: local.customerId,
        customerName: local.customerName,
        customerPhone: local.customerPhone,
        garmentTypes: local.garmentTypes,
        garmentQuantities: parsedQuantities,
        garmentPrices: parsedPrices,
        specialInstructions: local.specialInstructions ?? '',
        referenceImagePath: local.referenceImagePath,
        measurements: parsedMeasurements,
        deliveryDate: local.deliveryDate,
        priorityIndex: local.priorityIndex,
        assignedTailor: local.assignedTailor,
        totalAmount: local.totalAmount,
        advancePaid: local.advancePaid,
        externalCharges: local.externalCharges,
        paymentMode: local.paymentMode,
        status: local.status,
        measurementNotes: parsedNotes,
        createdAt: local.createdAt,
      );
    } catch (e) {
      // In case of parsing error, fallback
      return OrderModel(
        id: local.remoteId,
        customerId: local.customerId,
        customerName: local.customerName,
        customerPhone: local.customerPhone,
        garmentTypes: local.garmentTypes,
        garmentQuantities: {},
        garmentPrices: {},
        specialInstructions: local.specialInstructions ?? '',
        referenceImagePath: local.referenceImagePath,
        measurements: parsedMeasurements,
        deliveryDate: local.deliveryDate,
        priorityIndex: local.priorityIndex,
        assignedTailor: local.assignedTailor,
        totalAmount: local.totalAmount,
        advancePaid: local.advancePaid,
        externalCharges: local.externalCharges,
        paymentMode: local.paymentMode,
        status: local.status,
        measurementNotes: {},
        createdAt: local.createdAt,
      );
    }
  }

  @override
  Future<void> upsertOrders(List<OrderModel> orders) async {
    final localModels = orders.map((o) {
      return OrderLocalModel()
        ..remoteId = o.id.isEmpty ? _uuid.v4() : o.id
        ..customerId = o.customerId
        ..customerName = o.customerName
        ..customerPhone = o.customerPhone
        ..garmentTypes = o.garmentTypes
        ..specialInstructions = o.specialInstructions
        ..referenceImagePath = o.referenceImagePath
        ..measurementsJson = jsonEncode(o.measurements)
        ..measurementNotesJson = jsonEncode(o.measurementNotes)
        ..garmentQuantitiesJson = jsonEncode(o.garmentQuantities)
        ..garmentPricesJson = jsonEncode(o.garmentPrices)
        ..deliveryDate = o.deliveryDate
        ..priorityIndex = o.priorityIndex
        ..assignedTailor = o.assignedTailor
        ..totalAmount = o.totalAmount
        ..advancePaid = o.advancePaid
        ..externalCharges = o.externalCharges
        ..paymentMode = o.paymentMode
        ..status = o.status
        ..createdAt = o.createdAt
        ..isSynced = true
        ..lastUpdated = DateTime.now();
    }).toList();

    await localDb.isar.writeTxn(() async {
      for (final localModel in localModels) {
        final existingLocal = await localDb.isar.orderLocalModels
            .filter()
            .remoteIdEqualTo(localModel.remoteId)
            .findFirst();
        
        if (existingLocal != null) {
          localModel.id = existingLocal.id;
        }
        await localDb.isar.orderLocalModels.put(localModel);
      }
    });
  }
}
