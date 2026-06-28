import 'package:equatable/equatable.dart';

class Customer extends Equatable {
  final String id;
  final String name;
  final String phoneNumber;
  final String? email;
  final String? address;
  final String? notes;
  final DateTime createdAt;
  final String? colorHex;
  final String? profileImageUrl;

  const Customer({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.email,
    this.address,
    this.notes,
    required this.createdAt,
    this.colorHex,
    this.profileImageUrl,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    phoneNumber,
    email,
    address,
    notes,
    createdAt,
    colorHex,
    profileImageUrl,
  ];

  Customer copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? email,
    String? address,
    String? notes,
    DateTime? createdAt,
    String? colorHex,
    String? profileImageUrl,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      colorHex: colorHex ?? this.colorHex,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}
