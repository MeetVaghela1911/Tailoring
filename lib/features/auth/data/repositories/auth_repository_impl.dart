import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/database/local_database.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/profile_model.dart';
import '../models/shop_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthException, PostgrestException;

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final LocalDatabase localDatabase;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDatabase,
  });

  @override
  Future<Either<Failure, AuthUser>> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // Clear local database before signing up a new user to prevent data leak from leftover/restored database
      await localDatabase.clearAll();
      final userModel = await remoteDataSource.signUp(
        email: email,
        password: password,
        name: name,
      );
      return Right(userModel.toEntity());
    } catch (e) {
      return Left(ServerFailure(_getErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, AuthUser>> login({
    required String email,
    required String password,
  }) async {
    try {
      // Clear local database before logging in a new user to prevent data leak from leftover/restored database
      await localDatabase.clearAll();
      final userModel = await remoteDataSource.login(
        email: email,
        password: password,
      );
      return Right(userModel.toEntity());
    } catch (e) {
      return Left(ServerFailure(_getErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      await localDatabase.clearAll();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(_getErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, AuthUser?>> getCurrentUser() async {
    try {
      final userModel = await remoteDataSource.getCurrentUser();
      return Right(userModel?.toEntity());
    } catch (e) {
      return Left(ServerFailure(_getErrorMessage(e)));
    }
  }

  @override
  Stream<AuthUser?> get onAuthStateChanged {
    return remoteDataSource.onAuthStateChanged.map((userModel) => userModel?.toEntity());
  }

  @override
  Future<Either<Failure, void>> updateProfile(ProfileModel profile) async {
    try {
      await remoteDataSource.updateProfile(profile);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(_getErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, void>> updateShop(ShopModel shop) async {
    try {
      await remoteDataSource.updateShop(shop);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(_getErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, ProfileModel?>> getProfile(String userId) async {
    try {
      final profile = await remoteDataSource.getProfile(userId);
      return Right(profile);
    } catch (e) {
      return Left(ServerFailure(_getErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, ShopModel?>> getShop(String userId) async {
    try {
      final shop = await remoteDataSource.getShop(userId);
      return Right(shop);
    } catch (e) {
      return Left(ServerFailure(_getErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, void>> trackAppOpen(String userId) async {
    try {
      await remoteDataSource.trackAppOpen(userId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(_getErrorMessage(e)));
    }
  }

  String _getErrorMessage(dynamic e) {
    if (e is AuthException) {
      return e.message;
    } else if (e is PostgrestException) {
      return e.message;
    }
    return e.toString();
  }
}
