import 'package:equatable/equatable.dart';

class Template extends Equatable {
  final String id;
  final String? shopId;
  final String name;
  final String category;
  final int iconCodePoint;
  final String? iconFontFamily;
  final List<String> fields;
  final double basePrice;

  const Template({
    required this.id,
    this.shopId,
    required this.name,
    required this.category,
    required this.iconCodePoint,
    this.iconFontFamily,
    required this.fields,
    this.basePrice = 0.0,
  });

  @override
  List<Object?> get props => [
    id,
    shopId,
    name,
    category,
    iconCodePoint,
    iconFontFamily,
    fields,
    basePrice,
  ];

  Template copyWith({
    String? id,
    String? shopId,
    String? name,
    String? category,
    int? iconCodePoint,
    String? iconFontFamily,
    List<String>? fields,
    double? basePrice,
  }) {
    return Template(
      id: id ?? this.id,
      shopId: shopId ?? this.shopId,
      name: name ?? this.name,
      category: category ?? this.category,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      iconFontFamily: iconFontFamily ?? this.iconFontFamily,
      fields: fields ?? this.fields,
      basePrice: basePrice ?? this.basePrice,
    );
  }
}
