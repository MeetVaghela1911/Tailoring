import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/template.dart';
import '../../domain/repositories/template_repository.dart';
import '../datasources/template_remote_data_source.dart';
import '../datasources/template_local_data_source.dart';
import '../../../../core/services/plan_service.dart';
import '../../../sync/domain/services/sync_manager.dart';
import '../models/template_model.dart';

class TemplateRepositoryImpl implements TemplateRepository {
  final TemplateRemoteDataSource remoteDataSource;
  final TemplateLocalDataSource localDataSource;
  final PlanService planService;
  final SyncManager syncManager;

  TemplateRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.planService,
    required this.syncManager,
  });

  @override
  Future<Either<Failure, List<Template>>> getTemplates() async {
    try {
      final localModels = await localDataSource.getTemplates();
      if (localModels.isEmpty && planService.currentPlan == AppPlan.premium) {
        await syncManager.syncData();
        final syncedModels = await localDataSource.getTemplates();
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
  Future<Either<Failure, Template>> addTemplate(Template template) async {
    try {
      final model = TemplateModel.fromEntity(template);
      final localResult = await localDataSource.addTemplate(model);
      syncManager.syncData();
      return Right(localResult.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Template>> updateTemplate(Template template) async {
    try {
      final model = TemplateModel.fromEntity(template);
      final localResult = await localDataSource.updateTemplate(model);
      syncManager.syncData();
      return Right(localResult.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTemplate(String id) async {
    try {
      await localDataSource.deleteTemplate(id);
      if (planService.currentPlan == AppPlan.premium) {
        try {
          await remoteDataSource.deleteTemplate(id);
        } catch (_) {}
      }
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
