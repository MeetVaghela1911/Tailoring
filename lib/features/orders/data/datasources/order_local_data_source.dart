import 'dart:convert';
import 'package:isar_community/isar.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/database/local_database.dart';
import '../../../../core/error/exceptions.dart';
import '../models/order_local_model.dart';
import '../models/order_model.dart';
import '../../../customers/data/models/customer_local_model.dart';

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

  Future<Map<String, CustomerLocalModel>> _getCustomersMap() async {
    try {
      final customers = await localDb.isar.customerLocalModels.where().findAll();
      return {for (var c in customers) c.remoteId: c};
    } catch (_) {
      return {};
    }
  }

  @override
  Future<List<OrderModel>> getOrders() async {
    try {
      final orders = await localDb.isar.orderLocalModels.filter().isDeletedEqualTo(false).findAll();
      
      // Auto-heal any corrupted legacy records with empty remoteId
      final corrupted = orders.where((o) => o.remoteId.trim().isEmpty).toList();
      if (corrupted.isNotEmpty) {
        await localDb.isar.writeTxn(() async {
          for (final o in corrupted) {
            o.remoteId = _uuid.v4();
            await localDb.isar.orderLocalModels.put(o);
          }
        });
      }

      final customersMap = await _getCustomersMap();
      final list = orders.map((o) => _toOrderModel(o, customersMap)).toList();
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return list;
    } catch (e) {
      throw CacheException('Failed to fetch orders from local database: $e');
    }
  }
  
  @override
  Future<OrderModel?> getOrderById(String id) async {
    if (id.trim().isEmpty) return null;
    final order = await localDb.isar.orderLocalModels.filter().remoteIdEqualTo(id).isDeletedEqualTo(false).findFirst();
    if (order == null) return null;
    final customersMap = await _getCustomersMap();
    return _toOrderModel(order, customersMap);
  }

  @override
  Future<List<OrderModel>> getOrdersByCustomer(String customerId) async {
    if (customerId.trim().isEmpty) return [];
    final orders = await localDb.isar.orderLocalModels.filter().customerIdEqualTo(customerId).isDeletedEqualTo(false).findAll();
    final customersMap = await _getCustomersMap();
    return orders.map((o) => _toOrderModel(o, customersMap)).toList();
  }

  @override
  Future<OrderModel> addOrder(OrderModel order) async {
    final String remoteId = order.id.isEmpty ? _uuid.v4() : order.id;

    String? custName = order.customerName;
    String? custPhone = order.customerPhone;

    if (order.customerId != null && order.customerId!.isNotEmpty) {
      final cust = await localDb.isar.customerLocalModels
          .filter()
          .remoteIdEqualTo(order.customerId!)
          .findFirst();
      if (cust != null) {
        custName = cust.name;
        custPhone = cust.phoneNumber;
      }
    }

    final localModel = OrderLocalModel()
      ..remoteId = remoteId
      ..customerId = order.customerId
      ..customerName = custName
      ..customerPhone = custPhone
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
      ..isDeleted = order.isDeleted
      ..isSynced = false
      ..lastUpdated = DateTime.now();

    try {
      await localDb.isar.writeTxn(() async {
        await localDb.isar.orderLocalModels.put(localModel);
      });
    } catch (e) {
      throw CacheException('Failed to add order to local database: $e');
    }

    final customersMap = await _getCustomersMap();
    return _toOrderModel(localModel, customersMap);
  }

  @override
  Future<OrderModel> updateOrder(OrderModel order) async {
    if (order.id.trim().isEmpty) {
      throw Exception('Cannot update order with empty ID');
    }
    final existingLocal = await localDb.isar.orderLocalModels.filter().remoteIdEqualTo(order.id).findFirst();
    
    if (existingLocal == null) {
      throw Exception('Order not found in local database');
    }

    String? custName = order.customerName;
    String? custPhone = order.customerPhone;

    if (order.customerId != null && order.customerId!.isNotEmpty) {
      final cust = await localDb.isar.customerLocalModels
          .filter()
          .remoteIdEqualTo(order.customerId!)
          .findFirst();
      if (cust != null) {
        custName = cust.name;
        custPhone = cust.phoneNumber;
      }
    }

    existingLocal
      ..customerId = order.customerId
      ..customerName = custName
      ..customerPhone = custPhone
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
      ..isDeleted = order.isDeleted
      ..isSynced = false
      ..lastUpdated = DateTime.now();

    try {
      await localDb.isar.writeTxn(() async {
        await localDb.isar.orderLocalModels.put(existingLocal);
      });
    } catch (e) {
      throw CacheException('Failed to update order in local database: $e');
    }

    final customersMap = await _getCustomersMap();
    return _toOrderModel(existingLocal, customersMap);
  }

  @override
  Future<void> deleteOrder(String id) async {
    if (id.trim().isEmpty) return;
    try {
      await localDb.isar.writeTxn(() async {
        final existingLocal = await localDb.isar.orderLocalModels.filter().remoteIdEqualTo(id).findFirst();
        if (existingLocal != null) {
          existingLocal.isDeleted = true;
          existingLocal.isSynced = false;
          existingLocal.lastUpdated = DateTime.now();
          await localDb.isar.orderLocalModels.put(existingLocal);
        }
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

  OrderModel _toOrderModel(OrderLocalModel local, [Map<String, CustomerLocalModel>? customersMap]) {
    String? resolvedName = local.customerName;
    String? resolvedPhone = local.customerPhone;

    if (local.customerId != null && local.customerId!.isNotEmpty && customersMap != null) {
      final customer = customersMap[local.customerId!];
      if (customer != null) {
        resolvedName = customer.name;
        resolvedPhone = customer.phoneNumber;
      }
    }

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
        customerName: resolvedName,
        customerPhone: resolvedPhone,
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
        isDeleted: local.isDeleted,
      );
    } catch (e) {
      // In case of parsing error, fallback
      return OrderModel(
        id: local.remoteId,
        customerId: local.customerId,
        customerName: resolvedName,
        customerPhone: resolvedPhone,
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
        isDeleted: local.isDeleted,
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
        ..isDeleted = o.isDeleted
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
