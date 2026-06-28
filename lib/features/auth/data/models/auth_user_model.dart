import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import '../../domain/entities/auth_user.dart';
import 'profile_model.dart';
import 'shop_model.dart';

class AuthUserModel extends AuthUser {
  const AuthUserModel({
    required super.id,
    required super.email,
    super.name,
    super.photoUrl,
    super.profile,
    super.shop,
  });

  factory AuthUserModel.fromSupabase(sb.User user, {ProfileModel? profile, ShopModel? shop}) {
    return AuthUserModel(
      id: user.id,
      email: user.email ?? '',
      name: user.userMetadata?['full_name'] as String?,
      photoUrl: user.userMetadata?['avatar_url'] as String?,
      profile: profile,
      shop: shop,
    );
  }

  AuthUser toEntity() {
    return AuthUser(
      id: id,
      email: email,
      name: name,
      photoUrl: photoUrl,
      profile: profile,
      shop: shop,
    );
  }
}
