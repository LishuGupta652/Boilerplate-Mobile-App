import 'package:flutter/material.dart';

import '../storage/local_cache.dart';

class ThemeService {
  ThemeService({required this.localCache});

  final LocalCache localCache;

  static const _themeModeKey = 'theme_mode';
  static const _seedColorKey = 'seed_color';

  ThemeMode get themeMode {
    final mode = localCache.getPref<String>(_themeModeKey);
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Color get seedColor {
    final value = localCache.getPref<int>(_seedColorKey);
    return value != null ? Color(value) : const Color(0xFF2DD4BF);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      _ => 'system',
    };
    await localCache.setPref(_themeModeKey, value);
  }

  Future<void> setSeedColor(Color color) async {
    await localCache.setPref(_seedColorKey, color.value);
  }
}
