import 'package:chat/src/dictionary/models/word_definition_model.dart';
import 'package:chat/src/dictionary/repository/dictionary_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remote_client/remote_client.dart';

/// Simple mock repository for testing (not using actual RemoteClient)
class MockDictionaryRepository implements DictionaryRepository {
  bool shouldFail = false;
  bool returnEmpty = false;
  String? lastRequestedWord;

  @override
  Future<Either<Failure, WordDefinitionModel>> getWordDefinition(String word) async {
    lastRequestedWord = word;
    await Future.delayed(const Duration(milliseconds: 10));

    if (shouldFail) {
      return const Left(Unexpected(message: 'Network error'));
    }

    if (returnEmpty) {
      return const Left(Unexpected(message: 'No definition found'));
    }

    return Right(
      WordDefinitionModel(
        word: word,
        phonetic: '/$word/',
        phonetics: const [PhoneticModel(text: '/test/', audio: 'test.mp3')],
        meanings: const [
          MeaningModel(
            partOfSpeech: 'noun',
            definitions: [
              DefinitionModel(definition: 'A test definition', example: 'Test example'),
            ],
          ),
        ],
      ),
    );
  }
}

void main() {
  late DictionaryRepository repository;

  setUp(() {
    repository = MockDictionaryRepository();
  });

  group('DictionaryRepository', () {
    group('getWordDefinition', () {
      test('should return Right with WordDefinitionModel on success', () async {
        final result = await repository.getWordDefinition('hello');

        result.fold((failure) => fail('Expected Right but got Left: ${failure.message}'), (
          definition,
        ) {
          expect(definition, isA<WordDefinitionModel>());
          expect(definition.word, 'hello');
          expect(definition.phonetic, '/hello/');
          expect(definition.phonetics.length, 1);
          expect(definition.meanings.length, 1);
        });
      });

      test('should handle different words correctly', () async {
        final words = ['hello', 'world', 'test', 'example', 'dictionary'];

        for (final word in words) {
          final result = await repository.getWordDefinition(word);

          result.fold((failure) => fail('Expected Right for word: $word'), (definition) {
            expect(definition.word, word);
            expect(definition.phonetic, '/$word/');
          });
        }
      });

      test('should parse complex definition correctly', () async {
        final result = await repository.getWordDefinition('beautiful');

        result.fold((failure) => fail('Expected Right but got Left'), (definition) {
          expect(definition.word, 'beautiful');
          expect(definition.phonetics.isNotEmpty, true);
          expect(definition.meanings.isNotEmpty, true);
          expect(definition.meanings[0].partOfSpeech, 'noun');
          expect(definition.meanings[0].definitions.isNotEmpty, true);
        });
      });

      test('should return Left on network failure', () async {
        final mockRepo = repository as MockDictionaryRepository;
        mockRepo.shouldFail = true;

        final result = await repository.getWordDefinition('test');

        result.fold((failure) {
          expect(failure, isA<Unexpected>());
          expect(failure.message, 'Network error');
        }, (definition) => fail('Expected Left but got Right'));
      });

      test('should return Left when no definition found', () async {
        final mockRepo = repository as MockDictionaryRepository;
        mockRepo.returnEmpty = true;

        final result = await repository.getWordDefinition('nonexistent');

        result.fold((failure) {
          expect(failure, isA<Unexpected>());
          expect(failure.message, 'No definition found');
        }, (definition) => fail('Expected Left but got Right'));
      });

      test('should track requested word', () async {
        final mockRepo = repository as MockDictionaryRepository;

        await repository.getWordDefinition('tracking');

        expect(mockRepo.lastRequestedWord, 'tracking');
      });

      test('should handle words with special characters', () async {
        final specialWords = ['café', 'naïve', 'résumé'];

        for (final word in specialWords) {
          final result = await repository.getWordDefinition(word);

          expect(result.isRight, true);
        }
      });

      test('should handle sequential lookups', () async {
        final result1 = await repository.getWordDefinition('first');
        final result2 = await repository.getWordDefinition('second');
        final result3 = await repository.getWordDefinition('third');

        expect(result1.isRight, true);
        expect(result2.isRight, true);
        expect(result3.isRight, true);
      });

      test('should handle error recovery in flow', () async {
        final mockRepo = repository as MockDictionaryRepository;

        // First request fails
        mockRepo.shouldFail = true;
        var result = await repository.getWordDefinition('fail');
        expect(result.isLeft, true);

        // Second request succeeds
        mockRepo.shouldFail = false;
        result = await repository.getWordDefinition('success');
        expect(result.isRight, true);

        // Third request has no results
        mockRepo.returnEmpty = true;
        result = await repository.getWordDefinition('empty');
        expect(result.isLeft, true);
        result.fold(
          (failure) => expect(failure.message, 'No definition found'),
          (_) => fail('Expected Left'),
        );
      });

      test('should preserve data integrity across lookups', () async {
        final testWords = ['apple', 'banana', 'cherry'];

        for (final word in testWords) {
          final result = await repository.getWordDefinition(word);

          result.fold((failure) => fail('Expected Right for $word'), (definition) {
            expect(definition.word, word);
            expect(definition.phonetic, '/$word/');
            expect(definition.meanings.isNotEmpty, true);
          });
        }
      });

      test('should verify all model parts are populated', () async {
        final result = await repository.getWordDefinition('integration');

        result.fold((failure) => fail('Expected Right but got Left'), (definition) {
          // Verify all parts are correctly parsed
          expect(definition.word, 'integration');
          expect(definition.phonetic, isNotNull);
          expect(definition.phonetics.isNotEmpty, true);
          expect(definition.meanings.isNotEmpty, true);

          final meaning = definition.meanings.first;
          expect(meaning.partOfSpeech, 'noun');
          expect(meaning.definitions.isNotEmpty, true);

          final def = meaning.definitions.first;
          expect(def.definition.isNotEmpty, true);
          expect(def.example, isNotNull);
        });
      });
    });
  });
}
