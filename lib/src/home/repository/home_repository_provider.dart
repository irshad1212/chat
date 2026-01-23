import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:chat/src/home/repository/home_repository.dart';
import 'package:chat/src/home/repository/home_repository_impl.dart';

part 'home_repository_provider.g.dart';

@riverpod
class HomeRepo extends _$HomeRepo {
  @override
  HomeRepository build() {
    return HomeRepositoryImpl();
  }
}
