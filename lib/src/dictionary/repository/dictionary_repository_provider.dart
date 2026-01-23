import 'package:chat/data/remote/remote_service.dart';
import 'package:chat/src/dictionary/repository/dictionary_repository.dart';
import 'package:chat/src/dictionary/repository/dictionary_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dictionary_repository_provider.g.dart';

@riverpod
DictionaryRepository dictionaryRepository(DictionaryRepositoryRef ref) {
  final remoteClient = ref.watch(dictionaryRemoteClientProvider);
  return DictionaryRepositoryImpl(remoteClient);
}
