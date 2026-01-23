// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$HomeState {
  int get tabIndex => throw _privateConstructorUsedError;
  bool get isAppBarVisible => throw _privateConstructorUsedError;
  LoaderState<List<UserTileModel>> get userListState =>
      throw _privateConstructorUsedError;
  LoaderState<List<HistoryTileModel>> get historyListState =>
      throw _privateConstructorUsedError;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HomeStateCopyWith<HomeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeStateCopyWith<$Res> {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) then) =
      _$HomeStateCopyWithImpl<$Res, HomeState>;
  @useResult
  $Res call({
    int tabIndex,
    bool isAppBarVisible,
    LoaderState<List<UserTileModel>> userListState,
    LoaderState<List<HistoryTileModel>> historyListState,
  });

  $LoaderStateCopyWith<List<UserTileModel>, $Res> get userListState;
  $LoaderStateCopyWith<List<HistoryTileModel>, $Res> get historyListState;
}

/// @nodoc
class _$HomeStateCopyWithImpl<$Res, $Val extends HomeState>
    implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tabIndex = null,
    Object? isAppBarVisible = null,
    Object? userListState = null,
    Object? historyListState = null,
  }) {
    return _then(
      _value.copyWith(
            tabIndex: null == tabIndex
                ? _value.tabIndex
                : tabIndex // ignore: cast_nullable_to_non_nullable
                      as int,
            isAppBarVisible: null == isAppBarVisible
                ? _value.isAppBarVisible
                : isAppBarVisible // ignore: cast_nullable_to_non_nullable
                      as bool,
            userListState: null == userListState
                ? _value.userListState
                : userListState // ignore: cast_nullable_to_non_nullable
                      as LoaderState<List<UserTileModel>>,
            historyListState: null == historyListState
                ? _value.historyListState
                : historyListState // ignore: cast_nullable_to_non_nullable
                      as LoaderState<List<HistoryTileModel>>,
          )
          as $Val,
    );
  }

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LoaderStateCopyWith<List<UserTileModel>, $Res> get userListState {
    return $LoaderStateCopyWith<List<UserTileModel>, $Res>(
      _value.userListState,
      (value) {
        return _then(_value.copyWith(userListState: value) as $Val);
      },
    );
  }

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LoaderStateCopyWith<List<HistoryTileModel>, $Res> get historyListState {
    return $LoaderStateCopyWith<List<HistoryTileModel>, $Res>(
      _value.historyListState,
      (value) {
        return _then(_value.copyWith(historyListState: value) as $Val);
      },
    );
  }
}

/// @nodoc
abstract class _$$HomeStateImplCopyWith<$Res>
    implements $HomeStateCopyWith<$Res> {
  factory _$$HomeStateImplCopyWith(
    _$HomeStateImpl value,
    $Res Function(_$HomeStateImpl) then,
  ) = __$$HomeStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int tabIndex,
    bool isAppBarVisible,
    LoaderState<List<UserTileModel>> userListState,
    LoaderState<List<HistoryTileModel>> historyListState,
  });

  @override
  $LoaderStateCopyWith<List<UserTileModel>, $Res> get userListState;
  @override
  $LoaderStateCopyWith<List<HistoryTileModel>, $Res> get historyListState;
}

/// @nodoc
class __$$HomeStateImplCopyWithImpl<$Res>
    extends _$HomeStateCopyWithImpl<$Res, _$HomeStateImpl>
    implements _$$HomeStateImplCopyWith<$Res> {
  __$$HomeStateImplCopyWithImpl(
    _$HomeStateImpl _value,
    $Res Function(_$HomeStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tabIndex = null,
    Object? isAppBarVisible = null,
    Object? userListState = null,
    Object? historyListState = null,
  }) {
    return _then(
      _$HomeStateImpl(
        tabIndex: null == tabIndex
            ? _value.tabIndex
            : tabIndex // ignore: cast_nullable_to_non_nullable
                  as int,
        isAppBarVisible: null == isAppBarVisible
            ? _value.isAppBarVisible
            : isAppBarVisible // ignore: cast_nullable_to_non_nullable
                  as bool,
        userListState: null == userListState
            ? _value.userListState
            : userListState // ignore: cast_nullable_to_non_nullable
                  as LoaderState<List<UserTileModel>>,
        historyListState: null == historyListState
            ? _value.historyListState
            : historyListState // ignore: cast_nullable_to_non_nullable
                  as LoaderState<List<HistoryTileModel>>,
      ),
    );
  }
}

/// @nodoc

class _$HomeStateImpl implements _HomeState {
  const _$HomeStateImpl({
    this.tabIndex = 0,
    this.isAppBarVisible = true,
    this.userListState = const LoaderState.initial(),
    this.historyListState = const LoaderState.initial(),
  });

  @override
  @JsonKey()
  final int tabIndex;
  @override
  @JsonKey()
  final bool isAppBarVisible;
  @override
  @JsonKey()
  final LoaderState<List<UserTileModel>> userListState;
  @override
  @JsonKey()
  final LoaderState<List<HistoryTileModel>> historyListState;

  @override
  String toString() {
    return 'HomeState(tabIndex: $tabIndex, isAppBarVisible: $isAppBarVisible, userListState: $userListState, historyListState: $historyListState)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeStateImpl &&
            (identical(other.tabIndex, tabIndex) ||
                other.tabIndex == tabIndex) &&
            (identical(other.isAppBarVisible, isAppBarVisible) ||
                other.isAppBarVisible == isAppBarVisible) &&
            (identical(other.userListState, userListState) ||
                other.userListState == userListState) &&
            (identical(other.historyListState, historyListState) ||
                other.historyListState == historyListState));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    tabIndex,
    isAppBarVisible,
    userListState,
    historyListState,
  );

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeStateImplCopyWith<_$HomeStateImpl> get copyWith =>
      __$$HomeStateImplCopyWithImpl<_$HomeStateImpl>(this, _$identity);
}

abstract class _HomeState implements HomeState {
  const factory _HomeState({
    final int tabIndex,
    final bool isAppBarVisible,
    final LoaderState<List<UserTileModel>> userListState,
    final LoaderState<List<HistoryTileModel>> historyListState,
  }) = _$HomeStateImpl;

  @override
  int get tabIndex;
  @override
  bool get isAppBarVisible;
  @override
  LoaderState<List<UserTileModel>> get userListState;
  @override
  LoaderState<List<HistoryTileModel>> get historyListState;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HomeStateImplCopyWith<_$HomeStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
