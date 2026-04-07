import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'telegram_web_app_context.dart';

class TelegramWebAppBridge {
  TelegramWebAppBridge() : webApp = resolveWebApp();

  final JSObject? webApp;

  bool get isAvailable =>
      isTelegramWebAppContext(initData: initData, platform: platform);

  String get initData {
    final app = webApp;
    if (app == null) {
      return '';
    }
    final value = app['initData'];
    final dartValue = value?.dartify();
    return dartValue is String ? dartValue : '';
  }

  String? get platform {
    final app = webApp;
    if (app == null) {
      return null;
    }
    final value = app['platform'];
    final dartValue = value?.dartify();
    return dartValue is String ? dartValue : null;
  }

  void ready() {
    final app = webApp;
    if (app == null) {
      return;
    }
    app.callMethod('ready'.toJS);
  }

  void expand() {
    final app = webApp;
    if (app == null) {
      return;
    }
    app.callMethod('expand'.toJS);
  }

  static JSObject? resolveWebApp() {
    final telegram = globalContext['Telegram'];
    if (telegram == null ||
        telegram.isUndefinedOrNull ||
        !telegram.isA<JSObject>()) {
      return null;
    }
    final webApp = (telegram as JSObject)['WebApp'];
    if (webApp == null || webApp.isUndefinedOrNull || !webApp.isA<JSObject>()) {
      return null;
    }
    return webApp as JSObject;
  }
}
