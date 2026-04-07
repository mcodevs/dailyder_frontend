import 'dart:async';

class TelegramWebAppBridge {
  bool get isAvailable => false;

  String get initData => '';

  Future<String> waitForInitData({
    Duration timeout = const Duration(seconds: 2),
    Duration pollInterval = const Duration(milliseconds: 100),
  }) async {
    return '';
  }

  void ready() {}

  void expand() {}
}
