import 'package:chat/data/remote/endpoints.dart';
import 'package:chat/src/dictionary/models/word_definition_model.dart';
import 'package:chat/src/dictionary/repository/dictionary_repository.dart';
import 'package:remote_client/remote_client.dart';

class DictionaryRepositoryImpl implements DictionaryRepository {
  final RemoteClient _remoteClient;

  DictionaryRepositoryImpl(this._remoteClient);

  @override
  Future<Either<Failure, WordDefinitionModel>> getWordDefinition(String word) async {
    final result = await _remoteClient.get<List<WordDefinitionModel>>(
      '${Endpoints.getWordDefinition}/$word',
      fromJson: (json) {
        if (json is List<dynamic> && json.isNotEmpty) {
          return json.map((e) => WordDefinitionModel.fromJson(e as Map<String, dynamic>)).toList();
        }
        return <WordDefinitionModel>[];
      },
    );

    return result.fold((failure) => Left(failure), (response) {
      final definitions = response.data;
      if (definitions != null && definitions.isNotEmpty) {
        return Right(definitions.first);
      }
      return const Left(Unexpected(message: 'No definition found'));
    });
  }
}
