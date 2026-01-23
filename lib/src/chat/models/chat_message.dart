import 'package:chat/core/enums/message_status.dart';

/// Base message class
abstract class ChatMessage {
  final String id;
  final String authorId;
  final DateTime? createdAt;
  final MessageStatus? status;
  final Map<String, dynamic>? metadata;

  const ChatMessage({
    required this.id,
    required this.authorId,
    this.createdAt,
    this.status,
    this.metadata,
  });
}

/// Text message
class TextChatMessage extends ChatMessage {
  final String text;

  const TextChatMessage({
    required super.id,
    required super.authorId,
    required this.text,
    super.createdAt,
    super.status,
    super.metadata,
  });

  TextChatMessage copyWith({
    String? id,
    String? authorId,
    String? text,
    DateTime? createdAt,
    MessageStatus? status,
    Map<String, dynamic>? metadata,
  }) {
    return TextChatMessage(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      metadata: metadata ?? this.metadata,
    );
  }
}
