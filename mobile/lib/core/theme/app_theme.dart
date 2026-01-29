import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData light(ColorScheme scheme) {
    return FlexThemeData.light(
      colorScheme: scheme,
      useMaterial3: true,
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 14,
      appBarStyle: FlexAppBarStyle.primary,
      typography: Typography.material2021(platform: TargetPlatform.iOS),
      fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
      subThemesData: const FlexSubThemesData(
        blendOnLevel: 20,
        blendOnColors: false,
        useTextTheme: true,
        filledButtonRadius: 16,
        elevatedButtonRadius: 16,
        outlinedButtonRadius: 16,
        inputDecoratorRadius: 16,
        cardRadius: 20,
        navigationBarSelectedLabelSchemeColor: SchemeColor.primary,
        navigationBarIndicatorSchemeColor: SchemeColor.primaryContainer,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
    );
  }

  static ThemeData dark(ColorScheme scheme) {
    return FlexThemeData.dark(
      colorScheme: scheme,
      useMaterial3: true,
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 20,
      appBarStyle: FlexAppBarStyle.material,
      typography: Typography.material2021(platform: TargetPlatform.iOS),
      fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
      subThemesData: const FlexSubThemesData(
        blendOnLevel: 30,
        blendOnColors: false,
        useTextTheme: true,
        filledButtonRadius: 16,
        elevatedButtonRadius: 16,
        outlinedButtonRadius: 16,
        inputDecoratorRadius: 16,
        cardRadius: 20,
        navigationBarSelectedLabelSchemeColor: SchemeColor.primary,
        navigationBarIndicatorSchemeColor: SchemeColor.primaryContainer,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
    );
  }
}
