import 'package:flutter/material.dart';

class AppColors {
  // ------------------ Light Theme ------------------
  static AppColorScheme light = AppColorScheme(
    // Primary Colors - Sky Blue & Teal palette
    colorPrimary: const Color(0xFF2694B8), // Teal from mockup
    colorSecond: const Color(0xFF4FA8C5), // Slightly lighter teal
    colorAccent: const Color(0xFFA8D8E9), // Sky Blue gradient top
    background: const Color(0xFFF0F4F7), // Very light gray/blue surface
    colorPrimaryDark: const Color(0xFF1E708A), // Deep teal
    colorPrimaryLight: const Color(0xFFD1E9F4), // Pastel blue icon bg

    // Other Colors
    divider: const Color(0xFFE0E6EB),
    textIcon: const Color(0xFF000000),
    green: const Color(0xFF4CAF50),
    red: const Color(0xFFF44336),
    colortur: const Color(0xFFFFFFFF),
    semiTransparentBlack: const Color(0x80000000),
    gray: const Color(0xFF708090),
    grayLight: const Color(0xFFF5F5F5),
    bottomNavigation: const Color(0xFFFFFFFF),
    searchBg: const Color(0xFFFFFFFF),

    // Splash & Common
    splashbg: const Color(0xFF2694B8),
    white: const Color(0xFFFFFFFF),
    black: const Color(0xFF000000),
    textLight: const Color(0xFFFFFFFF),
    textDark: const Color(0xFF0A1F2D), // Deep navy text
    textGray: const Color(0xFF64748B),

    // Additional
    whiteTrans: const Color(0xA6FFFFFF),
    inputSummary: const Color(0xFFF1F5F9),
    btnColorBg: const Color(0xFF2694B8),
    blurAppBar: const Color(0x30A8D8E9),
    backGroundLayer1: Colors.white.withValues(alpha: 0.9),
    cemiTransparent: Colors.white.withValues(alpha: 0.1),

    // Stitch-specific
    cardDark: const Color(0xFFFFFFFF), // In light mode cards are white
    cardGlass: const Color(0x33FFFFFF),
    gradientStart: const Color(0xFFA8D8E9), // Sky Blue
    gradientEnd: const Color(0xFFFFFFFF),
    ownerPurple: const Color(0xFF2694B8), 
    workerPink: const Color(0xFFEC4899),
  );

  // ------------------ Dark Theme ------------------
  static AppColorScheme dark = AppColorScheme(
    // Primary Colors
    colorPrimary: const Color(0xFF38BDF8), // Bright sky blue for dark mode
    colorSecond: const Color(0xFF0EA5E9),
    colorAccent: const Color(0xFF0284C7),
    background: const Color(0xFF0F172A), // Deep navy background
    colorPrimaryDark: const Color(0xFF0C4A6E),
    colorPrimaryLight: const Color(0xFF1E293B),

    // Other Colors
    divider: const Color(0xFF1E293B),
    textIcon: const Color(0xFFFFFFFF),
    green: const Color(0xFF10B981),
    red: const Color(0xFFEF4444),
    colortur: const Color(0xFF1E293B),
    semiTransparentBlack: const Color(0x99000000),
    gray: const Color(0xFF94A3B8),
    grayLight: const Color(0xFF1E293B),
    bottomNavigation: const Color(0xFF1E293B),
    searchBg: const Color(0xFF1E293B),

    // Splash & Common
    splashbg: const Color(0xFF0F172A),
    white: const Color(0xFFFFFFFF),
    black: const Color(0xFF000000),
    textLight: const Color(0xFFFFFFFF),
    textDark: const Color(0xFFF1F5F9),
    textGray: const Color(0xFF94A3B8),

    // Additional
    whiteTrans: const Color(0x80FFFFFF),
    inputSummary: const Color(0xFF1E293B),
    btnColorBg: const Color(0xFF38BDF8),
    blurAppBar: const Color(0x600F172A),
    backGroundLayer1: Colors.grey.withValues(alpha: 0.1),
    cemiTransparent: Colors.black.withValues(alpha: 0.1),

    // Stitch-specific
    cardDark: const Color(0xFF1E293B),
    cardGlass: const Color(0x33FFFFFF),
    gradientStart: const Color(0xFF0F172A),
    gradientEnd: const Color(0xFF1E293B),
    ownerPurple: const Color(0xFF38BDF8),
    workerPink: const Color(0xFFF472B6),
  );
}

/// Color scheme holding a set of colors
class AppColorScheme {
  final Color colorPrimary;
  final Color colorSecond;
  final Color colorAccent;
  final Color background;
  final Color colorPrimaryDark;
  final Color colorPrimaryLight;

  final Color divider;
  final Color textIcon;
  final Color green;
  final Color red;
  final Color colortur;
  final Color semiTransparentBlack;
  final Color gray;
  final Color grayLight;
  final Color bottomNavigation;
  final Color searchBg;

  final Color splashbg;
  final Color white;
  final Color black;
  final Color textLight;
  final Color textDark;
  final Color textGray;

  final Color whiteTrans;
  final Color inputSummary;
  final Color btnColorBg;
  final Color blurAppBar;
  final Color backGroundLayer1;
  final Color cemiTransparent;

  // Stitch-specific
  final Color cardDark;
  final Color cardGlass;
  final Color gradientStart;
  final Color gradientEnd;
  final Color ownerPurple;
  final Color workerPink;

  const AppColorScheme({
    required this.colorPrimary,
    required this.colorSecond,
    required this.colorAccent,
    required this.background,
    required this.colorPrimaryDark,
    required this.colorPrimaryLight,
    required this.divider,
    required this.textIcon,
    required this.green,
    required this.red,
    required this.colortur,
    required this.semiTransparentBlack,
    required this.gray,
    required this.grayLight,
    required this.bottomNavigation,
    required this.searchBg,
    required this.splashbg,
    required this.white,
    required this.black,
    required this.textLight,
    required this.textDark,
    required this.textGray,
    required this.whiteTrans,
    required this.inputSummary,
    required this.btnColorBg,
    required this.blurAppBar,
    required this.backGroundLayer1,
    required this.cemiTransparent,
    required this.cardDark,
    required this.cardGlass,
    required this.gradientStart,
    required this.gradientEnd,
    required this.ownerPurple,
    required this.workerPink,
  });
}
