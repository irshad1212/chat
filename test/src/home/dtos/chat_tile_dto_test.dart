import 'package:chat/src/home/dtos/chat_tile_dto.dart';
import 'package:chat/src/home/models/chat_tile_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserTileDto', () {
    test('should parse from JSON correctly', () {
      final json = {'id': '1', 'full_name': 'Alice Johnson', 'is_online': true, 'last_seen': null};

      final dto = UserTileDto.fromJson(json);

      expect(dto.id, '1');
      expect(dto.fullName, 'Alice Johnson');
      expect(dto.isOnline, true);
      expect(dto.lastSeen, isNull);
    });

    test('should parse JSON with last_seen', () {
      final json = {
        'id': '2',
        'full_name': 'Bob Smith',
        'is_online': false,
        'last_seen': '2026-01-22T14:30:00Z',
      };

      final dto = UserTileDto.fromJson(json);

      expect(dto.id, '2');
      expect(dto.fullName, 'Bob Smith');
      expect(dto.isOnline, false);
      expect(dto.lastSeen, '2026-01-22T14:30:00Z');
    });

    test('should convert to domain model correctly', () {
      const dto = UserTileDto(id: '1', fullName: 'Alice Johnson', isOnline: true, lastSeen: null);

      final model = dto.toDomain();

      expect(model, isA<UserTileModel>());
      expect(model.userId, '1');
      expect(model.fullName, 'Alice Johnson');
      expect(model.isOnline, true);
      expect(model.lastSeen, isNull);
    });

    test('should parse lastSeen to DateTime', () {
      const dto = UserTileDto(
        id: '2',
        fullName: 'Bob Smith',
        isOnline: false,
        lastSeen: '2026-01-22T14:30:00Z',
      );

      final model = dto.toDomain();

      expect(model.lastSeen, isNotNull);
      expect(model.lastSeen!.year, 2026);
      expect(model.lastSeen!.month, 1);
      expect(model.lastSeen!.day, 22);
    });

    test('should default isOnline to false when null', () {
      const dto = UserTileDto(id: '1', fullName: 'Test', isOnline: null);

      final model = dto.toDomain();

      expect(model.isOnline, false);
    });
  });

  group('HistoryTileDto', () {
    test('should parse from JSON correctly', () {
      final json = {
        'id': '101',
        'full_name': 'Alice Johnson',
        'last_message': 'See you tomorrow!',
        'last_message_time': '2026-01-23T12:30:00Z',
        'unread_count': 6,
      };

      final dto = HistoryTileDto.fromJson(json);

      expect(dto.id, '101');
      expect(dto.fullName, 'Alice Johnson');
      expect(dto.lastMessage, 'See you tomorrow!');
      expect(dto.lastMessageTime, '2026-01-23T12:30:00Z');
      expect(dto.unreadCount, 6);
    });

    test('should convert to domain model correctly', () {
      const dto = HistoryTileDto(
        id: '101',
        fullName: 'Alice Johnson',
        lastMessage: 'See you tomorrow!',
        lastMessageTime: '2026-01-23T12:30:00Z',
        unreadCount: 6,
      );

      final model = dto.toDomain();

      expect(model, isA<HistoryTileModel>());
      expect(model.userId, '101');
      expect(model.fullName, 'Alice Johnson');
      expect(model.lastMessage, 'See you tomorrow!');
      expect(model.unreadCount, 6);
    });

    test('should parse lastMessageTime to DateTime', () {
      const dto = HistoryTileDto(
        id: '101',
        fullName: 'Test',
        lastMessage: 'Hello',
        lastMessageTime: '2026-01-23T12:30:00Z',
        unreadCount: 0,
      );

      final model = dto.toDomain();

      expect(model.lastMessageTime.year, 2026);
      expect(model.lastMessageTime.month, 1);
      expect(model.lastMessageTime.day, 23);
    });

    test('should default lastMessage to empty string when null', () {
      const dto = HistoryTileDto(
        id: '101',
        fullName: 'Test',
        lastMessage: null,
        lastMessageTime: '2026-01-23T12:30:00Z',
        unreadCount: 0,
      );

      final model = dto.toDomain();

      expect(model.lastMessage, '');
    });

    test('should default unreadCount to 0 when null', () {
      const dto = HistoryTileDto(
        id: '101',
        fullName: 'Test',
        lastMessage: 'Hello',
        lastMessageTime: '2026-01-23T12:30:00Z',
        unreadCount: null,
      );

      final model = dto.toDomain();

      expect(model.unreadCount, 0);
    });

    test('should handle null lastMessageTime with fallback', () {
      const dto = HistoryTileDto(
        id: '101',
        fullName: 'Test',
        lastMessage: 'Hello',
        lastMessageTime: null,
        unreadCount: 0,
      );

      final model = dto.toDomain();

      expect(model.lastMessageTime, isNotNull);
    });
  });
}
