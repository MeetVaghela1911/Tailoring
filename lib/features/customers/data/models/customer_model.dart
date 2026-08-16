import '../../domain/entities/customer.dart';

class CustomerModel extends Customer {
  const CustomerModel({
    required super.id,
    super.shopId,
    required super.name,
    required super.phoneNumber,
    super.email,
    super.address,
    super.notes,
    required super.createdAt,
    super.colorHex,
    super.profileImageUrl,
    super.isDeleted = false,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'] as String,
      shopId: json['shop_id'] as String?,
      name: json['name'] as String,
      phoneNumber: json['phone_number'] as String,
      email: json['email'] as String?,
      address: json['address'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      colorHex: json['color'] as String?,
      profileImageUrl: json['profile_image_url'] as String?,
      isDeleted: json['is_deleted'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      if (shopId != null && shopId!.isNotEmpty) 'shop_id': shopId,
      'name': name,
      'phone_number': phoneNumber,
      'email': email,
      'address': address,
      'notes': notes,
      'color': colorHex,
      'profile_image_url': profileImageUrl,
      'created_at': createdAt.toIso8601String(),
      'is_deleted': isDeleted,
    };
  }

  Customer toEntity() {
    return Customer(
      id: id,
      shopId: shopId,
      name: name,
      phoneNumber: phoneNumber,
      email: email,
      address: address,
      notes: notes,
      createdAt: createdAt,
      colorHex: colorHex,
      profileImageUrl: profileImageUrl,
      isDeleted: isDeleted,
    );
  }

  factory CustomerModel.fromEntity(Customer customer) {
    return CustomerModel(
      id: customer.id,
      shopId: customer.shopId,
      name: customer.name,
      phoneNumber: customer.phoneNumber,
      email: customer.email,
      address: customer.address,
      notes: customer.notes,
      createdAt: customer.createdAt,
      colorHex: customer.colorHex,
      profileImageUrl: customer.profileImageUrl,
      isDeleted: customer.isDeleted,
    );
  }
}
