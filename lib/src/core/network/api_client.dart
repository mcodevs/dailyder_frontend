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
  String message = error.message ?? 'Server bilan bog‘lanishda xato.';
  if (data is Map && data['error'] is String) {
    message = data['error'] as String;
  }
  return ApiException(message: message, statusCode: error.response?.statusCode);
}
