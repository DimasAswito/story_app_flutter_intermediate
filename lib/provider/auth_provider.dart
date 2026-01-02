import 'package:flutter/material.dart';
import 'package:story_app_flutter_intermediate/api/api_service.dart';
import 'package:story_app_flutter_intermediate/data/preferences/auth_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final AuthPreferences authPreferences;
  final ApiService apiService;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _token;
  String? get token => _token;

  AuthProvider({required this.authPreferences, required this.apiService}) {
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    _isLoggedIn = await authPreferences.isLoggedIn();
    if (_isLoggedIn) {
      _token = await authPreferences.getToken();
    }
    notifyListeners();
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await apiService.login(email, password);
      if (!response['error']) {
        final token = response['loginResult']['token'];
        await authPreferences.saveSession(token);
        _token = token;
        _isLoggedIn = true;
      }
      return response;
    } catch (e) {
      return {
        'error': true,
        'message': 'An error occurred. Please check your connection.',
      };
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await apiService.register(name, email, password);
      return response;
    } catch (e) {
      return {
        'error': true,
        'message': 'An error occurred. Please check your connection.',
      };
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await authPreferences.clearSession();
    _token = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}
