import 'package:flutter/material.dart';
import '../models/profile_model.dart';
import '../services/auth_service.dart';
import '../config/app_constants.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  Profile? _profile;
  UserRole _role = UserRole.guest;
  bool _isLoading = false;
  String? _error;

  Profile? get profile => _profile;
  UserRole get role => _role;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _authService.isLoggedIn;
  String? get error => _error;

  Future<void> checkAuth() async {
    if (!_authService.isLoggedIn) {
      _role = UserRole.guest;
      return;
    }
    try {
      _profile = await _authService.getProfile();
      _role = UserRole.fromString(_profile!.role);
    } catch (e) {
      _role = UserRole.guest;
    }
    notifyListeners();
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String fullName,
    String? studentId,
    String? phone,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _authService.signUp(
        email: email, password: password,
        fullName: fullName, studentId: studentId, phone: phone,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signIn({required String email, required String password}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _authService.signIn(email: email, password: password);
      _profile = await _authService.getProfile();
      _role = UserRole.fromString(_profile!.role);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _profile = null;
    _role = UserRole.guest;
    notifyListeners();
  }

  Future<void> resetPassword(String email) async {
    await _authService.resetPassword(email);
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
