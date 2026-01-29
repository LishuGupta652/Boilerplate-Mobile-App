import 'package:flutter/foundation.dart';

import 'local_cache.dart';

class CacheEntry {
  final dynamic data;
  final DateTime timestamp;

  CacheEntry({required this.data, required this.timestamp});
}

class CacheStore {
  CacheStore({required this.localCache, this.ttl = const Duration(minutes: 15)});

  final LocalCache localCache;
  final Duration ttl;

  String _key(String url) => 'cache:$url';

  CacheEntry? get(String url) {
    final raw = localCache.getCache<Map>(_key(url));
    if (raw == null) return null;

    final timestamp = DateTime.tryParse(raw['timestamp']?.toString() ?? '');
    if (timestamp == null) return null;

    if (DateTime.now().difference(timestamp) > ttl) {
      localCache.removeCache(_key(url));
      return null;
    }

    return CacheEntry(data: raw['data'], timestamp: timestamp);
  }

  Future<void> set(String url, dynamic data) async {
    try {
      await localCache.setCache(_key(url), {
        'data': data,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (_) {
      if (kDebugMode) {
        // Swallow cache write errors; networking should still succeed.
      }
    }
  }
}
