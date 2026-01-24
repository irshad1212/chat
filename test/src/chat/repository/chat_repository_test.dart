import 'package:chat/src/chat/dtos/comment_dto.dart';
import 'package:chat/src/chat/repository/chat_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remote_client/remote_client.dart';

/// Simple mock repository for testing (not using actual RemoteClient)
class MockChatRepository implements ChatRepository {
  bool shouldFail = false;
  int? lastRequestedId;

  @override
  Future<Either<Failure, CommentDto>> getRandomMessage(int id) async {
    lastRequestedId = id;
    await Future.delayed(const Duration(milliseconds: 10));

    if (shouldFail) {
      return const Left(Unexpected(message: 'Network error'));
    }

    return Right(
      CommentDto(
        postId: 1,
        id: id,
        name: 'Test Comment',
        email: 'test@example.com',
        body: 'Test comment body for ID $id',
      ),
    );
  }
}

void main() {
  late ChatRepository repository;

  setUp(() {
    repository = MockChatRepository();
  });

  group('ChatRepository', () {
    group('getRandomMessage', () {
      test('should return Right with CommentDto on success', () async {
        final result = await repository.getRandomMessage(42);

        result.fold((failure) => fail('Expected Right but got Left: ${failure.message}'), (dto) {
          expect(dto, isA<CommentDto>());
          expect(dto.id, 42);
          expect(dto.name, 'Test Comment');
          expect(dto.email, 'test@example.com');
          expect(dto.body.contains('42'), true);
        });
      });

      test('should handle different request IDs correctly', () async {
        final ids = [1, 50, 100, 250, 500];

        for (final id in ids) {
          final result = await repository.getRandomMessage(id);

          result.fold((failure) => fail('Expected Right for ID $id'), (dto) {
            expect(dto.id, id);
            expect(dto.body.contains('$id'), true);
          });
        }
      });

      test('should return Left on failure', () async {
        final mockRepo = repository as MockChatRepository;
        mockRepo.shouldFail = true;

        final result = await repository.getRandomMessage(1);

        result.fold((failure) {
          expect(failure, isA<Unexpected>());
          expect(failure.message, 'Network error');
        }, (dto) => fail('Expected Left but got Right'));
      });

      test('should track requested ID', () async {
        final mockRepo = repository as MockChatRepository;

        await repository.getRandomMessage(99);

        expect(mockRepo.lastRequestedId, 99);
      });

      test('should handle sequential requests', () async {
        final result1 = await repository.getRandomMessage(1);
        final result2 = await repository.getRandomMessage(2);
        final result3 = await repository.getRandomMessage(3);

        expect(result1.isRight, true);
        expect(result2.isRight, true);
        expect(result3.isRight, true);
      });

      test('should handle error recovery', () async {
        final mockRepo = repository as MockChatRepository;

        mockRepo.shouldFail = true;
        final failResult = await repository.getRandomMessage(1);
        expect(failResult.isLeft, true);

        mockRepo.shouldFail = false;
        final successResult = await repository.getRandomMessage(2);
        expect(successResult.isRight, true);
      });

      test('should parse comment data correctly', () async {
        final result = await repository.getRandomMessage(123);

        result.fold((failure) => fail('Expected Right but got Left'), (dto) {
          expect(dto.postId, 1);
          expect(dto.id, 123);
          expect(dto.name.isNotEmpty, true);
          expect(dto.email.contains('@'), true);
          expect(dto.body.isNotEmpty, true);
        });
      });
    });
  });
}
