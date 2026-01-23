import 'package:flutter/material.dart';

import 'package:chat/src/home/models/chat_tile_args.dart';
import 'package:chat/src/home/views/widgets/chat_tile.dart';
import 'package:chat/src/shared/widgets/slide_fade_transition.dart';

class HistoryList extends StatelessWidget {
  const HistoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return SlideFadeTransition(
      slideOffset: 4,
      slideDuration: const Duration(milliseconds: 250),
      child: ListView.builder(
        key: const PageStorageKey<String>('history_list'),
        itemCount: 100,
        itemBuilder: (ctx, index) {
          return ChatTile.history(
            args: ChatTileArgs(
              type: .history,
              userId: '$index',
              fullName: 'Chat $index',
              lastMessage: 'Last message from chat $index',
              lastMessageTime: DateTime.now().subtract(Duration(hours: index)),
              unreadCount: index % 5,
            ),
            onTap: () {},
          );
        },
      ),
    );
  }
}
