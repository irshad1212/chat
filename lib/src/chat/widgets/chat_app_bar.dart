import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chat/core/theme/colors.dart';
import 'package:chat/core/constants/strings.dart';
import 'package:chat/core/theme/text_styles.dart';
import 'package:chat/src/home/models/chat_tile_model.dart';
import 'package:chat/src/home/views/widgets/avatar.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userId;
  final String userName;

  const ChatAppBar({super.key, required this.userId, required this.userName});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: AppColors.chatBubbleOther)),
        ),
        height: kToolbarHeight + 12.h,
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back, size: 24.r, color: AppColors.black),
            ),
            8.horizontalSpace,
            Avatar(
              model: UserTileModel(userId: userId, fullName: userName, isOnline: false),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                mainAxisAlignment: .center,
                children: [
                  Text(userName, style: TextStyles.inter.chatAppBarTitle),
                  Text(
                    Strings.online,
                    style: TextStyles.inter.chatAppBarSubtitle.copyWith(
                      color: AppColors.textColorTertiary,
                      fontWeight: .w600,
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

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 12.h);
}
