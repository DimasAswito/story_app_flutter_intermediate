import 'package:shared_preferences/shared_preferences.dart';

class AuthPreferences {
  final SharedPreferences sharedPreferences;

  AuthPreferences({required this.sharedPreferences});

  static const String _sessionKey = 'session';
  static const String _tokenKey = 'token';

  Future<void> saveSession(String token) async {
    await sharedPreferences.setBool(_sessionKey, true);
    await sharedPreferences.setString(_tokenKey, token);
  }

  Future<void> clearSession() async {
    await sharedPreferences.setBool(_sessionKey, false);
    await sharedPreferences.remove(_tokenKey);
  }

  Future<bool> isLoggedIn() async {
    return sharedPreferences.getBool(_sessionKey) ?? false;
  }

  Future<String?> getToken() async {
    return sharedPreferences.getString(_tokenKey);
  }
}
