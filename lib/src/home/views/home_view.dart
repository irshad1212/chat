import 'package:chat/core/theme/colors.dart';
import 'package:chat/src/home/views/widgets/user_list.dart';
import 'package:chat/src/shared/widgets/view_state_builder.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:chat/src/home/notifiers/home_notifier.dart';
import 'package:chat/src/home/views/widgets/history_list.dart';
import 'package:chat/src/home/views/widgets/home_app_bar.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _appBarAnimController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeNotifierProvider.notifier).getData();
    });
    _init();
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(homeNotifierProvider.select((s) => s.isAppBarVisible), (prev, next) {
      if (next) {
        _appBarAnimController.forward();
      } else {
        _appBarAnimController.reverse();
      }
    });

    final currentIndex = ref.watch(homeNotifierProvider.select((s) => s.tabIndex));
    final userListState = ref.watch(homeNotifierProvider.select((s) => s.userListState));
    final historyListState = ref.watch(homeNotifierProvider.select((s) => s.historyListState));

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            HomeAppBar(animationController: _appBarAnimController, tabController: _tabController),
            Expanded(
              child: Stack(
                children: [
                  AnimatedOpacity(
                    opacity: currentIndex == 0 ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: IgnorePointer(
                      ignoring: currentIndex != 0,
                      child: ViewStateBuilder(
                        loaderState: userListState,
                        onLoading: const Center(child: CircularProgressIndicator()),
                        onError: (failure) => Center(child: Text('Error: ${failure.message}')),
                        onSuccess: (data) => RefreshIndicator(
                          color: AppColors.primaryBlue,
                          elevation: 0.1,
                          onRefresh: () async {
                            await ref.read(homeNotifierProvider.notifier).getData(refresh: true);
                          },
                          child: UserList(scrollController: _scrollController, list: data),
                        ),
                      ),
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: currentIndex == 1 ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: IgnorePointer(
                      ignoring: currentIndex != 1,
                      child: ViewStateBuilder(
                        loaderState: historyListState,
                        onLoading: const Center(child: CircularProgressIndicator()),
                        onError: (failure) => Center(child: Text('Error: ${failure.message}')),
                        onSuccess: (data) => RefreshIndicator(
                          color: AppColors.primaryBlue,
                          elevation: 0.1,
                          onRefresh: () async {
                            await ref.read(homeNotifierProvider.notifier).getData(refresh: true);
                          },
                          child: HistoryList(list: data),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _init() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
    _appBarAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: 1.0,
    );
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final currentIndex = ref.read(homeNotifierProvider).tabIndex;
    if (currentIndex != 0) return;

    final isAppBarVisible = ref.read(homeNotifierProvider).isAppBarVisible;

    if (_scrollController.position.userScrollDirection == .reverse) {
      if (isAppBarVisible) {
        ref.read(homeNotifierProvider.notifier).setAppBarVisibility(false);
      }
    } else if (_scrollController.position.userScrollDirection == .forward) {
      if (!isAppBarVisible) {
        ref.read(homeNotifierProvider.notifier).setAppBarVisibility(true);
      }
    }
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging ||
        _tabController.index != ref.read(homeNotifierProvider).tabIndex) {
      ref.read(homeNotifierProvider.notifier).setTabIndex(_tabController.index);
    }
  }

  void _dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _appBarAnimController.dispose();
    _scrollController.dispose();
  }
}
