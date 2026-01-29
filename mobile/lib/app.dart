import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/providers.dart';
import 'core/theme/app_theme.dart';
import 'core/services/push_service.dart';

final _messengerKey = GlobalKey<ScaffoldMessengerState>();

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final brightness = ref.watch(themeModeProvider);
    final colorSchemes = ref.watch(appColorSchemeProvider);
    ref.listen<AsyncValue<PushMessage>>(pushMessageProvider, (previous, next) {
      next.whenData((message) {
        _messengerKey.currentState?.showSnackBar(
          SnackBar(content: Text(message.title)),
        );
      });
    });

    return MaterialApp.router(
      title: 'Mobile Boilerplate',
      scaffoldMessengerKey: _messengerKey,
      debugShowCheckedModeBanner: false,
      themeMode: brightness,
      theme: AppTheme.light(colorSchemes.light),
      darkTheme: AppTheme.dark(colorSchemes.dark),
      routerConfig: router,
    );
  }
}
