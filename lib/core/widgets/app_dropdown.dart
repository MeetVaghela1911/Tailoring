import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/common_methods.dart';

/// A consistent animated, searchable dropdown used across the entire app.
/// Wraps `CustomDropdown` from `animated_custom_dropdown`.
///
/// Usage:
/// ```dart
/// AppDropdown<String>(
///   label: 'Role',
///   items: ['Owner', 'Tailor', 'Manager'],
///   initialItem: _selectedRole,
///   onChanged: (v) => setState(() => _selectedRole = v),
/// )
/// ```
class AppDropdown<T> extends StatelessWidget {
  final String label;
  final String? hint;
  final List<T> items;
  final T? initialItem;
  final ValueChanged<T?>? onChanged;
  final bool enabled;
  final String Function(T)? itemLabelBuilder;

  const AppDropdown({
    super.key,
    required this.label,
    required this.items,
    this.hint,
    this.initialItem,
    this.onChanged,
    this.enabled = true,
    this.itemLabelBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final c = getThemeBaseColors(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final decoration = CustomDropdownDecoration(
      closedFillColor: isDark ? c.cardDark : Colors.white,
      expandedFillColor: isDark ? c.cardDark : Colors.white,
      closedBorderRadius: BorderRadius.circular(14),
      expandedBorderRadius: BorderRadius.circular(14),
      closedBorder: Border.all(color: c.divider.withValues(alpha: 0.5)),
      expandedBorder: Border.all(color: c.colorPrimary.withValues(alpha: 0.4)),
      closedSuffixIcon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: c.colorPrimary,
        size: 22,
      ),
      expandedSuffixIcon: Icon(
        Icons.keyboard_arrow_up_rounded,
        color: c.colorPrimary,
        size: 22,
      ),
      searchFieldDecoration: SearchFieldDecoration(
        fillColor: isDark ? c.background.withValues(alpha: 0.4) : Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: c.divider.withValues(alpha: 0.4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: c.colorPrimary, width: 1.5),
        ),
        textStyle: GoogleFonts.poppins(fontSize: 13, color: c.textDark),
        hintStyle: GoogleFonts.poppins(fontSize: 13, color: c.gray),
        prefixIcon: Icon(Icons.search, color: c.gray, size: 18),
      ),
      headerStyle: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: c.textDark,
      ),
      listItemStyle: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: c.textDark,
      ),
      listItemDecoration: ListItemDecoration(
        selectedColor: c.colorPrimary.withValues(alpha: 0.08),
        highlightColor: c.colorPrimary.withValues(alpha: 0.04),
        selectedIconColor: c.colorPrimary,
        splashColor: c.colorPrimary.withValues(alpha: 0.06),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: c.gray,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
        ],
        IgnorePointer(
          ignoring: !enabled,
          child: Opacity(
            opacity: enabled ? 1.0 : 0.5,
            child: CustomDropdown<T>.search(
              items: items,
              initialItem: initialItem,
              decoration: decoration,
              hintText: hint ?? 'Select $label',
              headerBuilder: itemLabelBuilder != null
                  ? (context, item, enabled) => Text(
                        itemLabelBuilder!(item),
                        style: decoration.headerStyle,
                      )
                  : null,
              listItemBuilder: itemLabelBuilder != null
                  ? (context, item, isSelected, onItemSelect) => Text(
                        itemLabelBuilder!(item),
                        style: decoration.listItemStyle,
                      )
                  : null,
              hintBuilder: (context, hint, enabled) => Text(
                hint,
                style: GoogleFonts.poppins(fontSize: 14, color: c.gray),
              ),
              onChanged: enabled ? (v) => onChanged?.call(v) : null,
            ),
          ),
        ),
      ],
    );
  }
}
