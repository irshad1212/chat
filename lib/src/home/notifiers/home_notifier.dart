import 'package:chat/src/home/repository/home_repository.dart';
import 'package:chat/src/home/repository/home_repository_provider.dart';
import 'package:chat/src/home/states/home_state.dart';
import 'package:chat/utils/helpers/loader_state.dart';
import 'package:flutter/rendering.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_notifier.g.dart';

@Riverpod(keepAlive: true)
class HomeNotifier extends _$HomeNotifier {
  late final HomeRepository _repository;

  @override
  HomeState build() {
    _repository = ref.read(homeRepoProvider);
    return HomeState.initial();
  }

  Future<void> getData({bool refresh = false}) async {
    await _loadData(refresh: refresh);
  }

  Future<void> _loadData({bool refresh = false}) async {
    if (!refresh && (state.userListState is Success || state.historyListState is Success)) {
      return;
    }

    if (!refresh) {
      state = state.copyWith(
        userListState: const LoaderState.loading(),
        historyListState: const LoaderState.loading(),
      );
    }

    final userResult = await _repository.getUserList();
    userResult.fold(
      (l) => state = state.copyWith(userListState: LoaderState.loadError(l)),
      (r) => state = state.copyWith(userListState: LoaderState.success(data: r)),
    );

    final historyResult = await _repository.getMessageList();
    historyResult.fold(
      (l) => state = state.copyWith(historyListState: LoaderState.loadError(l)),
      (r) => state = state.copyWith(historyListState: LoaderState.success(data: r)),
    );
  }

  void setTabIndex(int index) {
    state = state.copyWith(tabIndex: index);
    if (index == 1) {
      setAppBarVisibility(true);
    }
  }

  void setAppBarVisibility(bool visible) {
    state = state.copyWith(isAppBarVisible: visible);
  }

  /// Handles scroll direction changes for app bar visibility.
  /// This method encapsulates the business logic that was previously in the view.
  void handleScroll(ScrollDirection direction) {
    if (state.tabIndex != 0) return;

    if (direction == ScrollDirection.reverse && state.isAppBarVisible) {
      setAppBarVisibility(false);
    } else if (direction == ScrollDirection.forward && !state.isAppBarVisible) {
      setAppBarVisibility(true);
    }
  }
}
