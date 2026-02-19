import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFF0A0A0B);
  static const Color surface = Color(0xFF161618);
  static const Color primary = Color(0xFF00F2FF);
  static const Color secondary = Color(0xFF7000FF);
  static const Color accent = Color(0xFF00F2FF);

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA0A0A0);

  static const Color glassWhite = Color(0x1AFFFFFF);
  static const Color glassStroke = Color(0x33FFFFFF);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
