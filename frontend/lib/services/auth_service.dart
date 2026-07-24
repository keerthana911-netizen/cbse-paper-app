import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class AuthService extends ChangeNotifier {
  String? token;
  AppUser? currentUser;
  String? selectedRole; // set by the role-select screen, before login

  static const _tokenKey = 'cbse_app_token';

  Future<void> loadFromDisk() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString(_tokenKey);
    notifyListeners();
  }

  Future<void> saveToken(String newToken) async {
    token = newToken;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, newToken);
    notifyListeners();
  }

  void setUser(AppUser user) {
    currentUser = user;
    notifyListeners();
  }

  void setSelectedRole(String role) {
    selectedRole = role;
    notifyListeners();
  }

  bool get isLoggedIn => token != null && currentUser != null;

  Future<void> logout() async {
    token = null;
    currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    notifyListeners();
  }
}
