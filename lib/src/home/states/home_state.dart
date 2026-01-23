import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

@freezed
sealed class HomeState with _$HomeState {
  const factory HomeState({@Default(0) int tabIndex, @Default(true) bool isAppBarVisible}) =
      _HomeState;

  factory HomeState.initial() => const HomeState();
}
