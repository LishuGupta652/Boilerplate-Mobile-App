import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _controller = StreamController<bool>.broadcast();

  bool _isOnline = true;

  ConnectivityService() {
    _init();
  }

  Stream<bool> get onStatusChange => _controller.stream;
  bool get isOnlineSync => _isOnline;

  Future<void> _init() async {
    _isOnline = await _check();
    _controller.add(_isOnline);
    _connectivity.onConnectivityChanged.listen((result) {
      final online = result != ConnectivityResult.none;
      if (online != _isOnline) {
        _isOnline = online;
        _controller.add(_isOnline);
      }
    });
  }

  Future<bool> isOnline() async {
    _isOnline = await _check();
    return _isOnline;
  }

  Future<bool> _check() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  void dispose() {
    _controller.close();
  }
}
