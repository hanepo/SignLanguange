import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../models/user.dart';
import 'firebase_service.dart';

class AuthService extends ChangeNotifier {
  User? _currentUser;
  final FirebaseService _firebaseService = FirebaseService.instance;
  final firebase_auth.FirebaseAuth _firebaseAuth =
      firebase_auth.FirebaseAuth.instance;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isAdmin => _currentUser?.isAdmin() ?? false;

  // Listen to Firebase Auth state changes
  AuthService() {
    _firebaseAuth.authStateChanges().listen((firebaseUser) async {
      if (firebaseUser != null) {
        // Load user data from Firestore
        final user = await _firebaseService.getUserByEmail(firebaseUser.email!);
        _currentUser = user;
        notifyListeners();
      } else {
        _currentUser = null;
        notifyListeners();
      }
    });
  }

  Future<bool> login(String email, String password) async {
    try {
      // Sign in with Firebase Auth
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // Load user data from Firestore
        final user = await _firebaseService.getUserByEmail(email);
        if (user != null) {
          _currentUser = user;
          notifyListeners();
          return true;
        }
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
      // Check if email already exists in Firestore
      final existingUser = await _firebaseService.getUserByEmail(email);
      if (existingUser != null) {
        return false;
      }

      // Create Firebase Auth account
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // Create user document in Firestore
        final user = User(
          email: email,
          password:
              password, // Store for compatibility (not recommended in production)
          fullName: fullName,
          role: role,
          createdAt: DateTime.now(),
        );

        final userId = await _firebaseService.createUser(user);
        if (userId != null) {
          _currentUser = user.copyWith(id: userId);
          notifyListeners();
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint('Register error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
    _currentUser = null;
    notifyListeners();
  }

  Future<bool> updateProfile(String fullName, String email) async {
    if (_currentUser == null) return false;

    try {
      // Update Firebase Auth email if changed
      if (email != _currentUser!.email) {
        await _firebaseAuth.currentUser?.verifyBeforeUpdateEmail(email);
      }

      // Update Firestore document
      final updatedUser = _currentUser!.copyWith(
        fullName: fullName,
        email: email,
        updatedAt: DateTime.now(),
      );

      final success = await _firebaseService.updateUser(updatedUser);
      if (success) {
        _currentUser = updatedUser;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Update profile error: $e');
      return false;
    }
  }

  Future<bool> changePassword(String newPassword) async {
    if (_currentUser == null) return false;

    try {
      // Update Firebase Auth password
      await _firebaseAuth.currentUser?.updatePassword(newPassword);

      // Update Firestore document
      final updatedUser = _currentUser!.copyWith(
        password: newPassword,
        updatedAt: DateTime.now(),
      );

      final success = await _firebaseService.updateUser(updatedUser);
      if (success) {
        _currentUser = updatedUser;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Change password error: $e');
      return false;
    }
  }
}
