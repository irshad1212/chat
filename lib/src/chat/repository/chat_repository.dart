import 'package:chat/src/chat/dtos/comment_dto.dart';
import 'package:remote_client/remote_client.dart';

abstract class ChatRepository {
  Future<Either<Failure, CommentDto>> getRandomMessage(int id);
}
