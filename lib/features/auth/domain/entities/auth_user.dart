import 'package:equatable/equatable.dart';

import '../../data/models/profile_model.dart';
import '../../data/models/shop_model.dart';

class AuthUser extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? photoUrl;
  final ProfileModel? profile;
  final ShopModel? shop;

  const AuthUser({
    required this.id,
    required this.email,
    this.name,
    this.photoUrl,
    this.profile,
    this.shop,
  });

  @override
  List<Object?> get props => [id, email, name, photoUrl, profile, shop];
}
