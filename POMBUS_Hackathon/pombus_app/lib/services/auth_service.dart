import 'package:shared_preferences/shared_preferences.dart';
import '../models/index.dart';
import 'api_service.dart';

class AuthService {
  final ApiService apiService;
  late SharedPreferences _prefs;

  AuthService({required this.apiService});

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<User?> getCurrentUser() async {
    final userJson = _prefs.getString('current_user');
    if (userJson != null) {
      try {
        // In a real app, you would parse the JSON
        return null; // Placeholder
      } catch (e) {
        clearAuthData();
        return null;
      }
    }
    return null;
  }

  Future<String?> getToken() async {
    return _prefs.getString('auth_token');
  }

  Future<void> saveUser(User user) async {
    await _prefs.setString('current_user', user.email);
    await _prefs.setString('auth_token', user.token);
    await _prefs.setString('user_id', user.id);
  }

  Future<void> clearAuthData() async {
    await _prefs.remove('current_user');
    await _prefs.remove('auth_token');
    await _prefs.remove('user_id');
  }

  bool isLoggedIn() {
    return _prefs.containsKey('auth_token');
  }
}
