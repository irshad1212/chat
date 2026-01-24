import 'package:chat/src/dictionary/models/word_definition_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WordDefinitionModel', () {
    group('fromJson', () {
      test('should parse complete JSON correctly', () {
        final json = {
          'word': 'hello',
          'phonetic': '/həˈloʊ/',
          'phonetics': [
            {'text': '/həˈloʊ/', 'audio': 'https://example.com/hello.mp3'},
            {'text': '/heˈloʊ/', 'audio': ''},
          ],
          'meanings': [
            {
              'partOfSpeech': 'noun',
              'definitions': [
                {
                  'definition': 'A greeting',
                  'example': 'He said hello',
                  'synonyms': ['greeting', 'hi'],
                  'antonyms': ['goodbye'],
                },
              ],
              'synonyms': ['greeting'],
              'antonyms': [],
            },
          ],
        };

        final model = WordDefinitionModel.fromJson(json);

        expect(model.word, 'hello');
        expect(model.phonetic, '/həˈloʊ/');
        expect(model.phonetics.length, 2);
        expect(model.meanings.length, 1);
      });

      test('should handle missing optional fields', () {
        final json = {'word': 'test'};

        final model = WordDefinitionModel.fromJson(json);

        expect(model.word, 'test');
        expect(model.phonetic, isNull);
        expect(model.phonetics, isEmpty);
        expect(model.meanings, isEmpty);
      });

      test('should default to empty string for missing word', () {
        final json = <String, dynamic>{};

        final model = WordDefinitionModel.fromJson(json);

        expect(model.word, '');
      });

      test('should parse multiple phonetics', () {
        final json = {
          'word': 'example',
          'phonetics': [
            {'text': '/ɪɡˈzæmpəl/', 'audio': 'url1.mp3'},
            {'text': '/egˈzampəl/', 'audio': 'url2.mp3'},
            {'text': '/ɛɡˈzæmpəl/', 'audio': ''},
          ],
        };

        final model = WordDefinitionModel.fromJson(json);

        expect(model.phonetics.length, 3);
        expect(model.phonetics[0].text, '/ɪɡˈzæmpəl/');
        expect(model.phonetics[0].audio, 'url1.mp3');
        expect(model.phonetics[2].audio, '');
      });

      test('should parse multiple meanings', () {
        final json = {
          'word': 'run',
          'meanings': [
            {
              'partOfSpeech': 'verb',
              'definitions': [
                {'definition': 'To move quickly'},
              ],
            },
            {
              'partOfSpeech': 'noun',
              'definitions': [
                {'definition': 'An act of running'},
              ],
            },
          ],
        };

        final model = WordDefinitionModel.fromJson(json);

        expect(model.meanings.length, 2);
        expect(model.meanings[0].partOfSpeech, 'verb');
        expect(model.meanings[1].partOfSpeech, 'noun');
      });
    });
  });

  group('PhoneticModel', () {
    group('fromJson', () {
      test('should parse with both fields', () {
        final json = {'text': '/test/', 'audio': 'https://example.com/test.mp3'};

        final model = PhoneticModel.fromJson(json);

        expect(model.text, '/test/');
        expect(model.audio, 'https://example.com/test.mp3');
      });

      test('should handle null values', () {
        final json = <String, dynamic>{};

        final model = PhoneticModel.fromJson(json);

        expect(model.text, isNull);
        expect(model.audio, isNull);
      });

      test('should handle empty audio string', () {
        final json = {'text': '/test/', 'audio': ''};

        final model = PhoneticModel.fromJson(json);

        expect(model.audio, '');
      });
    });
  });

  group('MeaningModel', () {
    group('fromJson', () {
      test('should parse complete meaning', () {
        final json = {
          'partOfSpeech': 'adjective',
          'definitions': [
            {
              'definition': 'Having a pleasant taste',
              'example': 'This cake is delicious',
              'synonyms': ['tasty', 'yummy'],
              'antonyms': ['disgusting'],
            },
          ],
          'synonyms': ['tasty'],
          'antonyms': ['nasty'],
        };

        final model = MeaningModel.fromJson(json);

        expect(model.partOfSpeech, 'adjective');
        expect(model.definitions.length, 1);
        expect(model.synonyms, ['tasty']);
        expect(model.antonyms, ['nasty']);
      });

      test('should default to empty string for missing partOfSpeech', () {
        final json = <String, dynamic>{};

        final model = MeaningModel.fromJson(json);

        expect(model.partOfSpeech, '');
        expect(model.definitions, isEmpty);
        expect(model.synonyms, isEmpty);
        expect(model.antonyms, isEmpty);
      });

      test('should parse multiple definitions', () {
        final json = {
          'partOfSpeech': 'noun',
          'definitions': [
            {'definition': 'First meaning'},
            {'definition': 'Second meaning'},
            {'definition': 'Third meaning'},
          ],
        };

        final model = MeaningModel.fromJson(json);

        expect(model.definitions.length, 3);
        expect(model.definitions[0].definition, 'First meaning');
        expect(model.definitions[2].definition, 'Third meaning');
      });

      test('should parse synonyms and antonyms lists', () {
        final json = {
          'partOfSpeech': 'verb',
          'synonyms': ['start', 'commence', 'initiate'],
          'antonyms': ['end', 'finish', 'conclude'],
        };

        final model = MeaningModel.fromJson(json);

        expect(model.synonyms.length, 3);
        expect(model.antonyms.length, 3);
        expect(model.synonyms.contains('commence'), true);
        expect(model.antonyms.contains('finish'), true);
      });
    });
  });

  group('DefinitionModel', () {
    group('fromJson', () {
      test('should parse complete definition', () {
        final json = {
          'definition': 'The state of being happy',
          'example': 'Her happiness was evident',
          'synonyms': ['joy', 'contentment'],
          'antonyms': ['sadness', 'misery'],
        };

        final model = DefinitionModel.fromJson(json);

        expect(model.definition, 'The state of being happy');
        expect(model.example, 'Her happiness was evident');
        expect(model.synonyms, ['joy', 'contentment']);
        expect(model.antonyms, ['sadness', 'misery']);
      });

      test('should default to empty string for missing definition', () {
        final json = <String, dynamic>{};

        final model = DefinitionModel.fromJson(json);

        expect(model.definition, '');
        expect(model.example, isNull);
        expect(model.synonyms, isEmpty);
        expect(model.antonyms, isEmpty);
      });

      test('should handle null example', () {
        final json = {'definition': 'Test definition'};

        final model = DefinitionModel.fromJson(json);

        expect(model.definition, 'Test definition');
        expect(model.example, isNull);
      });

      test('should handle empty synonym and antonym lists', () {
        final json = {'definition': 'Test', 'synonyms': <dynamic>[], 'antonyms': <dynamic>[]};

        final model = DefinitionModel.fromJson(json);

        expect(model.synonyms, isEmpty);
        expect(model.antonyms, isEmpty);
      });

      test('should parse long definition text', () {
        final longDefinition =
            'This is a very long definition that contains '
            'multiple sentences and explains the word in great detail. '
            'It may include technical terminology and various examples.';

        final json = {'definition': longDefinition, 'example': 'An example sentence.'};

        final model = DefinitionModel.fromJson(json);

        expect(model.definition, longDefinition);
        expect(model.example, 'An example sentence.');
      });
    });
  });

  group('Nested JSON parsing integration', () {
    test('should parse complex nested structure', () {
      final json = {
        'word': 'beautiful',
        'phonetic': '/ˈbjuːtɪf(ə)l/',
        'phonetics': [
          {'text': '/ˈbjuːtɪf(ə)l/', 'audio': 'beautiful_uk.mp3'},
          {'text': '/ˈbjutəfəl/', 'audio': 'beautiful_us.mp3'},
        ],
        'meanings': [
          {
            'partOfSpeech': 'adjective',
            'definitions': [
              {
                'definition': 'Pleasing the senses or mind aesthetically',
                'example': 'Beautiful poetry',
                'synonyms': ['attractive', 'pretty', 'lovely'],
                'antonyms': ['ugly', 'unattractive'],
              },
              {
                'definition': 'Of a very high standard; excellent',
                'example': 'Beautiful timing',
                'synonyms': ['excellent', 'perfect'],
                'antonyms': ['poor', 'bad'],
              },
            ],
            'synonyms': ['gorgeous', 'stunning'],
            'antonyms': ['hideous'],
          },
        ],
      };

      final model = WordDefinitionModel.fromJson(json);

      expect(model.word, 'beautiful');
      expect(model.phonetic, '/ˈbjuːtɪf(ə)l/');
      expect(model.phonetics.length, 2);
      expect(model.meanings.length, 1);
      expect(model.meanings[0].definitions.length, 2);
      expect(model.meanings[0].definitions[0].synonyms.length, 3);
      expect(model.meanings[0].definitions[1].example, 'Beautiful timing');
    });

    test('should handle API response with null nested arrays', () {
      final json = {'word': 'test', 'phonetics': null, 'meanings': null};

      final model = WordDefinitionModel.fromJson(json);

      expect(model.word, 'test');
      expect(model.phonetics, isEmpty);
      expect(model.meanings, isEmpty);
    });
  });
}
