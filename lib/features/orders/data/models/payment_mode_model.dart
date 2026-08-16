import 'package:equatable/equatable.dart';

class PaymentModeModel extends Equatable {
  final int id;
  final String name;
  final bool isActive;

  const PaymentModeModel({
    required this.id,
    required this.name,
    this.isActive = true,
  });

  factory PaymentModeModel.fromJson(Map<String, dynamic> json) {
    return PaymentModeModel(
      id: (json['id'] as num).toInt(),
      name: (json['name'] as String?) ?? 'Cash',
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'is_active': isActive,
    };
  }

  @override
  List<Object?> get props => [id, name, isActive];
}
