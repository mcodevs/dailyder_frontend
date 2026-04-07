import 'package:dailyder_frontend/src/core/telegram/telegram_web_app_context.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'returns false when Telegram script is loaded without Telegram context',
    () {
      final isAvailable = isTelegramWebAppContext(
        initData: '',
        platform: 'unknown',
      );

      expect(isAvailable, isFalse);
    },
  );

  test('returns true when Telegram provides init data', () {
    final isAvailable = isTelegramWebAppContext(
      initData: 'query_id=123',
      platform: 'unknown',
    );

    expect(isAvailable, isTrue);
  });

  test('returns true when Telegram provides a real platform', () {
    final isAvailable = isTelegramWebAppContext(
      initData: '',
      platform: 'tdesktop',
    );

    expect(isAvailable, isTrue);
  });
}
