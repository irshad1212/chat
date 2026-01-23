import 'package:chat/data/remote/remote_service.dart';
import 'package:chat/src/chat/repository/chat_repository.dart';
import 'package:chat/src/chat/repository/chat_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_repository_provider.g.dart';

@riverpod
ChatRepository chatRepository(ChatRepositoryRef ref) {
  final remoteClient = ref.watch(chatRemoteClientProvider);
  return ChatRepositoryImpl(remoteClient);
}
