import 'package:remote_client/remote_client.dart';

abstract class HomeRepository {
  Future<Either<Failure, dynamic>> getUserList();

  Future<Either<Failure, dynamic>> getMessageList();
}
