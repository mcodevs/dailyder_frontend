import 'package:flutter/widgets.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import '../di/injection.dart';
import '../telegram/telegram_web_app_bridge.dart';
import 'app.dart';

class AppInit {
  const AppInit._();

  static Future<void> run() async {
    WidgetsFlutterBinding.ensureInitialized();
    usePathUrlStrategy();
    await setupDependencies();
    sl<TelegramWebAppBridge>().ready();
    sl<TelegramWebAppBridge>().expand();
    runApp(const App());
  }
}
