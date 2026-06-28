import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.light.background,
    primaryColor: AppColors.light.colorPrimary,
    dividerColor: AppColors.light.divider,
    textTheme: GoogleFonts.poppinsTextTheme().apply(
      bodyColor: AppColors.light.textDark,
      displayColor: AppColors.light.textDark,
    ),
    colorScheme: ColorScheme.light(
      primary: AppColors.light.colorPrimary,
      secondary: AppColors.light.colorSecond,
      surface: AppColors.light.background,
    ),
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.dark.background,
    primaryColor: AppColors.dark.colorPrimary,
    dividerColor: AppColors.dark.divider,
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme).apply(
      bodyColor: AppColors.dark.textLight,
      displayColor: AppColors.dark.textLight,
    ),
    colorScheme: ColorScheme.dark(
      primary: AppColors.dark.colorPrimary,
      secondary: AppColors.dark.colorSecond,
      surface: AppColors.dark.background,
    ),
  );
}
