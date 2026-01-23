import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:remote_client/remote_client.dart';

import 'package:chat/data/remote/endpoints.dart';

part 'remote_service.g.dart';

@riverpod
RemoteClient chatRemoteClient(Ref ref) {
  return RemoteClientFactory.create(
    baseUrl: Endpoints.chatBaseUrl,
    enableLogging: true,
    responseParser: const DirectResponseParser(),
  );
}

@riverpod
RemoteClient dictionaryRemoteClient(Ref ref) {
  return RemoteClientFactory.create(baseUrl: Endpoints.dictionaryBaseUrl, enableLogging: true);
}
