import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/profile_model.dart';
import '../../data/models/shop_model.dart';
import '../entities/auth_user.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthUser>> signUp({
    required String email,
    required String password,
    required String name,
  });

  Future<Either<Failure, AuthUser>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, AuthUser?>> getCurrentUser();

  Stream<AuthUser?> get onAuthStateChanged;

  Future<Either<Failure, void>> updateProfile(ProfileModel profile);

  Future<Either<Failure, void>> updateShop(ShopModel shop);

  Future<Either<Failure, ProfileModel?>> getProfile(String userId);

  Future<Either<Failure, ShopModel?>> getShop(String userId);
  Future<Either<Failure, void>> trackAppOpen(String userId);
}
