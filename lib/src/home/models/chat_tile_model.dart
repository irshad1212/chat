/// Base sealed class for chat tile models.
/// Using sealed class enables exhaustive pattern matching and proper ISP compliance.
sealed class ChatTileModel {
  const ChatTileModel({required this.userId, this.fullName});

  final String userId;
  final String? fullName;
}

/// Model representing a user tile in the users list.
class UserTileModel extends ChatTileModel {
  const UserTileModel({
    required super.userId,
    super.fullName,
    required this.isOnline,
    this.lastSeen,
  });

  final bool isOnline;
  final DateTime? lastSeen;
}

/// Model representing a chat history tile.
class HistoryTileModel extends ChatTileModel {
  const HistoryTileModel({
    required super.userId,
    super.fullName,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
  });

  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
}
