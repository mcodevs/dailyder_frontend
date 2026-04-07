import 'package:shared_preferences/shared_preferences.dart';

class SessionLocalStore {
  SessionLocalStore({required this.preferences});

  final SharedPreferences preferences;

  String get accessToken => preferences.getString('access_token') ?? '';

  Future<void> saveAccessToken(String accessToken) async {
    await preferences.setString('access_token', accessToken);
  }

  Future<void> clearAccessToken() async {
    await preferences.remove('access_token');
  }
}
