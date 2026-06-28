import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../theme/common_methods.dart';

class CustomDropdownButton2<T> extends StatefulWidget {
  const CustomDropdownButton2({
    super.key,
    required this.hint,
    required this.value,
    required this.dropdownItems,
    required this.onChanged,
    this.selectedItemBuilder,
    this.hintAlignment,
    this.valueAlignment,
    this.buttonHeight,
    this.buttonWidth,
    this.buttonPadding,
    this.buttonDecoration,
    this.buttonElevation,
    this.icon,
    this.iconSize,
    this.iconEnabledColor,
    this.iconDisabledColor,
    this.itemHeight,
    this.itemPadding,
    this.dropdownHeight,
    this.dropdownWidth,
    this.dropdownPadding,
    this.dropdownDecoration,
    this.dropdownElevation,
    this.scrollbarRadius,
    this.scrollbarThickness,
    this.scrollbarAlwaysShow,
    this.offset = Offset.zero,
  });

  final String hint;
  final T? value;
  final List<T> dropdownItems;
  final ValueChanged<T?>? onChanged;
  final DropdownButtonBuilder? selectedItemBuilder;
  final Alignment? hintAlignment;
  final Alignment? valueAlignment;
  final double? buttonHeight, buttonWidth;
  final EdgeInsetsGeometry? buttonPadding;
  final BoxDecoration? buttonDecoration;
  final int? buttonElevation;
  final Widget? icon;
  final double? iconSize;
  final Color? iconEnabledColor;
  final Color? iconDisabledColor;
  final double? itemHeight;
  final EdgeInsetsGeometry? itemPadding;
  final double? dropdownHeight, dropdownWidth;
  final EdgeInsetsGeometry? dropdownPadding;
  final BoxDecoration? dropdownDecoration;
  final int? dropdownElevation;
  final Radius? scrollbarRadius;
  final double? scrollbarThickness;
  final bool? scrollbarAlwaysShow;
  final Offset offset;

  @override
  State<CustomDropdownButton2<T>> createState() =>
      _CustomDropdownButton2State<T>();
}

class _CustomDropdownButton2State<T> extends State<CustomDropdownButton2<T>> {
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    final c = getThemeBaseColors(context);
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return DropdownButtonHideUnderline(
      child: DropdownButton2<T>(
        isExpanded: true,
        onMenuStateChange: (isOpen) {
          setState(() {
            _isOpen = isOpen;
          });
        },
        hint: Container(
          alignment: widget.hintAlignment,
          child: Text(
            widget.hint,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: GoogleFonts.poppins(fontSize: 14, color: c.gray),
          ),
        ),
        value: widget.value,
        items: widget.dropdownItems.map((T item) {
          bool isSelected = item == widget.value;
          return DropdownMenuItem<T>(
            value: item,
            child: Container(
              alignment: widget.valueAlignment,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                item.toString(),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: isSelected ? c.colorPrimary : c.textDark,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        }).toList(),
        onChanged: widget.onChanged,
        selectedItemBuilder: widget.selectedItemBuilder,
        buttonStyleData: ButtonStyleData(
          height: widget.buttonHeight ?? 56,
          width: widget.buttonWidth ?? double.infinity,
          padding:
              widget.buttonPadding ??
              const EdgeInsets.symmetric(horizontal: 14),
          decoration:
              widget.buttonDecoration ??
              BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isOpen
                      ? c.colorPrimary
                      : c.divider.withValues(alpha: 0.5),
                  width: _isOpen ? 2 : 1,
                ),
                color: isDark ? c.cardDark : c.white,
              ),
          elevation: widget.buttonElevation ?? 0,
        ),
        iconStyleData: IconStyleData(
          icon:
              widget.icon ??
              Icon(
                _isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: _isOpen ? c.colorPrimary : c.gray,
              ),
          iconSize: widget.iconSize ?? 24,
          iconEnabledColor: widget.iconEnabledColor ?? c.gray,
          iconDisabledColor: widget.iconDisabledColor ?? c.gray,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: widget.dropdownHeight ?? 240,
          width: widget.dropdownWidth,
          padding: widget.dropdownPadding,
          decoration:
              widget.dropdownDecoration ??
              BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: isDark ? c.cardDark : c.white,
              ),
          elevation: widget.dropdownElevation ?? 8,
          offset: widget.offset,
          scrollbarTheme: ScrollbarThemeData(
            radius: widget.scrollbarRadius ?? const Radius.circular(40),
            thickness: widget.scrollbarThickness != null
                ? WidgetStateProperty.all<double>(widget.scrollbarThickness!)
                : null,
            thumbVisibility: widget.scrollbarAlwaysShow != null
                ? WidgetStateProperty.all<bool>(widget.scrollbarAlwaysShow!)
                : null,
          ),
        ),
        menuItemStyleData: MenuItemStyleData(
          height: widget.itemHeight ?? 48,
          padding: EdgeInsets.zero, // Padding handled inside item container
        ),
      ),
    );
  }
}
