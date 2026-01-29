import 'package:dio/dio.dart';

import '../services/connectivity_service.dart';
import '../storage/cache_store.dart';

class CacheInterceptor extends Interceptor {
  CacheInterceptor({required this.cacheStore, required this.connectivityService});

  final CacheStore cacheStore;
  final ConnectivityService connectivityService;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.method.toUpperCase() == 'GET') {
      final isOnline = await connectivityService.isOnline();
      if (!isOnline) {
        final cached = cacheStore.get(options.uri.toString());
        if (cached != null) {
          return handler.resolve(
            Response(
              requestOptions: options,
              data: cached.data,
              statusCode: 200,
            ),
          );
        }
      }
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.requestOptions.method.toUpperCase() == 'GET' &&
        response.statusCode == 200) {
      cacheStore.set(response.requestOptions.uri.toString(), response.data);
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final options = err.requestOptions;
    if (options.method.toUpperCase() == 'GET') {
      final cached = cacheStore.get(options.uri.toString());
      if (cached != null) {
        return handler.resolve(
          Response(
            requestOptions: options,
            data: cached.data,
            statusCode: 200,
          ),
        );
      }
    }
    handler.next(err);
  }
}
