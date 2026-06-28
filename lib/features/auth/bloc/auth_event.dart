import 'package:equatable/equatable.dart';
import '../data/models/profile_model.dart';
import '../data/models/shop_model.dart';
import '../domain/entities/auth_user.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class SignUpRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;

  const SignUpRequested({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [name, email, password];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class GoogleSignInRequested extends AuthEvent {
  const GoogleSignInRequested();
}

class SignOutRequested extends AuthEvent {
  const SignOutRequested();
}

class AuthStatusChanged extends AuthEvent {
  final AuthUser? user;

  const AuthStatusChanged(this.user);

  @override
  List<Object?> get props => [user];
}

class ProfileUpdated extends AuthEvent {
  final ProfileModel profile;

  const ProfileUpdated(this.profile);

  @override
  List<Object> get props => [profile];
}

class ShopUpdated extends AuthEvent {
  final ShopModel shop;

  const ShopUpdated(this.shop);

  @override
  List<Object> get props => [shop];
}

/// Fired by screens that need fresh profile+shop data from Supabase.
class RefreshUser extends AuthEvent {
  const RefreshUser();
}
