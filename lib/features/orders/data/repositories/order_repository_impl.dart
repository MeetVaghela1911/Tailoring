import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/services/plan_service.dart';
import '../../../payments/data/datasources/payment_local_data_source.dart';
import '../../../payments/data/datasources/payment_remote_data_source.dart';
import '../../../payments/data/models/payment_transaction_model.dart';
import '../../../sync/domain/services/sync_manager.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_local_data_source.dart';
import '../datasources/order_remote_data_source.dart';
import '../models/order_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;
  final OrderLocalDataSource localDataSource;
  final PlanService planService;
  final SyncManager syncManager;
  final PaymentLocalDataSource? paymentLocalDataSource;
  final PaymentRemoteDataSource? paymentRemoteDataSource;
  final NetworkInfo? networkInfo;
  final Uuid _uuid = const Uuid();

  OrderRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.planService,
    required this.syncManager,
    this.paymentLocalDataSource,
    this.paymentRemoteDataSource,
    this.networkInfo,
  });

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrders() async {
    try {
      if (planService.currentPlan == AppPlan.premium) {
        try {
          await syncManager.syncData();
        } catch (_) {}
      }
      final localModels = await localDataSource.getOrders();
      return Right(localModels.map((m) => m.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> createOrder(OrderEntity order) async {
    try {
      final model = OrderModel.fromEntity(order);
      final localResult = await localDataSource.addOrder(model);

      // Automatically record initial advance payment transaction in Isar & Supabase
      if (order.advancePaid > 0 && paymentLocalDataSource != null) {
        try {
          final modeName = order.paymentMode == 1
              ? 'Cash'
              : order.paymentMode == 2
                  ? 'Card'
                  : 'UPI / Online';

          final txnModel = PaymentTransactionModel(
            id: _uuid.v4(),
            orderId: localResult.id,
            customerId: localResult.customerId,
            customerName: localResult.customerName,
            customerPhone: localResult.customerPhone,
            amount: localResult.advancePaid,
            paymentMode: localResult.paymentMode,
            paymentModeName: modeName,
            paymentStage: 'Advance',
            createdAt: localResult.createdAt,
          );

          await paymentLocalDataSource!.addPayment(txnModel);

          if (networkInfo != null && await networkInfo!.isConnected && paymentRemoteDataSource != null) {
            try {
              await paymentRemoteDataSource!.addPayment(txnModel);
              await paymentLocalDataSource!.markAsSynced(txnModel.id);
            } catch (_) {}
          }
        } catch (_) {}
      }

      syncManager.syncData();
      return Right(localResult.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> updateOrder(OrderEntity order) async {
    try {
      final model = OrderModel.fromEntity(order);
      final localResult = await localDataSource.updateOrder(model);

      if (paymentLocalDataSource != null) {
        try {
          final existingPayments = await paymentLocalDataSource!.getPaymentsForOrder(localResult.id);
          final advanceTxnIndex = existingPayments.indexWhere((p) => p.paymentStage == 'Advance');
          final modeName = localResult.paymentMode == 1
              ? 'Cash'
              : localResult.paymentMode == 2
                  ? 'Card'
                  : 'UPI / Online';

          if (advanceTxnIndex != -1) {
            final existingAdvance = existingPayments[advanceTxnIndex];
            final updatedTxn = PaymentTransactionModel(
              id: existingAdvance.id,
              orderId: localResult.id,
              customerId: localResult.customerId,
              customerName: localResult.customerName,
              customerPhone: localResult.customerPhone,
              amount: localResult.advancePaid,
              paymentMode: localResult.paymentMode,
              paymentModeName: modeName,
              paymentStage: 'Advance',
              notes: existingAdvance.notes,
              referenceNumber: existingAdvance.referenceNumber,
              createdAt: existingAdvance.createdAt,
            );

            await paymentLocalDataSource!.upsertPayments([updatedTxn]);

            if (networkInfo != null && await networkInfo!.isConnected && paymentRemoteDataSource != null) {
              try {
                await paymentRemoteDataSource!.addPayment(updatedTxn);
              } catch (_) {}
            }
          } else if (localResult.advancePaid > 0) {
            final newTxn = PaymentTransactionModel(
              id: _uuid.v4(),
              orderId: localResult.id,
              customerId: localResult.customerId,
              customerName: localResult.customerName,
              customerPhone: localResult.customerPhone,
              amount: localResult.advancePaid,
              paymentMode: localResult.paymentMode,
              paymentModeName: modeName,
              paymentStage: 'Advance',
              createdAt: DateTime.now(),
            );

            await paymentLocalDataSource!.addPayment(newTxn);

            if (networkInfo != null && await networkInfo!.isConnected && paymentRemoteDataSource != null) {
              try {
                await paymentRemoteDataSource!.addPayment(newTxn);
                await paymentLocalDataSource!.markAsSynced(newTxn.id);
              } catch (_) {}
            }
          }
        } catch (_) {}
      }

      syncManager.syncData();
      return Right(localResult.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteOrder(String id) async {
    try {
      await localDataSource.deleteOrder(id);
      if (planService.currentPlan == AppPlan.premium) {
        try {
          await remoteDataSource.deleteOrder(id);
        } catch (_) {}
      }
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderEntity?>> getOrderById(String id) async {
    try {
      final model = await localDataSource.getOrderById(id);
      return Right(model?.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
