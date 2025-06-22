import 'package:flutter/material.dart';

import '../../../core/models/message_model.dart';
import '../service/message_service.dart';

class MessageProvider extends ChangeNotifier {
  final MessageService _messageService = MessageService();

  List<Message> _messages = [];
  List<Message> get messages => _messages;

  Message? _message;
  Message? get message => _message;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Retrieves all messages
  Future<void> fetchMessages() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _messages = await _messageService.getAllMessages();
    } catch (e) {
      _errorMessage = e.toString();
      _messages = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Retrieves a message by its Firestore ID
  Future<void> getMessageById(String id) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _message = await _messageService.getMessageById(id);
    } catch (e) {
      _errorMessage = e.toString();
      _message = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Retrieves messages sent by a specific user
  Future<void> fetchMessagesBySender(String senderId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _messages = await _messageService.getMessagesBySender(senderId);
    } catch (e) {
      _errorMessage = e.toString();
      _messages = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Retrieves messages received by a specific user
  Future<void> fetchMessagesByReceiver(String receiverId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _messages = await _messageService.getMessagesByReceiver(receiverId);
    } catch (e) {
      _errorMessage = e.toString();
      _messages = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Retrieves messages between two specific users
  Future<void> fetchMessagesBetweenUsers(String userId1, String userId2) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _messages = await _messageService.getMessagesBetweenUsers(userId1, userId2);
    } catch (e) {
      _errorMessage = e.toString();
      _messages = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Adds a new message
  Future<Message?> addMessage(Message message) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      final newMessage = await _messageService.addMessage(message);
      if (newMessage != null) {
        _messages.add(newMessage);
        notifyListeners();
      }
      return newMessage;
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Updates an existing message
  Future<void> updateMessage(Message message) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      await _messageService.updateMessage(message);
      final index = _messages.indexWhere((m) => m.id == message.id);
      if (index != -1) {
        _messages[index] = message;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Deletes a message
  Future<void> deleteMessage(String id) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      await _messageService.deleteMessage(id);
      _messages.removeWhere((m) => m.id == id);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}