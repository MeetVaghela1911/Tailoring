import 'package:equatable/equatable.dart';

class OrderPriorityModel extends Equatable {
  final int id;
  final String name;
  final String? colorHex;
  final int displayOrder;
  final bool isActive;

  const OrderPriorityModel({
    required this.id,
    required this.name,
    this.colorHex,
    this.displayOrder = 0,
    this.isActive = true,
  });

  factory OrderPriorityModel.fromJson(Map<String, dynamic> json) {
    return OrderPriorityModel(
      id: (json['id'] as num).toInt(),
      name: (json['name'] as String?) ?? 'Normal',
      colorHex: json['color_hex'] as String?,
      displayOrder: (json['display_order'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color_hex': colorHex,
      'display_order': displayOrder,
      'is_active': isActive,
    };
  }

  @override
  List<Object?> get props => [id, name, colorHex, displayOrder, isActive];
}
