import 'package:equatable/equatable.dart';

class Customer extends Equatable {
  final String id;
  final String? shopId;
  final String name;
  final String phoneNumber;
  final String? email;
  final String? address;
  final String? notes;
  final DateTime createdAt;
  final String? colorHex;
  final String? profileImageUrl;
  final bool isDeleted;

  const Customer({
    required this.id,
    this.shopId,
    required this.name,
    required this.phoneNumber,
    this.email,
    this.address,
    this.notes,
    required this.createdAt,
    this.colorHex,
    this.profileImageUrl,
    this.isDeleted = false,
  });

  @override
  List<Object?> get props => [
    id,
    shopId,
    name,
    phoneNumber,
    email,
    address,
    notes,
    createdAt,
    colorHex,
    profileImageUrl,
    isDeleted,
  ];

  Customer copyWith({
    String? id,
    String? shopId,
    String? name,
    String? phoneNumber,
    String? email,
    String? address,
    String? notes,
    DateTime? createdAt,
    String? colorHex,
    String? profileImageUrl,
    bool? isDeleted,
  }) {
    return Customer(
      id: id ?? this.id,
      shopId: shopId ?? this.shopId,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      colorHex: colorHex ?? this.colorHex,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
