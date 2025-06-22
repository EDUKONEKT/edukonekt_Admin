import 'package:flutter/material.dart';
import '../../../core/models/note_model.dart';
import '../service/note_service.dart'; // Ensure the path is correct

class NoteProvider extends ChangeNotifier {
  final NoteService _noteService = NoteService();

  List<Note> _notes = [];
  List<Note> get notes => _notes;

  Note? _note;
  Note? get note => _note;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Retrieves all notes
  Future<void> fetchNotes() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _notes = await _noteService.getAllNotes();
    } catch (e) {
      _errorMessage = e.toString();
      _notes = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Retrieves a note by its Firestore ID
  Future<void> getNoteById(String id) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _note = await _noteService.getNoteById(id);
    } catch (e) {
      _errorMessage = e.toString();
      _note = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Retrieves notes for a specific student
  Future<void> fetchNotesByStudent(String studentId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _notes = await _noteService.getNotesByStudent(studentId);
    } catch (e) {
      _errorMessage = e.toString();
      _notes = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Retrieves notes for a specific evaluation
  Future<void> fetchNotesByEvaluation(String evaluationId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _notes = await _noteService.getNotesByEvaluation(evaluationId);
    } catch (e) {
      _errorMessage = e.toString();
      _notes = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Adds a new note
  Future<Note?> addNote(Note note) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      final newNote = await _noteService.addNote(note);
      if (newNote != null) {
        _notes.add(newNote);
        notifyListeners();
      }
      return newNote;
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Updates an existing note
  Future<void> updateNote(Note note) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      await _noteService.updateNote(note);
      final index = _notes.indexWhere((n) => n.id == note.id);
      if (index != -1) {
        _notes[index] = note;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Deletes a note
  Future<void> deleteNote(String id) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      await _noteService.deleteNote(id);
      _notes.removeWhere((n) => n.id == id);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}