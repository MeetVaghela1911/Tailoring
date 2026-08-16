import 'package:isar_community/isar.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/database/local_database.dart';
import '../../../../core/error/exceptions.dart';
import '../models/payment_transaction_local_model.dart';
import '../models/payment_transaction_model.dart';

abstract class PaymentLocalDataSource {
  Future<List<PaymentTransactionModel>> getPaymentsForOrder(String orderId);
  Future<List<PaymentTransactionModel>> getPaymentsForCustomer(String customerId);
  Future<List<PaymentTransactionModel>> getAllPayments();
  Future<PaymentTransactionModel> addPayment(PaymentTransactionModel transaction);
  Future<List<PaymentTransactionLocalModel>> getUnsyncedPayments();
  Future<void> markAsSynced(String remoteId);
  Future<void> upsertPayments(List<PaymentTransactionModel> transactions);
}

class PaymentLocalDataSourceImpl implements PaymentLocalDataSource {
  final LocalDatabase localDb;
  final Uuid _uuid = const Uuid();

  PaymentLocalDataSourceImpl({required this.localDb});

  @override
  Future<List<PaymentTransactionModel>> getPaymentsForOrder(String orderId) async {
    try {
      final items = await localDb.isar.paymentTransactionLocalModels
          .filter()
          .orderIdEqualTo(orderId)
          .findAll();
      items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return items.map(_toModel).toList();
    } catch (e) {
      throw CacheException('Failed to fetch payments for order: $e');
    }
  }

  @override
  Future<List<PaymentTransactionModel>> getPaymentsForCustomer(String customerId) async {
    try {
      final items = await localDb.isar.paymentTransactionLocalModels
          .filter()
          .customerIdEqualTo(customerId)
          .findAll();
      items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return items.map(_toModel).toList();
    } catch (e) {
      throw CacheException('Failed to fetch payments for customer: $e');
    }
  }

  @override
  Future<List<PaymentTransactionModel>> getAllPayments() async {
    try {
      final items = await localDb.isar.paymentTransactionLocalModels.where().findAll();
      items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return items.map(_toModel).toList();
    } catch (e) {
      throw CacheException('Failed to fetch all payments: $e');
    }
  }

  @override
  Future<PaymentTransactionModel> addPayment(PaymentTransactionModel transaction) async {
    final String remoteId = transaction.id.isEmpty ? _uuid.v4() : transaction.id;

    final localModel = PaymentTransactionLocalModel()
      ..remoteId = remoteId
      ..orderId = transaction.orderId
      ..customerId = transaction.customerId
      ..customerName = transaction.customerName
      ..customerPhone = transaction.customerPhone
      ..amount = transaction.amount
      ..paymentMode = transaction.paymentMode
      ..paymentModeName = transaction.paymentModeName
      ..paymentStage = transaction.paymentStage
      ..notes = transaction.notes
      ..referenceNumber = transaction.referenceNumber
      ..createdAt = transaction.createdAt
      ..isSynced = false;

    try {
      await localDb.isar.writeTxn(() async {
        await localDb.isar.paymentTransactionLocalModels.put(localModel);
      });
    } catch (e) {
      throw CacheException('Failed to add payment transaction to local db: $e');
    }

    return _toModel(localModel);
  }

  @override
  Future<List<PaymentTransactionLocalModel>> getUnsyncedPayments() async {
    return await localDb.isar.paymentTransactionLocalModels
        .filter()
        .isSyncedEqualTo(false)
        .findAll();
  }

  @override
  Future<void> markAsSynced(String remoteId) async {
    final payment = await localDb.isar.paymentTransactionLocalModels
        .filter()
        .remoteIdEqualTo(remoteId)
        .findFirst();
    if (payment != null) {
      payment.isSynced = true;
      await localDb.isar.writeTxn(() async {
        await localDb.isar.paymentTransactionLocalModels.put(payment);
      });
    }
  }

  @override
  Future<void> upsertPayments(List<PaymentTransactionModel> transactions) async {
    final localModels = transactions.map((t) {
      return PaymentTransactionLocalModel()
        ..remoteId = t.id.isEmpty ? _uuid.v4() : t.id
        ..orderId = t.orderId
        ..customerId = t.customerId
        ..customerName = t.customerName
        ..customerPhone = t.customerPhone
        ..amount = t.amount
        ..paymentMode = t.paymentMode
        ..paymentModeName = t.paymentModeName
        ..paymentStage = t.paymentStage
        ..notes = t.notes
        ..referenceNumber = t.referenceNumber
        ..createdAt = t.createdAt
        ..isSynced = true;
    }).toList();

    await localDb.isar.writeTxn(() async {
      for (final model in localModels) {
        final existing = await localDb.isar.paymentTransactionLocalModels
            .filter()
            .remoteIdEqualTo(model.remoteId)
            .findFirst();
        if (existing != null) {
          model.id = existing.id;
        }
        await localDb.isar.paymentTransactionLocalModels.put(model);
      }
    });
  }

  PaymentTransactionModel _toModel(PaymentTransactionLocalModel local) {
    return PaymentTransactionModel(
      id: local.remoteId,
      orderId: local.orderId,
      customerId: local.customerId,
      customerName: local.customerName,
      customerPhone: local.customerPhone,
      amount: local.amount,
      paymentMode: local.paymentMode,
      paymentModeName: local.paymentModeName,
      paymentStage: local.paymentStage,
      notes: local.notes,
      referenceNumber: local.referenceNumber,
      createdAt: local.createdAt,
    );
  }
}
