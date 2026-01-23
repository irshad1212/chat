import 'dart:convert';

import 'package:chat/src/home/dtos/chat_tile_dto.dart';
import 'package:chat/src/home/models/chat_tile_model.dart';
import 'package:chat/src/home/repository/home_repository.dart';
import 'package:remote_client/remote_client.dart';

class HomeRepositoryImpl implements HomeRepository {
  @override
  Future<Either<Failure, List<HistoryTileModel>>> getMessageList() async {
    await Future.delayed(const Duration(seconds: 2));
    try {
      final List<dynamic> jsonList = jsonDecode(_mockChatHistoryData);
      final List<HistoryTileModel> list = jsonList
          .map((e) => HistoryTileDto.fromJson(e).toDomain())
          .toList();
      return Right(list);
    } catch (e) {
      return Left(Unexpected(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<UserTileModel>>> getUserList() async {
    await Future.delayed(const Duration(seconds: 2));
    try {
      final List<dynamic> jsonList = jsonDecode(_mockUserData);
      final List<UserTileModel> list = jsonList
          .map((e) => UserTileDto.fromJson(e).toDomain())
          .toList();
      return Right(list);
    } catch (e) {
      return Left(Unexpected(message: e.toString()));
    }
  }

  static const String _mockUserData = '''
  [
    {"type": "user", "id": "1", "full_name": "Alice Johnson", "is_online": true},
    {"type": "user", "id": "2", "full_name": "Bob Smith", "is_online": false, "last_seen": "2026-01-22T14:30:00Z"},
    {"type": "user", "id": "3", "full_name": "Charlie Brown", "is_online": true},
    {"type": "user", "id": "4", "full_name": "David Wilson", "is_online": false, "last_seen": "2026-01-21T09:15:00Z"},
    {"type": "user", "id": "5", "full_name": "Eva Martinez", "is_online": true},
    {"type": "user", "id": "6", "full_name": "Frank Thomas", "is_online": false, "last_seen": "2026-01-20T18:45:00Z"},
    {"type": "user", "id": "7", "full_name": "Grace Lee", "is_online": true},
    {"type": "user", "id": "8", "full_name": "Henry White", "is_online": false, "last_seen": "2026-01-19T11:20:00Z"},
    {"type": "user", "id": "9", "full_name": "Isabella Clark", "is_online": true},
    {"type": "user", "id": "10", "full_name": "Jack Hall", "is_online": false, "last_seen": "2026-01-23T08:00:00Z"},
    {"type": "user", "id": "11", "full_name": "Karen Young", "is_online": true},
    {"type": "user", "id": "12", "full_name": "Liam Scott", "is_online": false, "last_seen": "2026-01-22T16:10:00Z"},
    {"type": "user", "id": "13", "full_name": "Mia King", "is_online": true},
    {"type": "user", "id": "14", "full_name": "Noah Wright", "is_online": false, "last_seen": "2026-01-21T13:40:00Z"},
    {"type": "user", "id": "15", "full_name": "Olivia Lopez", "is_online": true},
    {"type": "user", "id": "16", "full_name": "Paul Hill", "is_online": false, "last_seen": "2026-01-20T10:05:00Z"},
    {"type": "user", "id": "17", "full_name": "Quinn Green", "is_online": true},
    {"type": "user", "id": "18", "full_name": "Ryan Adams", "is_online": false, "last_seen": "2026-01-19T15:55:00Z"},
    {"type": "user", "id": "19", "full_name": "Sophia Baker", "is_online": true},
    {"type": "user", "id": "20", "full_name": "Thomas Gonzalez", "is_online": false, "last_seen": "2026-01-23T12:00:00Z"}
  ]
  ''';

  static const String _mockChatHistoryData = '''
  [
    {"type": "history", "id": "101", "full_name": "Alice Johnson", "last_message": "See you tomorrow!", "last_message_time": "2026-01-23T12:30:00Z", "unread_count": 6},
    {"type": "history", "id": "102", "full_name": "Bob Smith", "last_message": "Can you check the report?", "last_message_time": "2026-01-23T11:15:00Z", "unread_count": 3},
    {"type": "history", "id": "103", "full_name": "Charlie Brown", "last_message": "Lunch at 1?", "last_message_time": "2026-01-23T10:00:00Z", "unread_count": 5},
    {"type": "history", "id": "104", "full_name": "David Wilson", "last_message": "Thanks for the help.", "last_message_time": "2026-01-22T18:45:00Z", "unread_count": 0},
    {"type": "history", "id": "105", "full_name": "Eva Martinez", "last_message": "Are we still on for the meeting?", "last_message_time": "2026-01-22T16:20:00Z", "unread_count": 3},
    {"type": "history", "id": "106", "full_name": "Frank Thomas", "last_message": "Just sent the files.", "last_message_time": "2026-01-22T14:10:00Z", "unread_count": 0},
    {"type": "history", "id": "107", "full_name": "Grace Lee", "last_message": "Happy Birthday!", "last_message_time": "2026-01-21T20:00:00Z", "unread_count": 0},
    {"type": "history", "id": "108", "full_name": "Henry White", "last_message": "Call me when you're free.", "last_message_time": "2026-01-21T17:30:00Z", "unread_count": 5},
    {"type": "history", "id": "109", "full_name": "Isabella Clark", "last_message": "That sounds great.", "last_message_time": "2026-01-21T15:00:00Z", "unread_count": 0},
    {"type": "history", "id": "110", "full_name": "Jack Hall", "last_message": "Did you get my email?", "last_message_time": "2026-01-20T19:40:00Z", "unread_count": 1},
    {"type": "history", "id": "111", "full_name": "Karen Young", "last_message": "Let's catch up soon.", "last_message_time": "2026-01-20T12:15:00Z", "unread_count": 0},
    {"type": "history", "id": "112", "full_name": "Liam Scott", "last_message": "I'll be there in 5.", "last_message_time": "2026-01-20T10:00:00Z", "unread_count": 0},
    {"type": "history", "id": "113", "full_name": "Mia King", "last_message": "What do you think?", "last_message_time": "2026-01-19T21:25:00Z", "unread_count": 2},
    {"type": "history", "id": "114", "full_name": "Noah Wright", "last_message": "Don't forget the keys.", "last_message_time": "2026-01-19T18:50:00Z", "unread_count": 0},
    {"type": "history", "id": "115", "full_name": "Olivia Lopez", "last_message": "See you next week.", "last_message_time": "2026-01-19T16:10:00Z", "unread_count": 0},
    {"type": "history", "id": "116", "full_name": "Paul Hill", "last_message": "Ok, got it.", "last_message_time": "2026-01-19T14:30:00Z", "unread_count": 1},
    {"type": "history", "id": "117", "full_name": "Quinn Green", "last_message": "How was your trip?", "last_message_time": "2026-01-19T11:45:00Z", "unread_count": 0},
    {"type": "history", "id": "118", "full_name": "Ryan Adams", "last_message": "Please confirm.", "last_message_time": "2026-01-19T09:20:00Z", "unread_count": 4},
    {"type": "history", "id": "119", "full_name": "Sophia Baker", "last_message": "I'll handle it.", "last_message_time": "2026-01-18T20:15:00Z", "unread_count": 0},
    {"type": "history", "id": "120", "full_name": "Thomas Gonzalez", "last_message": "Good night.", "last_message_time": "2026-01-18T22:50:00Z", "unread_count": 0}
  ]
  ''';
}
