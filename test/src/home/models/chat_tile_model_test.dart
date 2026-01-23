import 'package:chat/src/home/models/chat_tile_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChatTileModel', () {
    group('UserTileModel', () {
      test('should create UserTileModel with required fields', () {
        const model = UserTileModel(userId: '1', fullName: 'Alice Johnson', isOnline: true);

        expect(model.userId, '1');
        expect(model.fullName, 'Alice Johnson');
        expect(model.isOnline, true);
        expect(model.lastSeen, isNull);
      });

      test('should create UserTileModel with all fields', () {
        final lastSeen = DateTime(2026, 1, 23, 10, 30);
        final model = UserTileModel(
          userId: '2',
          fullName: 'Bob Smith',
          isOnline: false,
          lastSeen: lastSeen,
        );

        expect(model.userId, '2');
        expect(model.fullName, 'Bob Smith');
        expect(model.isOnline, false);
        expect(model.lastSeen, lastSeen);
      });

      test('should be a subtype of ChatTileModel', () {
        const model = UserTileModel(userId: '1', fullName: 'Test User', isOnline: true);

        expect(model, isA<ChatTileModel>());
      });

      test('should allow null fullName', () {
        const model = UserTileModel(userId: '1', isOnline: true);

        expect(model.fullName, isNull);
      });
    });

    group('HistoryTileModel', () {
      test('should create HistoryTileModel with required fields', () {
        final lastMessageTime = DateTime(2026, 1, 23, 12, 30);
        final model = HistoryTileModel(
          userId: '101',
          fullName: 'Alice Johnson',
          lastMessage: 'See you tomorrow!',
          lastMessageTime: lastMessageTime,
          unreadCount: 6,
        );

        expect(model.userId, '101');
        expect(model.fullName, 'Alice Johnson');
        expect(model.lastMessage, 'See you tomorrow!');
        expect(model.lastMessageTime, lastMessageTime);
        expect(model.unreadCount, 6);
      });

      test('should be a subtype of ChatTileModel', () {
        final model = HistoryTileModel(
          userId: '101',
          fullName: 'Test User',
          lastMessage: 'Hello',
          lastMessageTime: DateTime.now(),
          unreadCount: 0,
        );

        expect(model, isA<ChatTileModel>());
      });

      test('should handle zero unread count', () {
        final model = HistoryTileModel(
          userId: '101',
          fullName: 'Test User',
          lastMessage: 'Message',
          lastMessageTime: DateTime.now(),
          unreadCount: 0,
        );

        expect(model.unreadCount, 0);
      });

      test('should allow null fullName', () {
        final model = HistoryTileModel(
          userId: '101',
          lastMessage: 'Message',
          lastMessageTime: DateTime.now(),
          unreadCount: 0,
        );

        expect(model.fullName, isNull);
      });
    });

    group('Sealed class pattern matching', () {
      test('should exhaustively match UserTileModel', () {
        const ChatTileModel model = UserTileModel(userId: '1', fullName: 'Test', isOnline: true);

        final result = switch (model) {
          UserTileModel user => 'user: ${user.isOnline}',
          HistoryTileModel history => 'history: ${history.lastMessage}',
        };

        expect(result, 'user: true');
      });

      test('should exhaustively match HistoryTileModel', () {
        final ChatTileModel model = HistoryTileModel(
          userId: '101',
          fullName: 'Test',
          lastMessage: 'Hello',
          lastMessageTime: DateTime.now(),
          unreadCount: 5,
        );

        final result = switch (model) {
          UserTileModel user => 'user: ${user.isOnline}',
          HistoryTileModel history => 'history: ${history.lastMessage}',
        };

        expect(result, 'history: Hello');
      });
    });
  });
}
