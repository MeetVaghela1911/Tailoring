import '../../domain/entities/template.dart';

class TemplateModel extends Template {
  const TemplateModel({
    required super.id,
    super.shopId,
    required super.name,
    required super.category,
    required super.iconCodePoint,
    super.iconFontFamily,
    required super.fields,
    required super.basePrice,
  });

  factory TemplateModel.fromJson(Map<String, dynamic> json) {
    return TemplateModel(
      id: json['id'] as String,
      shopId: json['shop_id'] as String?,
      name: json['name'] as String,
      category: json['category'] as String,
      iconCodePoint: json['icon_code_point'] as int,
      iconFontFamily: json['icon_font_family'] as String?,
      fields: List<String>.from(json['fields'] as List),
      basePrice: (json['base_price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      if (shopId != null && shopId!.isNotEmpty) 'shop_id': shopId,
      'name': name,
      'category': category,
      'icon_code_point': iconCodePoint,
      'icon_font_family': iconFontFamily,
      'fields': fields,
      'base_price': basePrice,
    };
  }

  Template toEntity() {
    return Template(
      id: id,
      shopId: shopId,
      name: name,
      category: category,
      iconCodePoint: iconCodePoint,
      iconFontFamily: iconFontFamily,
      fields: fields,
      basePrice: basePrice,
    );
  }

  factory TemplateModel.fromEntity(Template entity) {
    return TemplateModel(
      id: entity.id,
      shopId: entity.shopId,
      name: entity.name,
      category: entity.category,
      iconCodePoint: entity.iconCodePoint,
      iconFontFamily: entity.iconFontFamily,
      fields: entity.fields,
      basePrice: entity.basePrice,
    );
  }
}
