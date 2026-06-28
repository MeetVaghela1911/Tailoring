import '../../domain/entities/customer.dart';

class CustomerModel extends Customer {
  const CustomerModel({
    required super.id,
    required super.name,
    required super.phoneNumber,
    super.email,
    super.address,
    super.notes,
    required super.createdAt,
    super.colorHex,
    super.profileImageUrl,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'] as String,
      name: json['name'] as String,
      phoneNumber: json['phone_number'] as String,
      email: json['email'] as String?,
      address: json['address'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      colorHex: json['color'] as String?,
      profileImageUrl: json['profile_image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'name': name,
      'phone_number': phoneNumber,
      'email': email,
      'address': address,
      'notes': notes,
      'color': colorHex,
      'profile_image_url': profileImageUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Customer toEntity() {
    return Customer(
      id: id,
      name: name,
      phoneNumber: phoneNumber,
      email: email,
      address: address,
      notes: notes,
      createdAt: createdAt,
      colorHex: colorHex,
      profileImageUrl: profileImageUrl,
    );
  }

  factory CustomerModel.fromEntity(Customer customer) {
    return CustomerModel(
      id: customer.id,
      name: customer.name,
      phoneNumber: customer.phoneNumber,
      email: customer.email,
      address: customer.address,
      notes: customer.notes,
      createdAt: customer.createdAt,
      colorHex: customer.colorHex,
      profileImageUrl: customer.profileImageUrl,
    );
  }
}
