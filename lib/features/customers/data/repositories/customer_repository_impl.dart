import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/customer.dart';
import '../../domain/repositories/customer_repository.dart';
import '../datasources/customer_remote_data_source.dart';
import '../datasources/customer_local_data_source.dart';
import '../../../../core/services/plan_service.dart';
import '../../../sync/domain/services/sync_manager.dart';
import '../models/customer_model.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final CustomerRemoteDataSource remoteDataSource;
  final CustomerLocalDataSource localDataSource;
  final PlanService planService;
  final SyncManager syncManager;

  CustomerRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.planService,
    required this.syncManager,
  });

  @override
  Future<Either<Failure, List<Customer>>> getCustomers() async {
    try {
      final localModels = await localDataSource.getCustomers();
      if (localModels.isEmpty && planService.currentPlan == AppPlan.premium) {
        await syncManager.syncData();
        final syncedModels = await localDataSource.getCustomers();
        return Right(syncedModels.map((m) => m.toEntity()).toList());
      }
      
      // Trigger background sync but don't wait for it
      syncManager.syncData();
      return Right(localModels.map((m) => m.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Customer>> addCustomer(Customer customer) async {
    try {
      final model = CustomerModel.fromEntity(customer);
      final localResult = await localDataSource.addCustomer(model);
      
      // Trigger sync in background
      syncManager.syncData();
      
      return Right(localResult.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Customer>> updateCustomer(Customer customer) async {
    try {
      final model = CustomerModel.fromEntity(customer);
      final localResult = await localDataSource.updateCustomer(model);
      
      // Trigger sync in background
      syncManager.syncData();
      
      return Right(localResult.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCustomer(String id) async {
    try {
      await localDataSource.deleteCustomer(id);
      
      if (planService.currentPlan == AppPlan.premium) {
        try {
          await remoteDataSource.deleteCustomer(id);
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
  Future<Either<Failure, Customer?>> getCustomerById(String id) async {
    try {
      final model = await localDataSource.getCustomerById(id);
      return Right(model?.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
