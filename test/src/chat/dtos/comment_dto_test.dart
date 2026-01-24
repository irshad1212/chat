import 'package:chat/core/enums/message_status.dart';
import 'package:chat/src/chat/dtos/comment_dto.dart';
import 'package:chat/src/chat/models/chat_message.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CommentDto', () {
    group('fromJson', () {
      test('should parse from JSON correctly', () {
        final json = {
          'postId': 1,
          'id': 101,
          'name': 'Test Comment',
          'email': 'test@example.com',
          'body': 'This is a comment body',
        };

        final dto = CommentDto.fromJson(json);

        expect(dto.postId, 1);
        expect(dto.id, 101);
        expect(dto.name, 'Test Comment');
        expect(dto.email, 'test@example.com');
        expect(dto.body, 'This is a comment body');
      });

      test('should parse multiple different comments', () {
        final json1 = {
          'postId': 5,
          'id': 25,
          'name': 'First Comment',
          'email': 'user1@example.com',
          'body': 'First body',
        };

        final json2 = {
          'postId': 10,
          'id': 50,
          'name': 'Second Comment',
          'email': 'user2@example.com',
          'body': 'Second body',
        };

        final dto1 = CommentDto.fromJson(json1);
        final dto2 = CommentDto.fromJson(json2);

        expect(dto1.postId, 5);
        expect(dto1.id, 25);
        expect(dto2.postId, 10);
        expect(dto2.id, 50);
      });
    });

    group('toDomain', () {
      test('should convert to TextChatMessage for current user', () {
        const dto = CommentDto(
          postId: 1,
          id: 101,
          name: 'Test',
          email: 'test@example.com',
          body: 'Hello, World!',
        );

        final message = dto.toDomain(currentUserId: 'user_123', isOther: false);

        expect(message, isA<TextChatMessage>());
        expect(message.text, 'Hello, World!');
        expect(message.authorId, 'user_123');
        expect(message.status, MessageStatus.delivered);
        expect(message.createdAt, isNotNull);
        expect(message.id.isNotEmpty, true);
      });

      test('should convert to TextChatMessage for other user', () {
        const dto = CommentDto(
          postId: 1,
          id: 101,
          name: 'Other User',
          email: 'other@example.com',
          body: 'Reply message',
        );

        final message = dto.toDomain(currentUserId: 'user_123', isOther: true);

        expect(message, isA<TextChatMessage>());
        expect(message.text, 'Reply message');
        expect(message.authorId, 'other_101');
        expect(message.status, MessageStatus.delivered);
      });

      test('should use authorIdOverride when provided', () {
        const dto = CommentDto(
          postId: 1,
          id: 101,
          name: 'Test',
          email: 'test@example.com',
          body: 'Test message',
        );

        final message = dto.toDomain(
          currentUserId: 'user_123',
          isOther: false,
          authorIdOverride: 'custom_author_456',
        );

        expect(message.authorId, 'custom_author_456');
      });

      test('should generate unique IDs for each message', () {
        const dto = CommentDto(
          postId: 1,
          id: 101,
          name: 'Test',
          email: 'test@example.com',
          body: 'Test message',
        );

        final message1 = dto.toDomain(currentUserId: 'user_123', isOther: false);
        final message2 = dto.toDomain(currentUserId: 'user_123', isOther: false);

        expect(message1.id, isNot(message2.id));
        expect(message1.id.isNotEmpty, true);
        expect(message2.id.isNotEmpty, true);
      });

      test('should handle different comment IDs for other users', () {
        const dto1 = CommentDto(
          postId: 1,
          id: 101,
          name: 'User A',
          email: 'a@example.com',
          body: 'Message A',
        );

        const dto2 = CommentDto(
          postId: 1,
          id: 202,
          name: 'User B',
          email: 'b@example.com',
          body: 'Message B',
        );

        final message1 = dto1.toDomain(currentUserId: 'me', isOther: true);
        final message2 = dto2.toDomain(currentUserId: 'me', isOther: true);

        expect(message1.authorId, 'other_101');
        expect(message2.authorId, 'other_202');
      });

      test('should always set status to delivered', () {
        const dto = CommentDto(
          postId: 1,
          id: 101,
          name: 'Test',
          email: 'test@example.com',
          body: 'Test',
        );

        final messageOwn = dto.toDomain(currentUserId: 'user', isOther: false);
        final messageOther = dto.toDomain(currentUserId: 'user', isOther: true);
        final messageOverride = dto.toDomain(
          currentUserId: 'user',
          isOther: false,
          authorIdOverride: 'custom',
        );

        expect(messageOwn.status, MessageStatus.delivered);
        expect(messageOther.status, MessageStatus.delivered);
        expect(messageOverride.status, MessageStatus.delivered);
      });

      test('should preserve full body text', () {
        const longBody =
            'This is a very long message with multiple sentences. '
            'It contains various punctuation marks! And questions? '
            'Even some special characters: @#\$%^&*()';

        const dto = CommentDto(
          postId: 1,
          id: 101,
          name: 'Test',
          email: 'test@example.com',
          body: longBody,
        );

        final message = dto.toDomain(currentUserId: 'user', isOther: false);

        expect(message.text, longBody);
      });
    });
  });
}
