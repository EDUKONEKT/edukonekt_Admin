import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/models/note_model.dart'; // Ensure the path is correct

class NoteService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'notes';

  // Adds a new note to Firestore
  Future<Note?> addNote(Note note) async {
    try {
      final docRef = await _db.collection(_collection).add(note.toFirestore());
      final docSnapshot = await docRef.get();
      return docSnapshot.exists ? Note.fromFirestore(docSnapshot.data() as Map<String, dynamic>, docSnapshot.id) : null;
    } on FirebaseException catch (e) {
      throw Exception('Firebase error adding note: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error adding note: $e');
    }
  }

  // Retrieves a note by its Firestore ID
  Future<Note?> getNoteById(String id) async {
    try {
      final docSnapshot = await _db.collection(_collection).doc(id).get();
      return docSnapshot.exists ? Note.fromFirestore(docSnapshot.data() as Map<String, dynamic>, docSnapshot.id) : null;
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting note by ID: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting note by ID: $e');
    }
  }

  // Retrieves all notes
  Future<List<Note>> getAllNotes() async {
    try {
      final querySnapshot = await _db.collection(_collection).get();
      return querySnapshot.docs.map((doc) => Note.fromFirestore(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting all notes: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting all notes: $e');
    }
  }

  // Retrieves notes for a specific student
  Future<List<Note>> getNotesByStudent(String studentId) async {
    try {
      final querySnapshot = await _db
          .collection(_collection)
          .where('studentId', isEqualTo: studentId)
          .get();
      return querySnapshot.docs.map((doc) => Note.fromFirestore(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting notes by student: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting notes by student: $e');
    }
  }

  // Retrieves notes for a specific evaluation
  Future<List<Note>> getNotesByEvaluation(String evaluationId) async {
    try {
      final querySnapshot = await _db
          .collection(_collection)
          .where('evaluationId', isEqualTo: evaluationId)
          .get();
      return querySnapshot.docs.map((doc) => Note.fromFirestore(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error getting notes by evaluation: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting notes by evaluation: $e');
    }
  }

  // Updates an existing note
  Future<void> updateNote(Note note) async {
    try {
      await _db.collection(_collection).doc(note.id).update(note.toFirestore());
    } on FirebaseException catch (e) {
      throw Exception('Firebase error updating note: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error updating note: $e');
    }
  }

  // Deletes a note by its ID
  Future<void> deleteNote(String id) async {
    try {
      await _db.collection(_collection).doc(id).delete();
    } on FirebaseException catch (e) {
      throw Exception('Firebase error deleting note: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error deleting note: $e');
    }
  }
}