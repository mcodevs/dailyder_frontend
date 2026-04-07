import 'package:dailyder_frontend/src/core/network/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('mapDioException returns a stable connection error message', () {
    final exception = mapDioException(
      DioException.connectionError(
        requestOptions: RequestOptions(path: '/api/v1/auth/dev-login'),
        reason: 'XMLHttpRequest onError callback was called',
      ),
    );

    expect(
      exception.message,
      'API bilan bog‘lanib bo‘lmadi. Backend server ishlayotganini va API manzili to‘g‘ri ekanini tekshiring.',
    );
  });
}
