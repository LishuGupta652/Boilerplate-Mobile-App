import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'config/app_config.dart';
import 'routing/app_router.dart';
import 'routing/refresh_stream.dart';
import 'services/app_bootstrap.dart';
import 'services/auth_service.dart';
import 'services/connectivity_service.dart';
import 'services/feature_flags_service.dart';
import 'services/permissions_service.dart';
import 'services/push_service.dart';
import 'services/theme_service.dart';
import 'network/api_client.dart';
import 'storage/local_cache.dart';
import 'storage/secure_store.dart';
import 'theme/theme_tokens.dart';

final appConfigProvider = Provider<AppConfig>((ref) {
  throw UnimplementedError('AppConfig must be overridden in main().');
});

final secureStoreProvider = Provider<SecureStore>((ref) {
  return SecureStore.instance;
});

final localCacheProvider = Provider<LocalCache>((ref) {
  return LocalCache.instance;
});

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final service = ConnectivityService();
  ref.onDispose(service.dispose);
  return service;
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(
    config: ref.watch(appConfigProvider),
    secureStore: ref.watch(secureStoreProvider),
  );
});

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(
    config: ref.watch(appConfigProvider),
    authService: ref.watch(authServiceProvider),
    connectivity: ref.watch(connectivityServiceProvider),
    localCache: ref.watch(localCacheProvider),
  );
});

final featureFlagsServiceProvider = Provider<FeatureFlagsService>((ref) {
  final service = FeatureFlagsService(
    config: ref.watch(appConfigProvider),
    localCache: ref.watch(localCacheProvider),
  );
  ref.onDispose(service.dispose);
  return service;
});

final featureFlagsProvider = StreamProvider<Map<String, bool>>((ref) {
  return ref.watch(featureFlagsServiceProvider).stream;
});

final permissionsServiceProvider = Provider<PermissionsService>((ref) {
  return PermissionsService();
});

final pushServiceProvider = Provider<PushService>((ref) {
  final service = PushService(config: ref.watch(appConfigProvider));
  ref.onDispose(service.dispose);
  return service;
});

final themeServiceProvider = Provider<ThemeService>((ref) {
  return ThemeService(localCache: ref.watch(localCacheProvider));
});

final themeModeProvider = StateNotifierProvider<ThemeModeController, ThemeMode>((ref) {
  return ThemeModeController(ref.watch(themeServiceProvider));
});

final appColorSchemeProvider = StateNotifierProvider<ColorSchemeController, ColorSchemeState>((ref) {
  return ColorSchemeController(ref.watch(themeServiceProvider));
});

final authSessionStreamProvider = StreamProvider<AuthSession?>((ref) {
  return ref.watch(authServiceProvider).sessionStream;
});

final appRouterProvider = Provider<GoRouter>((ref) {
  final authStream = ref.watch(authSessionStreamProvider.stream);
  final refresh = GoRouterRefreshStream(authStream);
  ref.onDispose(refresh.dispose);

  return buildAppRouter(
    refreshListenable: refresh,
    authSession: ref.watch(authSessionStreamProvider).valueOrNull,
  );
});

final appBootstrapProvider = Provider<AppBootstrap>((ref) {
  return AppBootstrap(
    authService: ref.watch(authServiceProvider),
    featureFlagsService: ref.watch(featureFlagsServiceProvider),
    permissionsService: ref.watch(permissionsServiceProvider),
    pushService: ref.watch(pushServiceProvider),
    connectivityService: ref.watch(connectivityServiceProvider),
    apiClient: ref.watch(apiClientProvider),
  );
});

class ColorSchemeState {
  final ColorScheme light;
  final ColorScheme dark;

  const ColorSchemeState({required this.light, required this.dark});
}

class ColorSchemeController extends StateNotifier<ColorSchemeState> {
  final ThemeService _themeService;

  ColorSchemeController(this._themeService)
      : super(ColorSchemeState(
          light: ThemeTokens.lightScheme(),
          dark: ThemeTokens.darkScheme(),
        )) {
    _load();
  }

  Future<void> _load() async {
    final seed = _themeService.seedColor;
    state = ColorSchemeState(
      light: ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.light),
      dark: ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.dark),
    );
  }

  Future<void> updateSeed(Color color) async {
    await _themeService.setSeedColor(color);
    state = ColorSchemeState(
      light: ColorScheme.fromSeed(seedColor: color, brightness: Brightness.light),
      dark: ColorScheme.fromSeed(seedColor: color, brightness: Brightness.dark),
    );
  }
}

class ThemeModeController extends StateNotifier<ThemeMode> {
  final ThemeService _themeService;

  ThemeModeController(this._themeService) : super(_themeService.themeMode);

  Future<void> setMode(ThemeMode mode) async {
    await _themeService.setThemeMode(mode);
    state = mode;
  }
}
