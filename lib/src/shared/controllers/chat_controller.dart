import 'dart:async';

import 'package:chat/src/chat/models/chat_message.dart';

/// Simple in-memory chat controller
/// Manages a list of chat messages with insert, update, remove operations
class ChatController {
  final List<ChatMessage> _messages = [];
  final StreamController<List<ChatMessage>> _messagesController =
      StreamController<List<ChatMessage>>.broadcast();

  /// Get current messages
  List<ChatMessage> get messages => List.unmodifiable(_messages);

  /// Stream of message updates
  Stream<List<ChatMessage>> get messagesStream => _messagesController.stream;

  /// Insert a message
  Future<void> insertMessage(ChatMessage message, {int? index}) async {
    if (index != null) {
      _messages.insert(index, message);
    } else {
      _messages.add(message);
    }
    _messagesController.add(_messages);
  }

  /// Insert multiple messages
  Future<void> insertAllMessages(List<ChatMessage> messages, {int? index}) async {
    if (index != null) {
      _messages.insertAll(index, messages);
    } else {
      _messages.addAll(messages);
    }
    _messagesController.add(_messages);
  }

  /// Update a message
  Future<void> updateMessage(ChatMessage oldMessage, ChatMessage newMessage) async {
    final index = _messages.indexWhere((m) => m.id == oldMessage.id);
    if (index != -1) {
      _messages[index] = newMessage;
      _messagesController.add(_messages);
    }
  }

  /// Remove a message
  Future<void> removeMessage(ChatMessage message) async {
    _messages.removeWhere((m) => m.id == message.id);
    _messagesController.add(_messages);
  }

  /// Set all messages (replace)
  Future<void> setMessages(List<ChatMessage> messages) async {
    _messages.clear();
    _messages.addAll(messages);
    _messagesController.add(_messages);
  }

  /// Clear all messages
  void clear() {
    _messages.clear();
    _messagesController.add(_messages);
  }

  /// Dispose controller
  void dispose() {
    _messagesController.close();
  }
}
