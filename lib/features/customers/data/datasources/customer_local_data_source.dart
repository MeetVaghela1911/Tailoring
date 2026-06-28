import 'package:isar_community/isar.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/database/local_database.dart';
import '../../../../core/error/exceptions.dart';
import '../models/customer_local_model.dart';
import '../models/customer_model.dart';

abstract class CustomerLocalDataSource {
  Future<List<CustomerModel>> getCustomers();
  Future<CustomerModel?> getCustomerById(String id);
  Future<CustomerModel> addCustomer(CustomerModel customer);
  Future<CustomerModel> updateCustomer(CustomerModel customer);
  Future<void> deleteCustomer(String id);
  Future<List<CustomerLocalModel>> getUnsyncedCustomers();
  Future<void> markAsSynced(String id);
  Future<void> upsertCustomers(List<CustomerModel> customers);
}

class CustomerLocalDataSourceImpl implements CustomerLocalDataSource {
  final LocalDatabase localDb;
  final Uuid _uuid = const Uuid();

  CustomerLocalDataSourceImpl({required this.localDb});

  @override
  Future<List<CustomerModel>> getCustomers() async {
    try {
      final customers = await localDb.isar.customerLocalModels.where().findAll();
      return customers.map(_toCustomerModel).toList();
    } catch (e) {
      throw CacheException('Failed to fetch customers from local database: $e');
    }
  }

  @override
  Future<CustomerModel?> getCustomerById(String id) async {
    final customer = await localDb.isar.customerLocalModels.filter().remoteIdEqualTo(id).findFirst();
    if (customer == null) return null;
    return _toCustomerModel(customer);
  }

  @override
  Future<CustomerModel> addCustomer(CustomerModel customer) async {
    // Generate UUID if the entity doesn't have one (though it usually should from UI layer)
    final String remoteId = customer.id.isEmpty ? _uuid.v4() : customer.id;

    final localModel = CustomerLocalModel()
      ..remoteId = remoteId
      ..name = customer.name
      ..phoneNumber = customer.phoneNumber
      ..email = customer.email
      ..address = customer.address
      ..notes = customer.notes
      ..createdAt = customer.createdAt
      ..colorHex = customer.colorHex
      ..profileImageUrl = customer.profileImageUrl
      ..isSynced = false 
      ..lastUpdated = DateTime.now();

    try {
      await localDb.isar.writeTxn(() async {
        await localDb.isar.customerLocalModels.put(localModel);
      });
    } catch (e) {
      throw CacheException('Failed to add customer to local database: $e');
    }

    return _toCustomerModel(localModel);
  }

  @override
  Future<CustomerModel> updateCustomer(CustomerModel customer) async {
    final existingLocal = await localDb.isar.customerLocalModels.filter().remoteIdEqualTo(customer.id).findFirst();
    
    if (existingLocal == null) {
      throw Exception('Customer not found in local database');
    }

    existingLocal
      ..name = customer.name
      ..phoneNumber = customer.phoneNumber
      ..email = customer.email
      ..address = customer.address
      ..notes = customer.notes
      ..colorHex = customer.colorHex
      ..profileImageUrl = customer.profileImageUrl
      ..isSynced = false
      ..lastUpdated = DateTime.now();

    try {
      await localDb.isar.writeTxn(() async {
        await localDb.isar.customerLocalModels.put(existingLocal);
      });
    } catch (e) {
      throw CacheException('Failed to update customer in local database: $e');
    }

    return _toCustomerModel(existingLocal);
  }

  @override
  Future<void> deleteCustomer(String id) async {
    try {
      await localDb.isar.writeTxn(() async {
        await localDb.isar.customerLocalModels.filter().remoteIdEqualTo(id).deleteAll();
      });
    } catch (e) {
      throw CacheException('Failed to delete customer from local database: $e');
    }
  }
  
  @override
  Future<List<CustomerLocalModel>> getUnsyncedCustomers() async {
    return await localDb.isar.customerLocalModels.filter().isSyncedEqualTo(false).findAll();
  }
  
  @override
  Future<void> markAsSynced(String id) async {
    final customer = await localDb.isar.customerLocalModels.filter().remoteIdEqualTo(id).findFirst();
    if (customer != null) {
      customer.isSynced = true;
      await localDb.isar.writeTxn(() async {
        await localDb.isar.customerLocalModels.put(customer);
      });
    }
  }

  // Mapper
  CustomerModel _toCustomerModel(CustomerLocalModel local) {
    return CustomerModel(
      id: local.remoteId,
      name: local.name,
      phoneNumber: local.phoneNumber,
      email: local.email,
      address: local.address,
      notes: local.notes,
      createdAt: local.createdAt,
      colorHex: local.colorHex,
      profileImageUrl: local.profileImageUrl,
    );
  }

  @override
  Future<void> upsertCustomers(List<CustomerModel> customers) async {
    final localModels = customers.map((c) {
      return CustomerLocalModel()
        ..remoteId = c.id.isEmpty ? _uuid.v4() : c.id
        ..name = c.name
        ..phoneNumber = c.phoneNumber
        ..email = c.email
        ..address = c.address
        ..notes = c.notes
        ..createdAt = c.createdAt
        ..colorHex = c.colorHex
        ..profileImageUrl = c.profileImageUrl
        ..isSynced = true
        ..lastUpdated = DateTime.now();
    }).toList();

    await localDb.isar.writeTxn(() async {
      for (final localModel in localModels) {
        // Need to find existing ID to preserve the internal Isar ID if it exists
        final existingLocal = await localDb.isar.customerLocalModels
            .filter()
            .remoteIdEqualTo(localModel.remoteId)
            .findFirst();
        
        if (existingLocal != null) {
          localModel.id = existingLocal.id; // Isar auto-increment ID
        }
        await localDb.isar.customerLocalModels.put(localModel);
      }
    });
  }
}
