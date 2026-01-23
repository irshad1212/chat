import 'package:chat/src/home/models/chat_tile_model.dart';
import 'package:chat/src/home/notifiers/home_notifier.dart';
import 'package:chat/src/home/repository/home_repository.dart';
import 'package:chat/src/home/repository/home_repository_provider.dart';
import 'package:chat/utils/helpers/loader_state.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remote_client/remote_client.dart';

/// Mock repository implementation for success scenarios
class MockSuccessRepository implements HomeRepository {
  @override
  Future<Either<Failure, List<UserTileModel>>> getUserList() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return const Right([
      UserTileModel(userId: '1', fullName: 'User 1', isOnline: true),
      UserTileModel(userId: '2', fullName: 'User 2', isOnline: false),
      UserTileModel(userId: '3', fullName: 'User 3', isOnline: true),
    ]);
  }

  @override
  Future<Either<Failure, List<HistoryTileModel>>> getMessageList() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return Right([
      HistoryTileModel(
        userId: '101',
        fullName: 'User 1',
        lastMessage: 'Hello',
        lastMessageTime: DateTime(2026, 1, 23),
        unreadCount: 5,
      ),
      HistoryTileModel(
        userId: '102',
        fullName: 'User 2',
        lastMessage: 'Goodbye',
        lastMessageTime: DateTime(2026, 1, 22),
        unreadCount: 0,
      ),
    ]);
  }
}

/// Mock repository implementation for failure scenarios
class MockFailureRepository implements HomeRepository {
  @override
  Future<Either<Failure, List<UserTileModel>>> getUserList() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return const Left(Unexpected(message: 'Network error'));
  }

  @override
  Future<Either<Failure, List<HistoryTileModel>>> getMessageList() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return const Left(Unexpected(message: 'Network error'));
  }
}

/// Test provider for success scenarios
class TestSuccessHomeRepo extends HomeRepo {
  @override
  HomeRepository build() => MockSuccessRepository();
}

/// Test provider for failure scenarios
class TestFailureHomeRepo extends HomeRepo {
  @override
  HomeRepository build() => MockFailureRepository();
}

