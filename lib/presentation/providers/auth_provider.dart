import 'package:flutter/foundation.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  final AuthRepository repository;

  User? _currentUser;
  AuthStatus _status = AuthStatus.initial;
  String? _errorMessage;

  AuthProvider(this.repository) {
    _checkCurrentUser();
  }

  User? get currentUser => _currentUser;
  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;

  Future<void> _checkCurrentUser() async {
    _status = AuthStatus.loading;
    notifyListeners();

    final result = await repository.getCurrentUser();
    result.fold(
      (failure) {
        _status = AuthStatus.error;
        _errorMessage = failure.message;
      },
      (user) {
        _currentUser = user;
        _status = user != null ? AuthStatus.authenticated : AuthStatus.unauthenticated;
      },
    );
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await repository.login(email, password);
    return result.fold(
      (failure) {
        _status = AuthStatus.error;
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (user) {
        _currentUser = user;
        _status = AuthStatus.authenticated;
        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> register(String name, String email, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await repository.register(name, email, password);
    return result.fold(
      (failure) {
        _status = AuthStatus.error;
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (user) {
        _currentUser = user;
        _status = AuthStatus.authenticated;
        notifyListeners();
        return true;
      },
    );
  }

  Future<void> logout() async {
    await repository.logout();
    _currentUser = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}
