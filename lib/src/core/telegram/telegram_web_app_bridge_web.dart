import 'dart:async';

import 'package:telegram_web_app/telegram_web_app.dart';

import 'telegram_web_app_context.dart';

class TelegramWebAppBridge {
  bool get isAvailable => isTelegramWebAppContext(
    initData: initData,
    platform: platform,
    currentUri: Uri.base,
  );

  String get initData => _readInitData();

  String? get platform => _readPlatform();

  Future<String> waitForInitData({
    Duration timeout = const Duration(seconds: 5),
    Duration pollInterval = const Duration(milliseconds: 100),
  }) async {
    final deadline = DateTime.now().add(timeout);
    while (true) {
      final currentInitData = initData.trim();
      if (currentInitData.isNotEmpty) {
        return currentInitData;
      }
      if (DateTime.now().isAfter(deadline)) {
        return currentInitData;
      }
      await Future<void>.delayed(pollInterval);
    }
  }

  void ready() {
    _runSafely((telegram) => telegram.ready());
  }

  void expand() {
    _runSafely((telegram) => telegram.expand());
  }

  String _readInitData() {
    try {
      return TelegramWebApp.instance.initData.raw.trim();
    } on Object {
      return '';
    }
  }

  String? _readPlatform() {
    try {
      final value = TelegramWebApp.instance.platform.trim();
      if (value.isNotEmpty && value.toLowerCase() != 'unknown') {
        return value;
      }
    } on Object {
      // Fall back to the launch URL when Telegram JS is not ready yet.
    }

    final queryPlatform = Uri.base.queryParameters['tgWebAppPlatform']?.trim();
    if (queryPlatform == null || queryPlatform.isEmpty) {
      return null;
    }
    return queryPlatform;
  }

  void _runSafely(void Function(TelegramWebApp telegram) action) {
    try {
      action(TelegramWebApp.instance);
    } on Object {
      // Ignore when the app is opened outside Telegram.
    }
  }
}
