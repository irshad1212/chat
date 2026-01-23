import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chat/core/constants/strings.dart';
import 'package:chat/core/theme/colors.dart';
import 'package:chat/core/theme/text_styles.dart';
import 'package:chat/utils/helpers/extensions.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key, required this.animationController, required this.tabController});

  final AnimationController animationController;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: animationController,
      axisAlignment: 1.0,
      child: Container(
        width: context.sw(),
        height: 78.h,
        decoration: const BoxDecoration(
          color: AppColors.white,
          border: Border(bottom: BorderSide(color: AppColors.borderLight)),
        ),
        child: Row(
          mainAxisAlignment: .center,
          children: [
            Container(
              height: 46.h,
              padding: EdgeInsets.all(3.r),
              decoration: BoxDecoration(
                color: AppColors.chatBubbleOther,
                borderRadius: BorderRadius.circular(40.r),
              ),
              child: TabBar(
                controller: tabController,
                isScrollable: true,
                tabAlignment: .center,
                dividerColor: Colors.transparent,
                splashFactory: NoSplash.splashFactory,
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                labelPadding: EdgeInsets.symmetric(horizontal: 26.w),
                labelColor: AppColors.textColor,
                unselectedLabelColor: AppColors.textColorSecondary,
                labelStyle: TextStyles.inter.bold,
                unselectedLabelStyle: TextStyles.inter.bold,
                indicator: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(40.r),
                  border: Border.all(color: AppColors.borderGrey),
                ),
                indicatorSize: .tab,
                tabs: const [
                  Tab(text: Strings.users),
                  Tab(text: Strings.chatHistory),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
