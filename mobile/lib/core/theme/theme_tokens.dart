import 'package:flutter/material.dart';

class ThemeTokens {
  static const seed = Color(0xFF2DD4BF);
  static const secondary = Color(0xFF6366F1);
  static const surface = Color(0xFFF8FAFC);
  static const darkSurface = Color(0xFF0B1020);

  static ColorScheme lightScheme() => ColorScheme.fromSeed(
        seedColor: seed,
        secondary: secondary,
        brightness: Brightness.light,
        surface: surface,
      );

  static ColorScheme darkScheme() => ColorScheme.fromSeed(
        seedColor: seed,
        secondary: secondary,
        brightness: Brightness.dark,
        surface: darkSurface,
      );
}
