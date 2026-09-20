import 'package:flutter/material.dart';

import '../shared/colors.dart';

/// Design tokens for Muslim-Life (Arabic RTL, #0FAFAF minaret accent).
///
/// Visual mix (local DESIGN.md): Quiet Mosque Courtyard ~70%, Open Mushaf ~20%,
/// Teal Minaret accent ~10% — use [minaret] / [brand] sparingly for chrome & CTAs.
abstract final class AppTokens {
  static const Color brand = Color(0xFF0FAFAF);
  static const Color brandDark = Color(0xff0a8a8a);
  static const Color brandLight = Color(0xff5fd4d4);

  /// Courtyard — calm neutral shells (≈70%).
  static const Color courtyard = Color(0xFFFAFBFC);
  static const Color courtyardMuted = Color(0xFFF3F4F6);

  /// Mushaf — reading surfaces (≈20%).
  static const Color mushaf = Color(0xFFFFFBF5);
  static const Color mushafBorder = Color(0xFFE8E4DC);

  static const Color surface = courtyard;
  static const Color surfaceVariant = courtyardMuted;
  static const Color onSurface = Color(0xFF1F2937);
  static const Color onSurfaceMuted = Color(0xFF6B7280);
  static const Color error = Color(0xFFB91C1C);

  /// Minaret accent — app bars, primary buttons, key highlights (≈10%).
  static const Color minaret = brand;

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
          color: brand.withOpacity(0.08),
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
      ];

  /// Legacy alias used across the codebase.
  static Color get mainColor => kMainColor;
}
