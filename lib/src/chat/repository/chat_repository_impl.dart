import 'package:chat/data/remote/endpoints.dart';
import 'package:chat/src/chat/dtos/comment_dto.dart';
import 'package:chat/src/chat/repository/chat_repository.dart';
import 'package:remote_client/remote_client.dart';

class ChatRepositoryImpl implements ChatRepository {
  final RemoteClient _remoteClient;

  ChatRepositoryImpl(this._remoteClient);

  @override
  Future<Either<Failure, CommentDto>> getRandomMessage(int id) async {
    final result = await _remoteClient.get<CommentDto>(
      '${Endpoints.getRandomMessage}/$id',
      fromJson: (json) => CommentDto.fromJson(json as Map<String, dynamic>),
    );

    return result.fold((failure) => Left(failure), (response) => Right(response.data!));
  }
}
