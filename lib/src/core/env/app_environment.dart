class AppEnvironment {
  const AppEnvironment({
    required this.apiBaseUrl,
    required this.devAuthEnabled,
  });

  final String apiBaseUrl;
  final bool devAuthEnabled;

  static AppEnvironment current() {
    const configuredBaseUrl = String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'http://localhost:8080',
    );
    const devAuthRaw = String.fromEnvironment(
      'DEV_AUTH_ENABLED',
      defaultValue: 'true',
    );
    return AppEnvironment(
      apiBaseUrl: configuredBaseUrl,
      devAuthEnabled: devAuthRaw.toLowerCase() == 'true',
    );
  }
}
