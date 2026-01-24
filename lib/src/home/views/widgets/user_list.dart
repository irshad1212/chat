import 'package:flutter/material.dart';

import 'package:chat/src/home/models/chat_tile_model.dart';
import 'package:chat/src/home/views/widgets/chat_tile.dart';
import 'package:chat/src/shared/widgets/slide_fade_transition.dart';
import 'package:chat/utils/routes/app_routes.dart';

class UserList extends StatelessWidget {
  const UserList({super.key, required this.scrollController, required this.list});

  final ScrollController scrollController;
  final List<UserTileModel> list;

  @override
  Widget build(BuildContext context) {
    return SlideFadeTransition(
      slideOffset: 4,
      slideDuration: const Duration(milliseconds: 250),
      child: ListView.builder(
        controller: scrollController,
        key: const PageStorageKey<String>('user_list'),
        itemCount: list.length,
        itemBuilder: (ctx, index) {
          return ChatTile.user(
            model: list[index],
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.routeChat,
                arguments: {
                  'userId': list[index].userId,
                  'userName': list[index].fullName ?? 'User',
                },
              );
            },
          );
        },
      ),
    );
  }
}
