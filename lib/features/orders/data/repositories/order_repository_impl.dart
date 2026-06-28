import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_remote_data_source.dart';
import '../datasources/order_local_data_source.dart';
import '../../../../core/services/plan_service.dart';
import '../../../sync/domain/services/sync_manager.dart';
import '../models/order_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;
  final OrderLocalDataSource localDataSource;
  final PlanService planService;
  final SyncManager syncManager;

  OrderRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.planService,
    required this.syncManager,
  });

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrders() async {
    try {
      final localModels = await localDataSource.getOrders();
      if (localModels.isEmpty && planService.currentPlan == AppPlan.premium) {
        await syncManager.syncData();
        final syncedModels = await localDataSource.getOrders();
        return Right(syncedModels.map((m) => m.toEntity()).toList());
      }
      
      syncManager.syncData();
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
