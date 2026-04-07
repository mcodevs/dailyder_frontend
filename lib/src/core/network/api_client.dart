import 'package:dio/dio.dart';

import '../../features/session/data/repository/session_local_store.dart';
import '../env/app_environment.dart';
import 'api_exception.dart';

class ApiClient {
  ApiClient({
    required AppEnvironment environment,
    required SessionLocalStore sessionLocalStore,
  }) : dio = Dio(
         BaseOptions(
           baseUrl: environment.apiBaseUrl,
           connectTimeout: const Duration(seconds: 20),
           receiveTimeout: const Duration(seconds: 20),
           headers: const {'Content-Type': 'application/json'},
         ),
       ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = sessionLocalStore.accessToken;
          if (token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
  }

  final Dio dio;

  Future<Map<String, dynamic>> getMap(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.get<Object?>(
        path,
        queryParameters: queryParameters,
      );
      return castJsonMap(response.data);
    } on DioException catch (error) {
      throw mapDioException(error);
    }
  }

  Future<Map<String, dynamic>> postMap(String path, {Object? data}) async {
    try {
      final response = await dio.post<Object?>(path, data: data);
      return castJsonMap(response.data);
    } on DioException catch (error) {
      throw mapDioException(error);
    }
  }

  Future<Map<String, dynamic>> patchMap(String path, {Object? data}) async {
    try {
      final response = await dio.patch<Object?>(path, data: data);
      return castJsonMap(response.data);
    } on DioException catch (error) {
      throw mapDioException(error);
    }
  }

  Future<Map<String, dynamic>> putMap(String path, {Object? data}) async {
    try {
      final response = await dio.put<Object?>(path, data: data);
      return castJsonMap(response.data);
    } on DioException catch (error) {
      throw mapDioException(error);
    }
  }

  Future<Map<String, dynamic>> deleteMap(String path) async {
    try {
      final response = await dio.delete<Object?>(path);
      return castJsonMap(response.data);
    } on DioException catch (error) {
      throw mapDioException(error);
    }
  }
}

Map<String, dynamic> castJsonMap(Object? value) {
  if (value is Map<String, dynamic>) {
    return value;
  }
  if (value is Map) {
    return value.map((key, item) => MapEntry(key.toString(), item));
  }
  throw const ApiException(message: 'Server noto‘g‘ri javob qaytardi.');
}

ApiException mapDioException(DioException error) {
  final data = error.response?.data;
  final statusCode = error.response?.statusCode;
  if (data is Map && data['error'] is String) {
    return ApiException(
      message: data['error'] as String,
      statusCode: statusCode,
    );
  }

  if (error.type == DioExceptionType.connectionError) {
    return ApiException(
      message:
          'API bilan bog‘lanib bo‘lmadi. Backend server ishlayotganini va API manzili to‘g‘ri ekanini tekshiring.',
      statusCode: statusCode,
    );
  }

  if (error.type == DioExceptionType.connectionTimeout ||
      error.type == DioExceptionType.sendTimeout ||
      error.type == DioExceptionType.receiveTimeout) {
    return ApiException(
      message: 'Server bilan bog‘lanish vaqti tugadi. Qayta urinib ko‘ring.',
      statusCode: statusCode,
    );
  }

  if (statusCode == 404) {
    return const ApiException(
      message:
          'API route topilmadi. Frontend noto‘g‘ri backend manziliga ulanayotgan bo‘lishi mumkin.',
      statusCode: 404,
    );
  }

  final message = error.message ?? 'Server bilan bog‘lanishda xato.';
  return ApiException(message: message, statusCode: statusCode);
}
