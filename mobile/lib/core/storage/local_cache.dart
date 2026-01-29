import 'package:hive_flutter/hive_flutter.dart';

class LocalCache {
  LocalCache._();

  static final LocalCache instance = LocalCache._();
  static const _cacheBoxName = 'cache';
  static const _prefsBoxName = 'prefs';

  late final Box _cacheBox;
  late final Box _prefsBox;

  Box get cacheBox => _cacheBox;
  Box get prefsBox => _prefsBox;

  static Future<void> initialize() async {
    await Hive.initFlutter();
    instance._cacheBox = await Hive.openBox(_cacheBoxName);
    instance._prefsBox = await Hive.openBox(_prefsBoxName);
  }

  T? getCache<T>(String key) => _cacheBox.get(key) as T?;
  Future<void> setCache<T>(String key, T value) => _cacheBox.put(key, value);
  Future<void> removeCache(String key) => _cacheBox.delete(key);

  T? getPref<T>(String key) => _prefsBox.get(key) as T?;
  Future<void> setPref<T>(String key, T value) => _prefsBox.put(key, value);
}
