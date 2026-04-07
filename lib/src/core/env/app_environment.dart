import 'package:flutter/foundation.dart';

class AppEnvironment {
  const AppEnvironment({
    required this.apiBaseUrl,
    required this.devAuthEnabled,
  });

  final String apiBaseUrl;
  final bool devAuthEnabled;

  static const String localApiBaseUrl = 'http://localhost:8080';
  static const String productionApiBaseUrl = 'https://dailyder-bot.fly.dev';

  static AppEnvironment current({Uri? currentUri}) {
    const configuredBaseUrl = String.fromEnvironment('API_BASE_URL');
    const devAuthRaw = String.fromEnvironment(
      'DEV_AUTH_ENABLED',
      defaultValue: 'true',
    );
    return AppEnvironment(
      apiBaseUrl: resolveApiBaseUrl(
        configuredBaseUrl: configuredBaseUrl,
        currentUri: currentUri ?? Uri.base,
      ),
      devAuthEnabled: devAuthRaw.toLowerCase() == 'true',
    );
  }

  static String resolveApiBaseUrl({
    required String configuredBaseUrl,
    required Uri currentUri,
    bool isWeb = kIsWeb,
  }) {
    final trimmedConfiguredBaseUrl = configuredBaseUrl.trim();
    if (trimmedConfiguredBaseUrl.isNotEmpty) {
      return trimmedConfiguredBaseUrl;
    }

    if (!isWeb) {
      return localApiBaseUrl;
    }

    final isHttpScheme =
        currentUri.scheme == 'http' || currentUri.scheme == 'https';
    if (!isHttpScheme || currentUri.host.isEmpty) {
      return localApiBaseUrl;
    }

    if (_isLocalDevelopmentHost(currentUri.host)) {
      return 'http://${currentUri.host}:8080';
    }

    return productionApiBaseUrl;
  }

  static bool _isLocalDevelopmentHost(String host) {
    return host == 'localhost' || host == '127.0.0.1' || host == '::1';
  }
}
