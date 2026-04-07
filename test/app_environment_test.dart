import 'package:dailyder_frontend/src/core/env/app_environment.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('resolveApiBaseUrl returns explicit API_BASE_URL when configured', () {
    final apiBaseUrl = AppEnvironment.resolveApiBaseUrl(
      configuredBaseUrl: 'https://api.dailyder.test',
      currentUri: Uri.parse('https://mini.dailyder.test/login'),
      isWeb: true,
    );

    expect(apiBaseUrl, 'https://api.dailyder.test');
  });

  test('resolveApiBaseUrl uses current origin for hosted web sessions', () {
    final apiBaseUrl = AppEnvironment.resolveApiBaseUrl(
      configuredBaseUrl: '',
      currentUri: Uri.parse('https://mini.dailyder.test/login'),
      isWeb: true,
    );

    expect(apiBaseUrl, 'https://mini.dailyder.test');
  });

  test('resolveApiBaseUrl keeps localhost mapped to backend port 8080', () {
    final apiBaseUrl = AppEnvironment.resolveApiBaseUrl(
      configuredBaseUrl: '',
      currentUri: Uri.parse('http://localhost:3000/login'),
      isWeb: true,
    );

    expect(apiBaseUrl, 'http://localhost:8080');
  });
}
