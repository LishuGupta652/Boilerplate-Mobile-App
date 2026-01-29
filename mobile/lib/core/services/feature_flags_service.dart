import 'dart:async';

import '../config/app_config.dart';
import '../storage/local_cache.dart';

class FeatureFlagsService {
  FeatureFlagsService({required this.config, required this.localCache});

  final AppConfig config;
  final LocalCache localCache;

  static const _flagsKey = 'feature_flags';

  final StreamController<Map<String, bool>> _controller =
      StreamController<Map<String, bool>>.broadcast();

  Map<String, bool> _flags = {};
  Timer? _timer;

  Stream<Map<String, bool>> get stream => _controller.stream;

  Map<String, bool> get current => _flags;

  Future<void> initialize({required Future<Map<String, bool>> Function()? fetcher}) async {
    _loadFromCache();
    _controller.add(_flags);

    if (fetcher != null) {
      await refresh(fetcher);
      _timer?.cancel();
      _timer = Timer.periodic(config.featureFlagsPollInterval, (_) {
        refresh(fetcher);
      });
    }
  }

  Future<void> refresh(Future<Map<String, bool>> Function() fetcher) async {
    try {
      final latest = await fetcher();
      _flags = latest;
      await localCache.setPref(_flagsKey, _flags);
      _controller.add(_flags);
    } catch (_) {
      // Keep last-known flags on failures.
    }
  }

  bool isEnabled(String key) => _flags[key] ?? false;

  void _loadFromCache() {
    final cached = localCache.getPref<Map>(_flagsKey);
    if (cached != null) {
      _flags = cached.map((key, value) => MapEntry(key.toString(), value == true));
    }
  }

  void dispose() {
    _timer?.cancel();
    _controller.close();
  }
}
