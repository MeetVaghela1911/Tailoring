import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/common_methods.dart';

/// Reusable action bar with an Edit/Save button and a Delete icon button.
/// Matches the design from order_detail_screen — use everywhere that
/// a detail screen needs Edit + Delete actions.
class AppActionBar extends StatelessWidget {
  final bool isEditing;
  final VoidCallback onEditSaveTap;
  final VoidCallback onDeleteTap;

  /// Label shown when NOT editing.
  final String editLabel;

  /// Label shown when in editing mode (about to save).
  final String saveLabel;

  const AppActionBar({
    super.key,
    required this.isEditing,
    required this.onEditSaveTap,
    required this.onDeleteTap,
    this.editLabel = 'Edit',
    this.saveLabel = 'Save Changes',
  });

  @override
  Widget build(BuildContext context) {
    final c = getThemeBaseColors(context);

    final btnColor = isEditing ? c.green : c.colorPrimary;
    final shadowColor = btnColor.withValues(alpha: 0.3);

    return Row(
      children: [
        // ── Edit / Save button ──────────────────────────────────────────
        Expanded(
          child: GestureDetector(
            onTap: onEditSaveTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: btnColor,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isEditing ? Icons.check : Icons.edit_outlined,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isEditing ? saveLabel : editLabel,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),

        // ── Delete button ───────────────────────────────────────────────
        GestureDetector(
          onTap: onDeleteTap,
          child: Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: c.red.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: c.red.withValues(alpha: 0.25)),
            ),
            child: Icon(Icons.delete_outline, color: c.red, size: 22),
          ),
        ),
      ],
    );
  }
}
