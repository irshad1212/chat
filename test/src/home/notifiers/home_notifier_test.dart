import 'package:chat/src/home/models/chat_tile_model.dart';
import 'package:chat/src/home/notifiers/home_notifier.dart';
import 'package:chat/src/home/repository/home_repository.dart';
import 'package:chat/src/home/repository/home_repository_provider.dart';
import 'package:chat/utils/helpers/loader_state.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remote_client/remote_client.dart';

/// Mock repository for testing
class MockHomeRepository implements HomeRepository {
  bool shouldFail = false;
  int getUserListCallCount = 0;
  int getMessageListCallCount = 0;

  @override
  Future<Either<Failure, List<UserTileModel>>> getUserList() async {
    getUserListCallCount++;
    if (shouldFail) {
      return const Left(Unexpected(message: 'Test error'));
    }
    return const Right([
      UserTileModel(userId: '1', fullName: 'Test User', isOnline: true),
      UserTileModel(userId: '2', fullName: 'Another User', isOnline: false),
    ]);
  }

  @override
  Future<Either<Failure, List<HistoryTileModel>>> getMessageList() async {
    getMessageListCallCount++;
    if (shouldFail) {
      return const Left(Unexpected(message: 'Test error'));
    }
    return Right([
      HistoryTileModel(
        userId: '101',
        fullName: 'Test User',
        lastMessage: 'Hello',
        lastMessageTime: DateTime.now(),
        unreadCount: 5,
      ),
    ]);
  }
}

/// Test notifier class that extends HomeNotifier for testing
class TestHomeRepo extends HomeRepo {
  final MockHomeRepository mockRepository;

  TestHomeRepo(this.mockRepository);

  @override
  HomeRepository build() {
    return mockRepository;
  }
}

void main() {
  late ProviderContainer container;
  late MockHomeRepository mockRepository;

  setUp(() {
    mockRepository = MockHomeRepository();
    container = ProviderContainer(
      overrides: [homeRepoProvider.overrideWith(() => TestHomeRepo(mockRepository))],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('HomeNotifier', () {
    group('initial state', () {
      test('should have initial state', () {
        final state = container.read(homeNotifierProvider);

        expect(state.tabIndex, 0);
        expect(state.isAppBarVisible, true);
        expect(state.userListState, isA<Initial>());
        expect(state.historyListState, isA<Initial>());
      });
    });

    group('getData', () {
      test('should set success state with data on successful load', () async {
        final notifier = container.read(homeNotifierProvider.notifier);

        await notifier.getData();

        final state = container.read(homeNotifierProvider);
        expect(state.userListState, isA<Success<List<UserTileModel>>>());
        expect(state.historyListState, isA<Success<List<HistoryTileModel>>>());

        final users = (state.userListState as Success<List<UserTileModel>>).data;
        expect(users!.length, 2);
        expect(users.first.fullName, 'Test User');
      });

      test('should set error state on failure', () async {
        mockRepository.shouldFail = true;
        final notifier = container.read(homeNotifierProvider.notifier);

        await notifier.getData();

        final state = container.read(homeNotifierProvider);
        expect(state.userListState, isA<LoadError>());
        expect(state.historyListState, isA<LoadError>());
      });

      test('should not reload if already loaded (without refresh)', () async {
        final notifier = container.read(homeNotifierProvider.notifier);

        await notifier.getData();
        await notifier.getData();

        expect(mockRepository.getUserListCallCount, 1);
        expect(mockRepository.getMessageListCallCount, 1);
      });

      test('should reload when refresh is true', () async {
        final notifier = container.read(homeNotifierProvider.notifier);

        await notifier.getData();
        await notifier.getData(refresh: true);

        expect(mockRepository.getUserListCallCount, 2);
        expect(mockRepository.getMessageListCallCount, 2);
      });
    });

    group('setTabIndex', () {
      test('should update tab index', () {
        final notifier = container.read(homeNotifierProvider.notifier);

        notifier.setTabIndex(1);

        final state = container.read(homeNotifierProvider);
        expect(state.tabIndex, 1);
      });

      test('should set appBar visible when switching to tab 1', () {
        final notifier = container.read(homeNotifierProvider.notifier);
        notifier.setAppBarVisibility(false);

        notifier.setTabIndex(1);

        final state = container.read(homeNotifierProvider);
        expect(state.isAppBarVisible, true);
      });

      test('should not change appBar visibility when switching to tab 0', () {
        final notifier = container.read(homeNotifierProvider.notifier);
        notifier.setAppBarVisibility(false);

        notifier.setTabIndex(0);

        final state = container.read(homeNotifierProvider);
        expect(state.isAppBarVisible, false);
      });
    });

    group('setAppBarVisibility', () {
      test('should set appBar visible to true', () {
        final notifier = container.read(homeNotifierProvider.notifier);

        notifier.setAppBarVisibility(true);

        final state = container.read(homeNotifierProvider);
        expect(state.isAppBarVisible, true);
      });

      test('should set appBar visible to false', () {
        final notifier = container.read(homeNotifierProvider.notifier);

        notifier.setAppBarVisibility(false);

        final state = container.read(homeNotifierProvider);
        expect(state.isAppBarVisible, false);
      });
    });

    group('handleScroll', () {
      test('should hide appBar on reverse scroll when on tab 0', () {
        final notifier = container.read(homeNotifierProvider.notifier);
        notifier.setTabIndex(0);
        notifier.setAppBarVisibility(true);

        notifier.handleScroll(ScrollDirection.reverse);

        final state = container.read(homeNotifierProvider);
        expect(state.isAppBarVisible, false);
      });

      test('should show appBar on forward scroll when on tab 0', () {
        final notifier = container.read(homeNotifierProvider.notifier);
        notifier.setTabIndex(0);
        notifier.setAppBarVisibility(false);

        notifier.handleScroll(ScrollDirection.forward);

        final state = container.read(homeNotifierProvider);
        expect(state.isAppBarVisible, true);
      });

      test('should not change appBar visibility when on tab 1', () {
        final notifier = container.read(homeNotifierProvider.notifier);
        notifier.setTabIndex(1);
        notifier.setAppBarVisibility(true);

        notifier.handleScroll(ScrollDirection.reverse);

        final state = container.read(homeNotifierProvider);
        expect(state.isAppBarVisible, true);
      });

      test('should not change visibility if already hidden on reverse scroll', () {
        final notifier = container.read(homeNotifierProvider.notifier);
        notifier.setTabIndex(0);
        notifier.setAppBarVisibility(false);

        notifier.handleScroll(ScrollDirection.reverse);

        final state = container.read(homeNotifierProvider);
        expect(state.isAppBarVisible, false);
      });

      test('should not change visibility if already visible on forward scroll', () {
        final notifier = container.read(homeNotifierProvider.notifier);
        notifier.setTabIndex(0);
        notifier.setAppBarVisibility(true);

        notifier.handleScroll(ScrollDirection.forward);

        final state = container.read(homeNotifierProvider);
        expect(state.isAppBarVisible, true);
      });

      test('should handle idle scroll direction', () {
        final notifier = container.read(homeNotifierProvider.notifier);
        notifier.setTabIndex(0);
        notifier.setAppBarVisibility(true);

        notifier.handleScroll(ScrollDirection.idle);

        final state = container.read(homeNotifierProvider);
        expect(state.isAppBarVisible, true);
      });
    });
  });
}
