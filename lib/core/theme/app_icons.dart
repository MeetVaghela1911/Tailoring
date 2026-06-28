import 'package:flutter/material.dart';

/// Central repository for application icons.
/// This helps resolve tree-shaking issues by ensuring all [IconData]
/// instances used dynamically are available as constants.
class AppIcons {
  static const List<IconData> presetIcons = [
    Icons.checkroom,
    Icons.checkroom_outlined,
    Icons.auto_awesome,
    Icons.style,
    Icons.style_outlined,
    Icons.straighten,
    Icons.straighten_outlined,
    Icons.dry_cleaning,
    Icons.dry_cleaning_outlined,
    Icons.cut,
    Icons.content_cut,
    Icons.favorite,
    Icons.star,
    Icons.local_laundry_service,
    Icons.shopping_bag,
    Icons.shopping_bag_outlined,
    Icons.color_lens,
    Icons.design_services,
    Icons.design_services_outlined,
    Icons.dashboard_customize,
    Icons.layers,
    Icons.view_in_ar,
    Icons.gesture,
    Icons.gesture_outlined,
    Icons.architecture,
    Icons.architecture_outlined,
    Icons.category,
    Icons.add_shopping_cart,
    Icons.workspaces,
    Icons.format_shapes,
    Icons.crop_free,
    Icons.pattern,
    Icons.person_outline,
    Icons.group_outlined,
    Icons.theater_comedy_outlined,
    Icons.accessibility_new,
    Icons.person_2,
    Icons.woman,
  ];

  /// Returns a constant [IconData] for the given [codePoint].
  /// If the code point is not found in the preset list, it returns a default icon.
  static IconData getIcon(int codePoint, {String? fontFamily}) {
    try {
      return presetIcons.firstWhere(
        (icon) => icon.codePoint == codePoint,
        orElse: () => Icons.help_outline,
      );
    } catch (_) {
      return Icons.help_outline;
    }
  }
}
