import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:chat/src/home/states/home_state.dart';

part 'home_notifier.g.dart';

@riverpod
class HomeNotifier extends _$HomeNotifier {
  @override
  HomeState build() {
    return HomeState.initial();
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
}
