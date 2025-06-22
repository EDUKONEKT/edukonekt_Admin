import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../core/models/user_model.dart';
import '../service/user_service.dart';
import 'package:logger/logger.dart';

final Logger _log = Logger();

class UserProvider extends ChangeNotifier {
  UserProvider();

  late UserService _service;
  late StreamSubscription<List<User>> _sub;

  List<User> _users = [];
  List<User> get users => List.unmodifiable(_users);

  bool _ready = false;
  bool get isReady => _ready;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Object? _error;
  Object? get error => _error;

  /// Initialise le service et démarre la récupération des données.
  Future<void> init() async {
    _service = UserService();

    _isLoading = true;
    notifyListeners();

    try {
      _users = await _service.getUsersOnce();
      _ready = true;
      _error = null;
      notifyListeners();

      _sub = _service.watchUsers().listen((newUsers) {
        _users = newUsers;
        _error = null;
        notifyListeners();
      }, onError: (e, stack) {
        _error = e;
        _log.e('UserProvider stream error', error: e, stackTrace: stack);
        notifyListeners();
      });
    } catch (e, stack) {
      _error = e;
      _ready = false;
      _log.e('UserProvider init error', error: e, stackTrace: stack);
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createUser({
    required String email,
    required String password,
    required String role,
    required String username,
    required String schoolId,
  }) async {
    try {
      await _service.createUser(
        email: email,
        password: password,
        role: role,
        username: username,
        schoolId: schoolId,
      );
    } catch (e, stack) {
      _log.e('createUser error', error: e, stackTrace: stack);
      rethrow;
    }
  }

  Future<void> updateUser(User user) async {
    try {
      await _service.updateUser(user);
    } catch (e, stack) {
      _log.e('updateUser error', error: e, stackTrace: stack);
      rethrow;
    }
  }

  UserService get service => _service;

  Future<void> deleteUser(String id) async {
    try {
      await _service.deleteUser(id);
    } catch (e, stack) {
      _log.e('deleteUser error', error: e, stackTrace: stack);
      rethrow;
    }
  }

  User? getUserById(String id) {
    try {
      return _users.firstWhere((u) => u.id == id);
    } catch (_) {
      return null;
    }
  }

  List<User> getUnsyncedUsers() {
    return _users.where((u) => !u.isSynced).toList();
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
