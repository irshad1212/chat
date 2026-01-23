import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chat/core/constants/strings.dart';
import 'package:chat/core/enums/chat_tile_type.dart';
import 'package:chat/core/theme/colors.dart';
import 'package:chat/core/theme/text_styles.dart';
import 'package:chat/src/home/models/chat_tile_args.dart';
import 'package:chat/src/home/views/widgets/avatar.dart';
import 'package:chat/src/home/views/widgets/count_badge.dart';
import 'package:chat/src/shared/widgets/smooth_material.dart';
import 'package:chat/utils/helpers/extensions.dart';
import 'package:chat/utils/helpers/functions.dart';

class ChatTile extends StatelessWidget {
  const ChatTile._({super.key, required this.args, required this.onTap});

  const ChatTile.user({Key? key, required ChatTileArgs args, required Function onTap})
    : this._(key: key, args: args, onTap: onTap);

  const ChatTile.history({Key? key, required ChatTileArgs args, required Function onTap})
    : this._(key: key, args: args, onTap: onTap);

  final ChatTileArgs args;

  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return switch (args.type) {
      ChatTileType.user => _buildUserTile(context, args: args),
      ChatTileType.history => _buildHistoryTile(context),
    };
  }

  Widget _buildUserTile(BuildContext context, {required ChatTileArgs args}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: SmoothMaterial(
        color: Colors.transparent,
        clip: Clip.hardEdge,
        radiusAll: 12.r,
        child: InkWell(
          onTap: () => onTap(),
          splashColor: AppColors.splashColor,
          highlightColor: AppColors.highlightColor,
          child: Container(
            width: context.sw(),
            height: 78.h,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r)),
            padding: EdgeInsets.all(15.r),
            child: Row(
              children: [
                Avatar(args: args),
                15.horizontalSpace,
                Column(
                  crossAxisAlignment: .start,
                  mainAxisAlignment: .center,
                  children: [
                    Text(args.fullName ?? '', style: TextStyles.inter.chatTileTitle),
                    Text(
                      args.isOnline ?? false ? Strings.online : formatTimeAgo(args.lastSeen),
                      style: TextStyles.inter.chatTileSubtitle,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryTile(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: SmoothMaterial(
        color: Colors.transparent,
        clip: .hardEdge,
        radiusAll: 12.r,
        child: InkWell(
          onTap: () => onTap(),
          splashColor: AppColors.splashColor,
          highlightColor: AppColors.highlightColor,
          child: Container(
            width: context.sw(),
            height: 78.h,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r)),
            padding: EdgeInsets.all(15.r),
            child: Row(
              children: [
                Avatar(args: args),
                15.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    mainAxisAlignment: .center,
                    children: [
                      Text(args.fullName ?? '', style: TextStyles.inter.chatTileTitle),
                      Text(args.lastMessage ?? '', style: TextStyles.inter.chatTileSubtitle),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: .end,
                  mainAxisAlignment: .center,
                  children: [
                    Text(
                      formatTimeAgo(args.lastMessageTime, history: true),
                      style: TextStyles.inter.chatTileSubtitle,
                    ),
                    4.verticalSpace,
                    CountBadge(count: args.unreadCount ?? 0),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
