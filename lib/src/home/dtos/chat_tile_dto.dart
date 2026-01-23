import 'package:chat/src/home/models/chat_tile_model.dart';

/// DTO for user tile data from API.
class UserTileDto {
  final String id;
  final String? fullName;
  final bool? isOnline;
  final String? lastSeen;

  const UserTileDto({required this.id, this.fullName, this.isOnline, this.lastSeen});

  factory UserTileDto.fromJson(Map<String, dynamic> json) {
    return UserTileDto(
      id: json['id'] as String,
      fullName: json['full_name'] as String?,
      isOnline: json['is_online'] as bool?,
      lastSeen: json['last_seen'] as String?,
    );
  }

  UserTileModel toDomain() {
    return UserTileModel(
      userId: id,
      fullName: fullName,
      isOnline: isOnline ?? false,
      lastSeen: lastSeen != null ? DateTime.tryParse(lastSeen!) : null,
    );
  }
}

/// DTO for history tile data from API.
class HistoryTileDto {
  final String id;
  final String? fullName;
  final String? lastMessage;
  final String? lastMessageTime;
  final int? unreadCount;

  const HistoryTileDto({
    required this.id,
    this.fullName,
    this.lastMessage,
    this.lastMessageTime,
    this.unreadCount,
  });

  factory HistoryTileDto.fromJson(Map<String, dynamic> json) {
    return HistoryTileDto(
      id: json['id'] as String,
      fullName: json['full_name'] as String?,
      lastMessage: json['last_message'] as String?,
      lastMessageTime: json['last_message_time'] as String?,
      unreadCount: json['unread_count'] as int?,
    );
  }

  HistoryTileModel toDomain() {
    return HistoryTileModel(
      userId: id,
      fullName: fullName,
      lastMessage: lastMessage ?? '',
      lastMessageTime: lastMessageTime != null
          ? DateTime.tryParse(lastMessageTime!) ?? DateTime.now()
          : DateTime.now(),
      unreadCount: unreadCount ?? 0,
    );
  }
}
