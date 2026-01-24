import 'package:chat/src/dictionary/models/word_definition_model.dart';
import 'package:remote_client/remote_client.dart';

abstract class DictionaryRepository {
  Future<Either<Failure, WordDefinitionModel>> getWordDefinition(String word);
}
