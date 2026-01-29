import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/config/app_config.dart';
import 'core/providers.dart';
import 'core/storage/local_cache.dart';
import 'core/storage/secure_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final config = await AppConfig.load();
  await LocalCache.initialize();
  await SecureStore.initialize();

  final container = ProviderContainer(
    overrides: [
      appConfigProvider.overrideWithValue(config),
    ],
  );

  // Kick off background initializers before the UI renders.
  await container.read(appBootstrapProvider).initialize();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const App(),
    ),
  );
}
