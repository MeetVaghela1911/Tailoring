import 'package:flutter/material.dart';
import '../../features/templates/domain/entities/template.dart';

class DefaultTemplates {
  static List<Template> get all => [
    ...mensTemplates,
    ...womensTemplates,
  ];

  static List<Template> mensTemplates = [
    Template(
      id: 'template_shirt',
      name: 'Men\'s Shirt',
      category: 'Men\'s Wear',
      iconCodePoint: Icons.checkroom.codePoint,
      fields: [
        'Length',
        'Shoulder',
        'Chest',
        'Waist',
        'Sleeve Length',
        'Cuff',
        'Collar',
      ],
      basePrice: 500,
    ),
    Template(
      id: 'template_trousers',
      name: 'Trousers/Pants',
      category: 'Men\'s Wear',
      iconCodePoint: Icons.straighten.codePoint,
      fields: [
        'Length',
        'Waist',
        'Hip',
        'Thigh',
        'Knee',
        'Bottom',
        'Inseam',
      ],
      basePrice: 600,
    ),
    Template(
      id: 'template_kurta_men',
      name: 'Men\'s Kurta',
      category: 'Men\'s Wear',
      iconCodePoint: Icons.accessibility_new.codePoint,
      fields: [
        'Length',
        'Shoulder',
        'Chest',
        'Waist',
        'Hip',
        'Sleeve Length',
        'Collar',
      ],
      basePrice: 450,
    ),
    Template(
      id: 'template_suit',
      name: 'Full Suit',
      category: 'Men\'s Wear',
      iconCodePoint: Icons.person_2.codePoint,
      fields: [
        'Jacket Length',
        'Shoulder',
        'Chest',
        'Waist',
        'Sleeve',
        'Pants Length',
        'Pants Waist',
      ],
      basePrice: 2500,
    ),
  ];

  static List<Template> womensTemplates = [
    Template(
      id: 'template_blouse',
      name: 'Blouse',
      category: 'Women\'s Wear',
      iconCodePoint: Icons.woman.codePoint,
      fields: [
        'Length',
        'Chest',
        'Waist',
        'Shoulder',
        'Sleeve Length',
        'Front Neck',
        'Back Neck',
        'Cross Back',
      ],
      basePrice: 400,
    ),
    Template(
      id: 'template_kurti_women',
      name: 'Kurti/Top',
      category: 'Women\'s Wear',
      iconCodePoint: Icons.style.codePoint,
      fields: [
        'Length',
        'Shoulder',
        'Chest',
        'Waist',
        'Hip',
        'Sleeve Length',
        'Armhole',
      ],
      basePrice: 450,
    ),
    Template(
      id: 'template_salwar',
      name: 'Salwar/Plazo',
      category: 'Women\'s Wear',
      iconCodePoint: Icons.layers.codePoint,
      fields: [
        'Length',
        'Waist',
        'Hip',
        'Bottom',
        'Thigh',
      ],
      basePrice: 350,
    ),
    Template(
      id: 'template_gown',
      name: 'Gown/Dress',
      category: 'Women\'s Wear',
      iconCodePoint: Icons.auto_awesome.codePoint,
      fields: [
        'Full Length',
        'Shoulder',
        'Chest',
        'Waist',
        'Hip',
        'Flare',
        'Sleeve Length',
      ],
      basePrice: 1500,
    ),
  ];
}
