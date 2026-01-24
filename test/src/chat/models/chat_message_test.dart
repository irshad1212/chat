import 'package:chat/core/enums/message_status.dart';
import 'package:chat/src/chat/models/chat_message.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChatMessage', () {
    group('TextChatMessage', () {
      test('should create TextChatMessage with required fields', () {
        final message = TextChatMessage(id: 'msg_001', authorId: 'user_123', text: 'Hello, World!');

        expect(message.id, 'msg_001');
        expect(message.authorId, 'user_123');
        expect(message.text, 'Hello, World!');
        expect(message.createdAt, isNull);
        expect(message.status, isNull);
        expect(message.metadata, isNull);
      });

      test('should create TextChatMessage with all fields', () {
        final createdAt = DateTime(2026, 1, 23, 12, 30);
        final metadata = {'key': 'value', 'count': 42};

        final message = TextChatMessage(
          id: 'msg_002',
          authorId: 'user_456',
          text: 'Complete message',
          createdAt: createdAt,
          status: MessageStatus.delivered,
          metadata: metadata,
        );

        expect(message.id, 'msg_002');
        expect(message.authorId, 'user_456');
        expect(message.text, 'Complete message');
        expect(message.createdAt, createdAt);
        expect(message.status, MessageStatus.delivered);
        expect(message.metadata, metadata);
      });

      test('should be a subtype of ChatMessage', () {
        const message = TextChatMessage(id: 'msg_001', authorId: 'user_123', text: 'Test');

        expect(message, isA<ChatMessage>());
      });

      test('should support all MessageStatus values', () {
        const sending = TextChatMessage(
          id: '1',
          authorId: 'user',
          text: 'Test',
          status: MessageStatus.sending,
        );
        const sent = TextChatMessage(
          id: '2',
          authorId: 'user',
          text: 'Test',
          status: MessageStatus.sent,
        );
        const delivered = TextChatMessage(
          id: '3',
          authorId: 'user',
          text: 'Test',
          status: MessageStatus.delivered,
        );
        const read = TextChatMessage(
          id: '4',
          authorId: 'user',
          text: 'Test',
          status: MessageStatus.seen,
        );
        const error = TextChatMessage(
          id: '5',
          authorId: 'user',
          text: 'Test',
          status: MessageStatus.error,
        );

        expect(sending.status, MessageStatus.sending);
        expect(sent.status, MessageStatus.sent);
        expect(delivered.status, MessageStatus.delivered);
        expect(read.status, MessageStatus.seen);
        expect(error.status, MessageStatus.error);
      });
    });

    group('TextChatMessage.copyWith', () {
      test('should create copy with updated text', () {
        const original = TextChatMessage(
          id: 'msg_001',
          authorId: 'user_123',
          text: 'Original text',
        );

        final updated = original.copyWith(text: 'Updated text');

        expect(updated.id, 'msg_001');
        expect(updated.authorId, 'user_123');
        expect(updated.text, 'Updated text');
      });

      test('should create copy with updated status', () {
        const original = TextChatMessage(
          id: 'msg_001',
          authorId: 'user_123',
          text: 'Hello',
          status: MessageStatus.sending,
        );

        final updated = original.copyWith(status: MessageStatus.delivered);

        expect(updated.status, MessageStatus.delivered);
        expect(updated.text, 'Hello');
      });

      test('should create copy with all fields updated', () {
        final originalDate = DateTime(2026, 1, 23, 10, 0);
        final newDate = DateTime(2026, 1, 23, 11, 0);
        final originalMetadata = {'original': true};
        final newMetadata = {'updated': true};

        final original = TextChatMessage(
          id: 'msg_001',
          authorId: 'user_123',
          text: 'Original',
          createdAt: originalDate,
          status: MessageStatus.sending,
          metadata: originalMetadata,
        );

        final updated = original.copyWith(
          id: 'msg_002',
          authorId: 'user_456',
          text: 'Updated',
          createdAt: newDate,
          status: MessageStatus.delivered,
          metadata: newMetadata,
        );

        expect(updated.id, 'msg_002');
        expect(updated.authorId, 'user_456');
        expect(updated.text, 'Updated');
        expect(updated.createdAt, newDate);
        expect(updated.status, MessageStatus.delivered);
        expect(updated.metadata, newMetadata);
      });

      test('should keep original values when not specified', () {
        final createdAt = DateTime(2026, 1, 23, 12, 30);
        final metadata = {'key': 'value'};

        final original = TextChatMessage(
          id: 'msg_001',
          authorId: 'user_123',
          text: 'Original',
          createdAt: createdAt,
          status: MessageStatus.sent,
          metadata: metadata,
        );

        final updated = original.copyWith(text: 'Updated');

        expect(updated.id, 'msg_001');
        expect(updated.authorId, 'user_123');
        expect(updated.createdAt, createdAt);
        expect(updated.status, MessageStatus.sent);
        expect(updated.metadata, metadata);
      });

      test('should create identical copy when no parameters provided', () {
        final createdAt = DateTime(2026, 1, 23, 12, 30);
        final original = TextChatMessage(
          id: 'msg_001',
          authorId: 'user_123',
          text: 'Original',
          createdAt: createdAt,
          status: MessageStatus.delivered,
        );

        final copy = original.copyWith();

        expect(copy.id, original.id);
        expect(copy.authorId, original.authorId);
        expect(copy.text, original.text);
        expect(copy.createdAt, original.createdAt);
        expect(copy.status, original.status);
      });
    });
  });
}
