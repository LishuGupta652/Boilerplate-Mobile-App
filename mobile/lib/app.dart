import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/providers.dart';
import 'core/theme/app_theme.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final brightness = ref.watch(themeModeProvider);
    final colorSchemes = ref.watch(appColorSchemeProvider);

    return MaterialApp.router(
      title: 'Mobile Boilerplate',
      debugShowCheckedModeBanner: false,
      themeMode: brightness,
      theme: AppTheme.light(colorSchemes.light),
      darkTheme: AppTheme.dark(colorSchemes.dark),
      routerConfig: router,
    );
  }
}
