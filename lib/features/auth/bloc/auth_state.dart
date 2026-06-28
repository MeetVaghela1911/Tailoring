import 'package:equatable/equatable.dart';
import '../domain/entities/auth_user.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final AuthUser user;

  const AuthAuthenticated(this.user);

  @override
  List<Object> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  /// The user still logged-in when the error occurred (keeps screens stable).
  final AuthUser? user;

  const AuthError(this.message, {this.user});

  @override
  List<Object?> get props => [message, user];
}

/// Emitted while a profile save is in progress.
class ProfileSaving extends AuthState {
  final AuthUser user;
  const ProfileSaving(this.user);
  @override
  List<Object> get props => [user];
}

/// Emitted while a shop save is in progress.
class ShopSaving extends AuthState {
  final AuthUser user;
  const ShopSaving(this.user);
  @override
  List<Object> get props => [user];
}
