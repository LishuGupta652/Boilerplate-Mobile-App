import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';

import '../config/app_config.dart';
import '../services/auth_service.dart';
import '../services/connectivity_service.dart';
import '../storage/cache_store.dart';
import '../storage/local_cache.dart';
import 'auth_interceptor.dart';
import 'cache_interceptor.dart';

class ApiClient {
  ApiClient({
    required AppConfig config,
    required AuthService authService,
    required ConnectivityService connectivity,
    required LocalCache localCache,
  }) : dio = Dio(
          BaseOptions(
            baseUrl: config.apiBaseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 20),
            sendTimeout: const Duration(seconds: 15),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
    if (kReleaseMode && config.apiBaseUrl.startsWith('http://')) {
      throw StateError('Insecure API base URL in release mode.');
    }

    final cacheStore = CacheStore(localCache: localCache);

    dio.interceptors.addAll([
      AuthInterceptor(authService),
      CacheInterceptor(cacheStore: cacheStore, connectivityService: connectivity),
      RetryInterceptor(dio: dio, retries: 2, retryDelays: const [
        Duration(milliseconds: 300),
        Duration(milliseconds: 900),
      ]),
    ]);
  }

  final Dio dio;

  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? queryParameters}) {
    return dio.get<T>(path, queryParameters: queryParameters);
  }

  Future<Response<T>> post<T>(String path, {Object? data}) {
    return dio.post<T>(path, data: data);
  }

  Future<Response<T>> put<T>(String path, {Object? data}) {
    return dio.put<T>(path, data: data);
  }

  Future<Response<T>> delete<T>(String path) {
    return dio.delete<T>(path);
  }
}
