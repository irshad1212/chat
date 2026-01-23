import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:remote_client/remote_client.dart';

part 'loader_state.freezed.dart';

@freezed
class LoaderState<T> with _$LoaderState<T> {
  const factory LoaderState.initial() = Initial<T>;
  const factory LoaderState.loading() = Loading<T>;
  const factory LoaderState.success({T? data}) = Success<T>;
  const factory LoaderState.loadError(Failure failure) = LoadError<T>;
}
