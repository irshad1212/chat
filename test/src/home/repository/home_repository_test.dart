import 'package:chat/src/home/models/chat_tile_model.dart';
import 'package:chat/src/home/repository/home_repository.dart';
import 'package:chat/src/home/repository/home_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late HomeRepository repository;

  setUp(() {
    repository = HomeRepositoryImpl();
  });

  group('HomeRepositoryImpl', () {
    group('getUserList', () {
      test('should return Right with list of UserTileModel on success', () async {
        final result = await repository.getUserList();

        result.fold((failure) => fail('Expected Right but got Left: ${failure.message}'), (users) {
          expect(users, isA<List<UserTileModel>>());
          expect(users.length, 20);
        });
      });

      test('should return users with correct data', () async {
        final result = await repository.getUserList();

        result.fold((failure) => fail('Expected Right but got Left'), (users) {
          final alice = users.first;
          expect(alice.userId, '1');
          expect(alice.fullName, 'Alice Johnson');
          expect(alice.isOnline, true);
        });
      });

      test('should return users with online and offline status', () async {
        final result = await repository.getUserList();

        result.fold((failure) => fail('Expected Right but got Left'), (users) {
          final onlineUsers = users.where((u) => u.isOnline).toList();
          final offlineUsers = users.where((u) => !u.isOnline).toList();

          expect(onlineUsers.isNotEmpty, true);
          expect(offlineUsers.isNotEmpty, true);
        });
      });

      test('should parse lastSeen for offline users', () async {
        final result = await repository.getUserList();

        result.fold((failure) => fail('Expected Right but got Left'), (users) {
          final bob = users.firstWhere((u) => u.fullName == 'Bob Smith');
          expect(bob.isOnline, false);
          expect(bob.lastSeen, isNotNull);
        });
      });
    });

    group('getMessageList', () {
      test('should return Right with list of HistoryTileModel on success', () async {
        final result = await repository.getMessageList();

        result.fold((failure) => fail('Expected Right but got Left: ${failure.message}'), (
          history,
        ) {
          expect(history, isA<List<HistoryTileModel>>());
          expect(history.length, 20);
        });
      });

      test('should return history with correct data', () async {
        final result = await repository.getMessageList();

        result.fold((failure) => fail('Expected Right but got Left'), (history) {
          final alice = history.first;
          expect(alice.userId, '101');
          expect(alice.fullName, 'Alice Johnson');
          expect(alice.lastMessage, 'See you tomorrow!');
          expect(alice.unreadCount, 6);
        });
      });

      test('should return history with unread counts', () async {
        final result = await repository.getMessageList();

        result.fold((failure) => fail('Expected Right but got Left'), (history) {
          final withUnread = history.where((h) => h.unreadCount > 0).toList();
          final withoutUnread = history.where((h) => h.unreadCount == 0).toList();

          expect(withUnread.isNotEmpty, true);
          expect(withoutUnread.isNotEmpty, true);
        });
      });

      test('should parse lastMessageTime correctly', () async {
        final result = await repository.getMessageList();

        result.fold((failure) => fail('Expected Right but got Left'), (history) {
          final alice = history.first;
          expect(alice.lastMessageTime.year, 2026);
          expect(alice.lastMessageTime.month, 1);
        });
      });
    });
  });
}
