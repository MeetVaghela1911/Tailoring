import 'package:equatable/equatable.dart';

class ShopModel extends Equatable {
  final String id;
  final String ownerId;
  final String name;
  final String ownerName;
  final String address;
  final int capacity;
  final List<int> workingDays;
  final String openTime;
  final String closeTime;
  final String? gstin;
  final DateTime? updatedAt;

  const ShopModel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.ownerName,
    required this.address,
    required this.capacity,
    required this.workingDays,
    required this.openTime,
    required this.closeTime,
    this.gstin,
    this.updatedAt,
  });

  factory ShopModel.fromJson(Map<String, dynamic> json) {
    return ShopModel(
      id: json['id'] as String,
      ownerId: json['owner_id'] as String,
      name: json['name'] as String,
      ownerName: json['owner_name'] as String,
      address: json['address'] as String,
      capacity: (json['capacity'] as num).toInt(),
      workingDays: (json['working_days'] as List<dynamic>).map((e) => (e as num).toInt()).toList(),
      openTime: json['open_time'] as String,
      closeTime: json['close_time'] as String,
      gstin: json['gstin'] as String?,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'owner_id': ownerId,
      'name': name,
      'owner_name': ownerName,
      'address': address,
      'capacity': capacity,
      'working_days': workingDays,
      'open_time': openTime,
      'close_time': closeTime,
      'gstin': gstin,
    };
    if (id.isNotEmpty) {
      json['id'] = id;
    }
    return json;
  }

  @override
  List<Object?> get props => [
        id,
        ownerId,
        name,
        ownerName,
        address,
        capacity,
        workingDays,
        openTime,
        closeTime,
        gstin,
        updatedAt,
      ];
}
