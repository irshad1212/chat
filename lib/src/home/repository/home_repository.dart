import 'package:chat/src/home/models/chat_tile_model.dart';
import 'package:remote_client/remote_client.dart';

/// Repository interface for home data operations.
/// Uses typed return values for type safety (ISP compliance).
abstract class HomeRepository {
  Future<Either<Failure, List<UserTileModel>>> getUserList();

  Future<Either<Failure, List<HistoryTileModel>>> getMessageList();
}
