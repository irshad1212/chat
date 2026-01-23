import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chat/core/constants/strings.dart';
import 'package:chat/core/theme/colors.dart';
import 'package:chat/core/theme/text_styles.dart';
import 'package:chat/src/home/models/chat_tile_model.dart';
import 'package:chat/src/home/views/widgets/avatar.dart';
import 'package:chat/src/home/views/widgets/count_badge.dart';
import 'package:chat/src/shared/widgets/smooth_material.dart';
import 'package:chat/utils/helpers/extensions.dart';
import 'package:chat/utils/helpers/functions.dart';

/// Chat tile widget that uses pattern matching on sealed ChatTileModel.
class ChatTile extends StatelessWidget {
  const ChatTile._({super.key, required this.model, required this.onTap});

  /// Factory constructor for user tiles.
  factory ChatTile.user({Key? key, required UserTileModel model, required VoidCallback onTap}) {
    return ChatTile._(key: key, model: model, onTap: onTap);
  }

  /// Factory constructor for history tiles.
  factory ChatTile.history({
    Key? key,
    required HistoryTileModel model,
    required VoidCallback onTap,
  }) {
    return ChatTile._(key: key, model: model, onTap: onTap);
  }

  final ChatTileModel model;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Exhaustive pattern matching on sealed class
    return switch (model) {
      UserTileModel user => _buildUserTile(context, user: user),
      HistoryTileModel history => _buildHistoryTile(context, history: history),
    };
  }

  Widget _buildUserTile(BuildContext context, {required UserTileModel user}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: SmoothMaterial(
        color: Colors.transparent,
        clip: Clip.hardEdge,
        radiusAll: 12.r,
        child: InkWell(
          onTap: onTap,
          splashColor: AppColors.splashColor,
          highlightColor: AppColors.highlightColor,
          child: Container(
            width: context.sw(),
            height: 78.h,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r)),
            padding: EdgeInsets.all(15.r),
            child: Row(
              children: [
                Avatar(model: user),
                15.horizontalSpace,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(user.fullName ?? '', style: TextStyles.inter.chatTileTitle),
                    Text(
                      user.isOnline ? Strings.online : formatTimeAgo(user.lastSeen),
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

  Widget _buildHistoryTile(BuildContext context, {required HistoryTileModel history}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: SmoothMaterial(
        color: Colors.transparent,
        clip: Clip.hardEdge,
        radiusAll: 12.r,
        child: InkWell(
          onTap: onTap,
          splashColor: AppColors.splashColor,
          highlightColor: AppColors.highlightColor,
          child: Container(
            width: context.sw(),
            height: 78.h,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r)),
            padding: EdgeInsets.all(15.r),
            child: Row(
              children: [
                Avatar(model: history),
                15.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(history.fullName ?? '', style: TextStyles.inter.chatTileTitle),
                      Text(
                        history.lastMessage,
                        style: TextStyles.inter.chatTileSubtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      formatTimeAgo(history.lastMessageTime, history: true),
                      style: TextStyles.inter.chatTileSubtitle,
                    ),
                    4.verticalSpace,
                    CountBadge(count: history.unreadCount),
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
