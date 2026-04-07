import 'package:dailyder_frontend/src/core/telegram/telegram_web_app_context.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'returns false when Telegram script is loaded without Telegram context',
    () {
      final isAvailable = isTelegramWebAppContext(
        initData: '',
        platform: 'unknown',
        currentUri: Uri.parse('https://dailyder-e8a28.web.app/'),
      );

      expect(isAvailable, isFalse);
    },
  );

  test('returns true when Telegram provides init data', () {
    final isAvailable = isTelegramWebAppContext(
      initData: 'query_id=123',
      platform: 'unknown',
      currentUri: Uri.parse('https://dailyder-e8a28.web.app/'),
    );

    expect(isAvailable, isTrue);
  });

  test('returns true when Telegram provides a real platform', () {
    final isAvailable = isTelegramWebAppContext(
      initData: '',
      platform: 'tdesktop',
      currentUri: Uri.parse('https://dailyder-e8a28.web.app/'),
    );

    expect(isAvailable, isTrue);
  });

  test('returns true when Telegram platform comes from launch URL', () {
    final isAvailable = isTelegramWebAppContext(
      initData: '',
      platform: null,
      currentUri: Uri.parse(
        'https://dailyder-e8a28.web.app/?tgWebAppPlatform=ios',
      ),
    );

    expect(isAvailable, isTrue);
  });
}
