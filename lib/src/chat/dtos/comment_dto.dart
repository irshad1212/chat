import 'package:chat/core/enums/message_status.dart';
import 'package:chat/src/chat/models/chat_message.dart';
import 'package:ulid/ulid.dart';

class CommentDto {
  final int postId;
  final int id;
  final String name;
  final String email;
  final String body;

  const CommentDto({
    required this.postId,
    required this.id,
    required this.name,
    required this.email,
    required this.body,
  });

  factory CommentDto.fromJson(Map<String, dynamic> json) {
    return CommentDto(
      postId: json['postId'] as int,
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      body: json['body'] as String,
    );
  }

  TextChatMessage toDomain({
    required String currentUserId,
    required bool isOther,
    String? authorIdOverride,
  }) {
    return TextChatMessage(
      id: Ulid().toString(),
      authorId: authorIdOverride ?? (isOther ? 'other_$id' : currentUserId),
      text: body,
      createdAt: DateTime.now(),
      status: MessageStatus.delivered,
    );
  }
}
