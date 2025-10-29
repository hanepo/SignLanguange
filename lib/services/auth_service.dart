import 'package:flutter/foundation.dart';
import '../models/user.dart';
import 'database_helper.dart';

class AuthService extends ChangeNotifier {
  User? _currentUser;
  final DatabaseHelper _db = DatabaseHelper.instance;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isAdmin => _currentUser?.isAdmin() ?? false;

  Future<bool> login(String email, String password) async {
    try {
      final user = await _db.login(email, password);
      if (user != null) {
        _currentUser = user;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Login error: $e');
      return false;
    }
  }

  Future<bool> register(String email, String password, String fullName,
      {String role = 'user'}) async {
    try {
      // Check if email already exists
      final existingUser = await _db.getUserByEmail(email);
      if (existingUser != null) {
        return false;
      }

      final user = User(
        email: email,
        password: password,
        fullName: fullName,
        role: role,
      );

      final createdUser = await _db.createUser(user);
      _currentUser = createdUser;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Register error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    notifyListeners();
  }

  Future<bool> updateProfile(String fullName, String email) async {
    if (_currentUser == null) return false;

    try {
      final updatedUser = _currentUser!.copyWith(
        fullName: fullName,
        email: email,
      );

      await _db.updateUser(updatedUser);
      _currentUser = updatedUser;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Update profile error: $e');
      return false;
    }
  }

  Future<bool> changePassword(String newPassword) async {
    if (_currentUser == null) return false;

    try {
      final updatedUser = _currentUser!.copyWith(password: newPassword);
      await _db.updateUser(updatedUser);
      _currentUser = updatedUser;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Change password error: $e');
      return false;
    }
  }
}
