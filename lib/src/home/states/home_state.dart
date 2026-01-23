import 'package:chat/src/home/models/chat_tile_args.dart';
import 'package:chat/utils/helpers/loader_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

@freezed
sealed class HomeState with _$HomeState {
  const factory HomeState({
    @Default(0) int tabIndex,
    @Default(true) bool isAppBarVisible,
    @Default(LoaderState.initial()) LoaderState<List<ChatTileArgs>> userListState,
    @Default(LoaderState.initial()) LoaderState<List<ChatTileArgs>> historyListState,
  }) = _HomeState;

  factory HomeState.initial() => const HomeState();
}
