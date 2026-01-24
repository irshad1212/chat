import 'dart:math';

import 'package:chat/src/home/models/chat_tile_model.dart';
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

  /// Adds a random user with online status at position 0.
  /// Returns the generated username for snackbar display.
  String addRandomUser() {
    final random = Random();
    final firstNames = [
      'John',
      'Jane',
      'Alex',
      'Emma',
      'Liam',
      'Olivia',
      'Noah',
      'Sophia',
      'Lucas',
      'Mia',
    ];
    final lastNames = [
      'Smith',
      'Johnson',
      'Williams',
      'Brown',
      'Jones',
      'Davis',
      'Miller',
      'Wilson',
      'Moore',
      'Taylor',
    ];

    final firstName = firstNames[random.nextInt(firstNames.length)];
    final lastName = lastNames[random.nextInt(lastNames.length)];
    final fullName = '$firstName $lastName';
    final userId = 'user_${DateTime.now().millisecondsSinceEpoch}';

    final newUser = UserTileModel(userId: userId, fullName: fullName, isOnline: true);

    // Get current list and insert at position 0
    final currentState = state.userListState;
    if (currentState is Success<List<UserTileModel>>) {
      final List<UserTileModel> updatedList = [newUser, ...currentState.data ?? []];
      state = state.copyWith(userListState: LoaderState.success(data: updatedList));
    } else {
      // If list wasn't loaded yet, create new list with just this user
      state = state.copyWith(userListState: LoaderState.success(data: [newUser]));
    }

    return fullName;
  }
}
