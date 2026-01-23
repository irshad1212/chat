import 'package:flutter/material.dart';

import 'package:chat/src/home/models/chat_tile_args.dart';
import 'package:chat/src/home/views/widgets/chat_tile.dart';
import 'package:chat/src/shared/widgets/slide_fade_transition.dart';

class UserList extends StatelessWidget {
  const UserList({super.key, required this.scrollController});

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return SlideFadeTransition(
      slideOffset: 4,
      slideDuration: const Duration(milliseconds: 250),
      child: ListView.builder(
        controller: scrollController,
        key: const PageStorageKey<String>('user_list'),
        itemCount: 100,
        itemBuilder: (ctx, index) {
          return ChatTile.user(
            args: ChatTileArgs(
              type: .user,
              userId: '$index',
              fullName: 'User $index',
              isOnline: true,
            ),
            onTap: () {},
          );
        },
      ),
    );
  }
}
