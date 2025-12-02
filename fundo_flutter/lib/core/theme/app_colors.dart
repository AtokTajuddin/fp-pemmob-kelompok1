import 'package:flutter/material.dart';

class AppColors {
  // ===========================================================================
  // 🟢 PRIMARY BRAND (Emerald)
  // ===========================================================================
  static const Color primary = Color(0xFF10B981); // Emerald 500
  static const Color primaryDark = Color(0xFF059669); // Emerald 700
  static const Color primaryLight = Color(0xFFD1FAE5); // Emerald 100

  // ===========================================================================
  // 🔴 STATUS COLORS
  // ===========================================================================
  static const Color error = Color(0xFFEF4444); // Red 500
  static const Color errorLight = Color(0xFFFEE2E2); // Red 100

  static const Color warning = Color(0xFFF59E0B); // Amber 500
  static const Color warningLight = Color(0xFFFEF3C7); // Amber 100

  static const Color info = Color(0xFF3B82F6); // Blue 500
  static const Color infoLight = Color(0xFFDBEAFE); // Blue 100

  static const Color success = Color(0xFF10B981);

  // ===========================================================================
  // ⚪️ NEUTRAL / GREYSCALE
  // ===========================================================================
  static const Color grey50 = Color(0xFFF9FAFB);
  static const Color grey100 = Color(0xFFF3F4F6);
  static const Color grey200 = Color(0xFFE5E7EB);
  static const Color grey300 = Color(0xFFD1D5DB);
  static const Color grey400 = Color(0xFF9CA3AF);
  static const Color grey500 = Color(0xFF6B7280);
  static const Color grey600 = Color(0xFF4B5563);
  static const Color grey700 = Color(0xFF374151);
  static const Color grey800 = Color(0xFF1F2937);
  static const Color grey900 = Color(0xFF111827);

  // ===========================================================================
  // 🎨 CATEGORY COLORS
  // ===========================================================================
  static const Color catFood = Color(0xFFF59E0B);
  static const Color catTransport = Color(0xFF3B82F6);
  static const Color catEntertainment = Color(0xFF8B5CF6);
  static const Color catHealth = Color(0xFFEC4899);
  static const Color catBills = Color(0xFFEF4444);
  static const Color catShopping = Color(0xFF06B6D4);
  static const Color catEducation = Color(0xFF10B981);
  static const Color catOther = Color(0xFF6B7280);

  // ===========================================================================
  // 🔗 MAPPINGS (The Bridge Fix)
  // ===========================================================================

  // Fixes "secondary not found" error by mapping it to our Blue Info color
  static const Color secondary = info;

  // Theme Mappings
  static const Color backgroundLight = grey50;
  static const Color backgroundDark = grey900;
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = grey800;

  static const Color textPrimaryLight = grey900;
  static const Color textSecondaryLight = grey500;
  static const Color textPrimaryDark = grey50;
  static const Color textSecondaryDark = grey400;

  static const Color borderLight = grey200;
  static const Color borderDark = grey700;
}
