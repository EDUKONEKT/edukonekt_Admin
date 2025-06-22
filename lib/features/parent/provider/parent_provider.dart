import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../core/models/parent_model.dart';
import '../service/parent_service.dart';
import 'package:logger/logger.dart';

final Logger _log = Logger();

class ParentProvider extends ChangeNotifier {
  ParentProvider();

  late ParentService _service;
  late StreamSubscription<List<Parent>> _sub;

  List<Parent> _parents = [];
  List<Parent> get parents => List.unmodifiable(_parents);

  bool _ready = false;
  bool get isReady => _ready;

  Object? _error;
  Object? get error => _error;

  /// Initialise le service avec l’ID d’école et démarre l’écoute Firestore.
  Future<void> init(String schoolId) async {
    _service = ParentService(schoolId);

    try {
      _parents = await _service.getParentsOnce();
      _ready = true;
      _error = null;
      notifyListeners();

      _sub = _service.watchParents().listen((data) {
        _parents = data;
        _error = null;
        notifyListeners();
      }, onError: (e, stack) {
        _error = e;
        _log.e('ParentProvider stream error', error: e, stackTrace: stack);
        notifyListeners();
      });
    } catch (e, stack) {
      _error = e;
      _ready = false;
      _log.e('ParentProvider init error', error: e, stackTrace: stack);
      notifyListeners();
    }
  }

  Future<void> add(Parent p) async {
    try {
      await _service.addParent(p);
    } catch (e, stack) {
      _log.e('addParent error', error: e, stackTrace: stack);
      rethrow;
    }
  }

  Future<void> update(Parent p) async {
    try {
      await _service.updateParent(p);
    } catch (e, stack) {
      _log.e('updateParent error', error: e, stackTrace: stack);
      rethrow;
    }
  }

  ParentService get service => _service;

  Future<void> remove(String id) async {
    try {
      await _service.deleteParent(id);
    } catch (e, stack) {
      _log.e('removeParent error', error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  Future<Parent?> findByPhone(String phone) async {
    return await _service.findByPhone(phone);
  }
}
