import 'package:flutter/material.dart';

import '../shared/colors.dart';

/// Design tokens for Muslim-Life (teal brand, Arabic RTL).
abstract final class AppTokens {
  static const Color brand = Color(0xff0fafaf);
  static const Color brandDark = Color(0xff0a8a8a);
  static const Color brandLight = Color(0xff5fd4d4);
  static const Color surface = Color(0xFFFAFBFC);
  static const Color surfaceVariant = Color(0xFFF3F4F6);
  static const Color onSurface = Color(0xFF1F2937);
  static const Color onSurfaceMuted = Color(0xFF6B7280);
  static const Color error = Color(0xFFB91C1C);

  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 20;

  static const double spaceXs = 4;
  static const double spaceSm = 8;
  static const double spaceMd = 16;
  static const double spaceLg = 24;
  static const double spaceXl = 32;

  static const double elevationCard = 1;

  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [brand, brandDark, Color(0xFF066666)],
  );

  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: brand.withOpacity(0.12),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  /// Legacy alias used across the codebase.
  static Color get mainColor => kMainColor;
}
