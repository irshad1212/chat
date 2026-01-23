import 'package:chat/core/enums/chat_tile_type.dart';

class ChatTileArgs {
  final ChatTileType type;

  final String? userId;

  final String? fullName;

  final bool? isOnline;

  final DateTime? lastSeen;

  final String? lastMessage;

  final DateTime? lastMessageTime;

  final int? unreadCount;

  const ChatTileArgs({
    required this.type,
    this.userId,
    this.fullName,
    this.isOnline,
    this.lastSeen,
    this.lastMessage,
    this.lastMessageTime,
    this.unreadCount,
  }) : assert(
         type != ChatTileType.user || (isOnline != null || lastSeen != null),
         'isOnline and lastSeen are required for ChatTileType.user',
       ),
       assert(
         type != ChatTileType.history ||
             (lastMessage != null && lastMessageTime != null && unreadCount != null),
         'lastMessage, lastMessageTime, and unreadCount are required for ChatTileType.history',
       );
}
