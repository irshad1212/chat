import 'package:chat/core/enums/chat_tile_type.dart';
import 'package:chat/src/home/models/chat_tile_args.dart';

class ChatTileDto {
  final String type;
  final String id;
  final String? fullName;
  final bool? isOnline;
  final String? lastSeen;
  final String? lastMessage;
  final String? lastMessageTime;
  final int? unreadCount;

  const ChatTileDto({
    required this.type,
    required this.id,
    this.fullName,
    this.isOnline,
    this.lastSeen,
    this.lastMessage,
    this.lastMessageTime,
    this.unreadCount,
  });

  factory ChatTileDto.fromJson(Map<String, dynamic> json) {
    return ChatTileDto(
      type: json['type'] as String,
      id: json['id'] as String,
      fullName: json['full_name'] as String?,
      isOnline: json['is_online'] as bool?,
      lastSeen: json['last_seen'] as String?,
      lastMessage: json['last_message'] as String?,
      lastMessageTime: json['last_message_time'] as String?,
      unreadCount: json['unread_count'] as int?,
    );
  }

  ChatTileArgs toDomain() {
    return ChatTileArgs(
      type: ChatTileType.values.firstWhere((e) => e.name == type, orElse: () => ChatTileType.user),
      userId: id,
      fullName: fullName,
      isOnline: isOnline,
      lastSeen: lastSeen != null ? DateTime.tryParse(lastSeen!) : null,
      lastMessage: lastMessage,
      lastMessageTime: lastMessageTime != null ? DateTime.tryParse(lastMessageTime!) : null,
      unreadCount: unreadCount,
    );
  }
}
