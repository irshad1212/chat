import 'package:flutter/material.dart';

import 'package:chat/src/home/models/chat_tile_args.dart';
import 'package:chat/src/home/views/widgets/chat_tile.dart';
import 'package:chat/src/shared/widgets/slide_fade_transition.dart';

class HistoryList extends StatelessWidget {
  const HistoryList({super.key, required this.list});

  final List<ChatTileArgs> list;

  @override
  Widget build(BuildContext context) {
    return SlideFadeTransition(
      slideOffset: 4,
      slideDuration: const Duration(milliseconds: 250),
      child: ListView.builder(
        key: const PageStorageKey<String>('history_list'),
        itemCount: list.length,
        itemBuilder: (ctx, index) {
          return ChatTile.history(args: list[index], onTap: () {});
        },
      ),
    );
  }
}
