import '../entity/session_user.dart';

abstract class SessionRepository {
  String get accessToken;

  Future<String> authenticateWithTelegram({required String initData});

  Future<String> authenticateWithDevLogin({
    String? username,
    int? telegramUserId,
  });

  Future<SessionUser> getCurrentUser();

  Future<void> saveAccessToken(String accessToken);

  Future<void> clearAccessToken();
}
