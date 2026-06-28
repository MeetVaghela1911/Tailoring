import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Standard SnackBar function to ensure consistent look across the app.
void showAppSnackBar(
  BuildContext context, {
  required String message,
  bool isError = false,
  Duration duration = const Duration(seconds: 3),
  SnackBarAction? action,
}) {
  final colorScheme = Theme.of(context).colorScheme;
  
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
      backgroundColor: isError 
          ? (colorScheme.error == Colors.red ? Colors.red.shade400 : colorScheme.error)
          : colorScheme.primary,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      duration: duration,
      action: action,
    ),
  );
}
