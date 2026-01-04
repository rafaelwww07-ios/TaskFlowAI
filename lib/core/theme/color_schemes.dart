import 'package:flutter/material.dart';

/// Color scheme types
enum ColorSchemeType {
  professional,
  creative,
  calm,
}

/// Color schemes for the app
class ColorSchemes {
  ColorSchemes._();

  /// Professional color scheme (blue/gray)
  static ColorScheme get professional => ColorScheme.fromSeed(
        seedColor: const Color(0xFF6366F1),
        brightness: Brightness.light,
      );

  /// Creative color scheme (purple/pink)
  static ColorScheme get creative => ColorScheme.fromSeed(
        seedColor: const Color(0xFF8B5CF6),
        brightness: Brightness.light,
      );

  /// Calm color scheme (green/teal)
  static ColorScheme get calm => ColorScheme.fromSeed(
        seedColor: const Color(0xFF10B981),
        brightness: Brightness.light,
      );

  /// Get color scheme by type
  static ColorScheme getScheme(ColorSchemeType type) {
    switch (type) {
      case ColorSchemeType.professional:
        return professional;
      case ColorSchemeType.creative:
        return creative;
      case ColorSchemeType.calm:
        return calm;
    }
  }

  /// Get color scheme by type and brightness
  static ColorScheme getColorScheme(ColorSchemeType type, Brightness brightness) {
    Color seedColor;
    switch (type) {
      case ColorSchemeType.professional:
        seedColor = const Color(0xFF6366F1);
        break;
      case ColorSchemeType.creative:
        seedColor = const Color(0xFF8B5CF6);
        break;
      case ColorSchemeType.calm:
        seedColor = const Color(0xFF10B981);
        break;
    }
    return ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );
  }
}

