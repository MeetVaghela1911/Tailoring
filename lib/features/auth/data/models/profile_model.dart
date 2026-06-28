import 'package:equatable/equatable.dart';

class ProfileModel extends Equatable {
  final String id;
  final String fullName;
  final String? phone;
  final String? role;
  final String email;
  final DateTime? updatedAt;
  final int appOpenCount;
  final DateTime? lastOpenedAt;
  final String plan;

  const ProfileModel({
    required this.id,
    required this.fullName,
    this.phone,
    this.role,
    required this.email,
    this.updatedAt,
    this.appOpenCount = 0,
    this.lastOpenedAt,
    this.plan = 'free',
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      phone: json['phone'] as String?,
      role: json['role'] as String?,
      email: json['email'] as String,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
      appOpenCount: json['app_open_count'] as int? ?? 0,
      lastOpenedAt: json['last_opened_at'] != null ? DateTime.parse(json['last_opened_at'] as String) : null,
      plan: json['plan'] as String? ?? 'free',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'phone': phone,
      'role': role,
      'email': email,
      'app_open_count': appOpenCount,
      'last_opened_at': lastOpenedAt?.toIso8601String(),
      'plan': plan,
    };
  }

  @override
  List<Object?> get props => [id, fullName, phone, role, email, updatedAt, appOpenCount, lastOpenedAt, plan];
}
