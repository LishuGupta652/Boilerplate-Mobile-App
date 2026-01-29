import 'dart:async';

import '../config/app_config.dart';

class PushMessage {
  final String title;
  final String body;
  final Map<String, dynamic> data;

  const PushMessage({
    required this.title,
    required this.body,
    required this.data,
  });
}

class PushService {
  PushService({required this.config});

  final AppConfig config;
  final StreamController<PushMessage> _controller =
      StreamController<PushMessage>.broadcast();

  Stream<PushMessage> get messages => _controller.stream;

  Future<void> initialize() async {
    if (!config.enablePush) {
      return;
    }
    // Placeholder for Firebase/APNS configuration.
    // Follow the README to wire up real push notifications.
  }

  void emitTestMessage() {
    _controller.add(const PushMessage(
      title: 'Demo notification',
      body: 'Push notifications are wired and ready.',
      data: {},
    ));
  }

  void dispose() {
    _controller.close();
  }
}
