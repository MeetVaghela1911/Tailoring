import 'package:flutter/material.dart';

class CustomerModel {
  final String id;
  final String name;
  final String phoneNumber;
  final String? email;
  final String? address;
  final String? notes;
  final DateTime createdAt;
  final Color? color;

  CustomerModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.email,
    this.address,
    this.notes,
    required this.createdAt,
    this.color,
  });

  String get initials {
    if (name.isEmpty) return '??';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  CustomerModel copyWith({
    String? name,
    String? phoneNumber,
    String? email,
    String? address,
    String? notes,
    Color? color,
  }) {
    return CustomerModel(
      id: id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      createdAt: createdAt,
      color: color ?? this.color,
    );
  }
}
