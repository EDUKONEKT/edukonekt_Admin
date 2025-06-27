import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/models/class_model.dart';
import '../service/class_service.dart';

class ClassProvider with ChangeNotifier {
  late ClassService _service;
  final List<Class> _classes = [];
  bool _isLoading = false;
  String? _error;

  // Subscription pour le stream Firestore
  StreamSubscription<QuerySnapshot>? _subscription;

  List<Class> get classes => List.unmodifiable(_classes);
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Initialise le provider avec l'id de l'école, et démarre l'écoute Firestore
  Future<void> init(String schoolId) async {
  _service = ClassService(schoolId);
  await getClassesOnce();      // 👈 récupération immédiate
  _listenToClasses();          // 👂 écoute temps réel ensuite
}


  void _listenToClasses() {
    _isLoading = true;
    _error = null;
    notifyListeners();

    _subscription?.cancel(); // au cas où déjà abonné

    _subscription = _service.ref.snapshots().listen(
      (snapshot) {
        _classes.clear();
        _classes.addAll(snapshot.docs
            .map((doc) => Class.fromMap(doc.data() as Map<String, dynamic>, doc.id)));
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (e) {
        _error = e.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }
  Future<void> getClassesOnce() async {
  try {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final snapshot = await _service.ref.get();
    _classes.clear();
    _classes.addAll(snapshot.docs
        .map((doc) => Class.fromMap(doc.data() as Map<String, dynamic>, doc.id)));

    _isLoading = false;
    notifyListeners();
  } catch (e) {
    _error = e.toString();
    _isLoading = false;
    notifyListeners();
  }
}


  Future<void> add(Class c) async {
    try {
       await _service.addWithIdReturn(c);
      // Pas besoin de reload, le stream va déclencher la mise à jour automatiquement
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> update(Class c) async {
    try {
      await _service.update(c);
      // Le stream s’en charge aussi automatiquement
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Class? getById(String id) {
  try {
    return _classes.firstWhere((c) => c.id == id);
  } catch (_) {
    return null;
  }
}


  Future<void> delete(String id) async {
    try {
      await _service.delete(id);
      // Le stream s’en charge aussi automatiquement
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void clear() {
    _subscription?.cancel();
    _subscription = null;
    _classes.clear();
    _isLoading = false;
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
