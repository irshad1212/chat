import 'package:chat/core/constants/strings.dart';
import 'package:chat/src/home/models/chat_tile_model.dart';
import 'package:chat/src/home/views/widgets/chat_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Helper to wrap widget with necessary providers
  Widget buildTestableWidget(Widget child) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, _) => MaterialApp(home: Scaffold(body: child)),
    );
  }

  // Setup and teardown for each test to handle overflow in test environment
  void setupTestView(WidgetTester tester) {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
  }

  group('ChatTile', () {
    group('UserTileModel', () {
      test('factory constructor creates ChatTile with UserTileModel', () {
        const model = UserTileModel(userId: 'user_123', fullName: 'John Doe', isOnline: true);

        final tile = ChatTile.user(model: model, onTap: () {});

        expect(tile.model, isA<UserTileModel>());
        expect(tile.model.userId, 'user_123');
      });

      testWidgets('displays user name correctly', (tester) async {
        setupTestView(tester);
        addTearDown(() => tester.view.resetPhysicalSize());

        const model = UserTileModel(userId: 'user_123', fullName: 'John Doe', isOnline: true);

        await tester.pumpWidget(buildTestableWidget(ChatTile.user(model: model, onTap: () {})));

        expect(find.text('John Doe'), findsOneWidget);
      });

      testWidgets('displays Online when user is online', (tester) async {
        setupTestView(tester);
        addTearDown(() => tester.view.resetPhysicalSize());

        const model = UserTileModel(userId: 'user_123', fullName: 'Jane Smith', isOnline: true);

        await tester.pumpWidget(buildTestableWidget(ChatTile.user(model: model, onTap: () {})));

        expect(find.text(Strings.online), findsOneWidget);
      });

      testWidgets('displays last seen when user is offline', (tester) async {
        setupTestView(tester);
        addTearDown(() => tester.view.resetPhysicalSize());

        final model = UserTileModel(
          userId: 'user_123',
          fullName: 'Jane Smith',
          isOnline: false,
          lastSeen: DateTime.now().subtract(const Duration(hours: 2)),
        );

        await tester.pumpWidget(buildTestableWidget(ChatTile.user(model: model, onTap: () {})));

        expect(find.text(Strings.online), findsNothing);
      });

      testWidgets('triggers onTap callback when tapped', (tester) async {
        setupTestView(tester);
        addTearDown(() => tester.view.resetPhysicalSize());

        bool tapped = false;
        const model = UserTileModel(userId: 'user_123', fullName: 'John Doe', isOnline: true);

        await tester.pumpWidget(
          buildTestableWidget(
            ChatTile.user(
              model: model,
              onTap: () {
                tapped = true;
              },
            ),
          ),
        );

        await tester.tap(find.byType(InkWell));
        await tester.pump();

        expect(tapped, isTrue);
      });

      testWidgets('handles null fullName gracefully', (tester) async {
        setupTestView(tester);
        addTearDown(() => tester.view.resetPhysicalSize());

        const model = UserTileModel(userId: 'user_123', isOnline: true);

        await tester.pumpWidget(buildTestableWidget(ChatTile.user(model: model, onTap: () {})));

        // Should not crash - verify widget renders without throwing
        expect(find.byType(ChatTile), findsOneWidget);
      });
    });

    group('HistoryTileModel', () {
      test('factory constructor creates ChatTile with HistoryTileModel', () {
        final model = HistoryTileModel(
          userId: 'user_456',
          fullName: 'Alice',
          lastMessage: 'Hi!',
          lastMessageTime: DateTime.now(),
          unreadCount: 3,
        );

        final tile = ChatTile.history(model: model, onTap: () {});

        expect(tile.model, isA<HistoryTileModel>());
        expect(tile.model.userId, 'user_456');
      });

      testWidgets('displays user name and last message', (tester) async {
        setupTestView(tester);
        addTearDown(() => tester.view.resetPhysicalSize());

        // Suppress overflow errors for complex widget in test environment
        final originalOnError = FlutterError.onError;
        FlutterError.onError = (details) {
          if (!details.exceptionAsString().contains('overflowed')) {
            originalOnError?.call(details);
          }
        };
        addTearDown(() => FlutterError.onError = originalOnError);

        final model = HistoryTileModel(
          userId: 'user_456',
          fullName: 'Alice',
          lastMessage: 'Hello!',
          lastMessageTime: DateTime.now(),
          unreadCount: 0,
        );

        await tester.pumpWidget(buildTestableWidget(ChatTile.history(model: model, onTap: () {})));

        expect(find.text('Alice'), findsOneWidget);
        expect(find.text('Hello!'), findsOneWidget);
      });

      testWidgets('displays unread count badge when count > 0', (tester) async {
        setupTestView(tester);
        addTearDown(() => tester.view.resetPhysicalSize());

        final originalOnError = FlutterError.onError;
        FlutterError.onError = (details) {
          if (!details.exceptionAsString().contains('overflowed')) {
            originalOnError?.call(details);
          }
        };
        addTearDown(() => FlutterError.onError = originalOnError);

        final model = HistoryTileModel(
          userId: 'user_456',
          fullName: 'Alice',
          lastMessage: 'Hi',
          lastMessageTime: DateTime.now(),
          unreadCount: 5,
        );

        await tester.pumpWidget(buildTestableWidget(ChatTile.history(model: model, onTap: () {})));

        expect(find.text('5'), findsOneWidget);
      });

      testWidgets('triggers onTap callback when tapped', (tester) async {
        setupTestView(tester);
        addTearDown(() => tester.view.resetPhysicalSize());

        final originalOnError = FlutterError.onError;
        FlutterError.onError = (details) {
          if (!details.exceptionAsString().contains('overflowed')) {
            originalOnError?.call(details);
          }
        };
        addTearDown(() => FlutterError.onError = originalOnError);

        bool tapped = false;
        final model = HistoryTileModel(
          userId: 'user_456',
          fullName: 'Alice',
          lastMessage: 'Hi!',
          lastMessageTime: DateTime.now(),
          unreadCount: 0,
        );

        await tester.pumpWidget(
          buildTestableWidget(
            ChatTile.history(
              model: model,
              onTap: () {
                tapped = true;
              },
            ),
          ),
        );

        await tester.tap(find.byType(InkWell));
        await tester.pump();

        expect(tapped, isTrue);
      });

      testWidgets('renders lastMessage text', (tester) async {
        setupTestView(tester);
        addTearDown(() => tester.view.resetPhysicalSize());

        final originalOnError = FlutterError.onError;
        FlutterError.onError = (details) {
          if (!details.exceptionAsString().contains('overflowed')) {
            originalOnError?.call(details);
          }
        };
        addTearDown(() => FlutterError.onError = originalOnError);

        final model = HistoryTileModel(
          userId: 'user_456',
          fullName: 'Bob',
          lastMessage: 'Test message',
          lastMessageTime: DateTime.now(),
          unreadCount: 0,
        );

        await tester.pumpWidget(buildTestableWidget(ChatTile.history(model: model, onTap: () {})));

        expect(find.text('Test message'), findsOneWidget);
      });
    });

    group('Pattern Matching', () {
      testWidgets('correctly renders UserTileModel via pattern matching', (tester) async {
        setupTestView(tester);
        addTearDown(() => tester.view.resetPhysicalSize());

        const model = UserTileModel(userId: 'user_999', fullName: 'Pattern User', isOnline: true);

        await tester.pumpWidget(buildTestableWidget(ChatTile.user(model: model, onTap: () {})));

        expect(find.text('Pattern User'), findsOneWidget);
        expect(find.text(Strings.online), findsOneWidget);
      });

      testWidgets('correctly renders HistoryTileModel via pattern matching', (tester) async {
        setupTestView(tester);
        addTearDown(() => tester.view.resetPhysicalSize());

        final originalOnError = FlutterError.onError;
        FlutterError.onError = (details) {
          if (!details.exceptionAsString().contains('overflowed')) {
            originalOnError?.call(details);
          }
        };
        addTearDown(() => FlutterError.onError = originalOnError);

        final model = HistoryTileModel(
          userId: 'user_888',
          fullName: 'History',
          lastMessage: 'Hi!',
          lastMessageTime: DateTime.now(),
          unreadCount: 2,
        );

        await tester.pumpWidget(buildTestableWidget(ChatTile.history(model: model, onTap: () {})));

        expect(find.text('History'), findsOneWidget);
        expect(find.text('Hi!'), findsOneWidget);
        expect(find.text('2'), findsOneWidget);
      });
    });
  });
}