void main() {
  group('Home Module Integration Tests', () {
    group('Full data flow with success', () {
      late ProviderContainer container;

      setUp(() {
        container = ProviderContainer(
          overrides: [homeRepoProvider.overrideWith(TestSuccessHomeRepo.new)],
        );
      });

      tearDown(() {
        container.dispose();
      });

      test('should complete full data loading cycle', () async {
        // Initial state
        var state = container.read(homeNotifierProvider);
        expect(state.userListState, isA<Initial>());
        expect(state.historyListState, isA<Initial>());

        // Trigger data load
        final notifier = container.read(homeNotifierProvider.notifier);
        await notifier.getData();

        // Final state should have data
        state = container.read(homeNotifierProvider);
        expect(state.userListState, isA<Success<List<UserTileModel>>>());
        expect(state.historyListState, isA<Success<List<HistoryTileModel>>>());

        // Verify data content
        final users = (state.userListState as Success<List<UserTileModel>>).data!;
        final history = (state.historyListState as Success<List<HistoryTileModel>>).data!;

        expect(users.length, 3);
        expect(history.length, 2);
        expect(users.first.fullName, 'User 1');
        expect(history.first.lastMessage, 'Hello');
      });

      test('should properly handle tab switching and scroll interactions', () async {
        final notifier = container.read(homeNotifierProvider.notifier);
        await notifier.getData();

        // Start on tab 0
        var state = container.read(homeNotifierProvider);
        expect(state.tabIndex, 0);
        expect(state.isAppBarVisible, true);

        // Scroll down should hide app bar
        notifier.handleScroll(ScrollDirection.reverse);
        state = container.read(homeNotifierProvider);
        expect(state.isAppBarVisible, false);

        // Scroll up should show app bar
        notifier.handleScroll(ScrollDirection.forward);
        state = container.read(homeNotifierProvider);
        expect(state.isAppBarVisible, true);

        // Switch to tab 1 should keep app bar visible
        notifier.setTabIndex(1);
        state = container.read(homeNotifierProvider);
        expect(state.tabIndex, 1);
        expect(state.isAppBarVisible, true);

        // Scroll on tab 1 should not affect app bar
        notifier.handleScroll(ScrollDirection.reverse);
        state = container.read(homeNotifierProvider);
        expect(state.isAppBarVisible, true);
      });

      test('should handle refresh correctly', () async {
        final notifier = container.read(homeNotifierProvider.notifier);

        // First load
        await notifier.getData();
        var state = container.read(homeNotifierProvider);
        expect(state.userListState, isA<Success>());

        // Refresh should reload data
        await notifier.getData(refresh: true);
        state = container.read(homeNotifierProvider);
        expect(state.userListState, isA<Success>());
      });
    });

    group('Full data flow with failure', () {
      late ProviderContainer container;

      setUp(() {
        container = ProviderContainer(
          overrides: [homeRepoProvider.overrideWith(TestFailureHomeRepo.new)],
        );
      });

      tearDown(() {
        container.dispose();
      });

      test('should handle failure and set error state', () async {
        final notifier = container.read(homeNotifierProvider.notifier);
        await notifier.getData();

        final state = container.read(homeNotifierProvider);
        expect(state.userListState, isA<LoadError>());
        expect(state.historyListState, isA<LoadError>());

        final userError = (state.userListState as LoadError).failure;
        expect(userError.message, 'Network error');
      });
    });

    group('State consistency tests', () {
      late ProviderContainer container;

      setUp(() {
        container = ProviderContainer(
          overrides: [homeRepoProvider.overrideWith(TestSuccessHomeRepo.new)],
        );
      });

      tearDown(() {
        container.dispose();
      });

      test('should maintain state consistency across multiple operations', () async {
        final notifier = container.read(homeNotifierProvider.notifier);

        // Load data
        await notifier.getData();

        // Perform multiple operations
        notifier.setTabIndex(1);
        notifier.setAppBarVisibility(false);
        notifier.setTabIndex(0);
        notifier.handleScroll(ScrollDirection.reverse);

        final state = container.read(homeNotifierProvider);

        // Data should still be loaded
        expect(state.userListState, isA<Success>());
        expect(state.historyListState, isA<Success>());

        // UI state should reflect latest changes
        expect(state.tabIndex, 0);
        expect(state.isAppBarVisible, false);
      });

      test('should maintain keepAlive state', () async {
        final notifier = container.read(homeNotifierProvider.notifier);
        await notifier.getData();

        // Read state multiple times
        final state1 = container.read(homeNotifierProvider);
        final state2 = container.read(homeNotifierProvider);

        // States should be equivalent (keepAlive)
        expect(state1.tabIndex, state2.tabIndex);
        expect(state1.isAppBarVisible, state2.isAppBarVisible);
      });
    });

    group('Pattern matching integration', () {
      test('should correctly differentiate user and history models', () async {
        final container = ProviderContainer(
          overrides: [homeRepoProvider.overrideWith(TestSuccessHomeRepo.new)],
        );

        final notifier = container.read(homeNotifierProvider.notifier);
        await notifier.getData();

        final state = container.read(homeNotifierProvider);

        // Get users
        final users = (state.userListState as Success<List<UserTileModel>>).data!;

        // Get history
        final history = (state.historyListState as Success<List<HistoryTileModel>>).data!;

        // Verify pattern matching works correctly
        for (final user in users) {
          final result = switch (user as ChatTileModel) {
            UserTileModel u => 'user:${u.isOnline}',
            HistoryTileModel h => 'history:${h.lastMessage}',
          };
          expect(result.startsWith('user:'), true);
        }

        for (final hist in history) {
          final result = switch (hist as ChatTileModel) {
            UserTileModel u => 'user:${u.isOnline}',
            HistoryTileModel h => 'history:${h.lastMessage}',
          };
          expect(result.startsWith('history:'), true);
        }

        container.dispose();
      });
    });
  });
}
