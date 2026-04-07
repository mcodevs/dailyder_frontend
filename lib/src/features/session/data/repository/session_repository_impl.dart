import '../../../../core/network/api_client.dart';
import '../../domain/entity/session_user.dart';
import '../../domain/repository/session_repository.dart';
import '../model/session_auth_response_model.dart';
import '../model/session_user_model.dart';
import 'session_local_store.dart';

class SessionRepositoryImpl implements SessionRepository {
  SessionRepositoryImpl({
    required this.apiClient,
    required this.sessionLocalStore,
  });

  final ApiClient apiClient;
  final SessionLocalStore sessionLocalStore;

  @override
  String get accessToken => sessionLocalStore.accessToken;

  @override
  Future<String> authenticateWithTelegram({required String initData}) async {
    final response = await apiClient.postMap(
      '/api/v1/auth/telegram',
      data: {'initData': initData},
    );
    return SessionAuthResponseModel.fromJson(response).accessToken;
  }

  @override
  Future<String> authenticateWithDevLogin({
    String? username,
    int? telegramUserId,
  }) async {
    final response = await apiClient.postMap(
      '/api/v1/auth/dev-login',
      data: {
        ...?switch (username) {
          String value when value.isNotEmpty => {'username': value},
          _ => null,
        },
        ...?switch (telegramUserId) {
          int value => {'telegramUserId': value},
          _ => null,
        },
      },
    );
    return SessionAuthResponseModel.fromJson(response).accessToken;
  }

  @override
  Future<SessionUser> getCurrentUser() async {
    final response = await apiClient.getMap('/api/v1/me');
    return SessionUserModel.fromJson(response).toEntity();
  }

  @override
  Future<void> saveAccessToken(String accessToken) async {
    await sessionLocalStore.saveAccessToken(accessToken);
  }

  @override
  Future<void> clearAccessToken() async {
    await sessionLocalStore.clearAccessToken();
  }
}
