import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chat/core/constants/strings.dart';
import 'package:chat/core/theme/colors.dart';
import 'package:chat/core/theme/text_styles.dart';

class CustomTabBar extends StatefulWidget {
  const CustomTabBar({super.key, required this.controller});

  final TabController controller;

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  static const _tabs = [Strings.users, Strings.chatHistory];
  final List<GlobalKey> _tabKeys = List.generate(2, (_) => GlobalKey());
  List<double> _tabWidths = [];
  List<double> _tabOffsets = [];

  @override
  void initState() {
    super.initState();
    widget.controller.animation!.addListener(_handleTabAnimation);
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureTabs());
  }

  @override
  void dispose() {
    widget.controller.animation!.removeListener(_handleTabAnimation);
    super.dispose();
  }

  void _handleTabAnimation() {
    setState(() {});
  }

  void _measureTabs() {
    final widths = <double>[];
    final offsets = <double>[];
    double currentOffset = 0;

    for (final key in _tabKeys) {
      final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        widths.add(renderBox.size.width);
        offsets.add(currentOffset);
        currentOffset += renderBox.size.width;
      }
    }

    if (widths.length == _tabs.length) {
      setState(() {
        _tabWidths = widths;
        _tabOffsets = offsets;
      });
    }
  }

  void _onTabTap(int index) {
    widget.controller.animateTo(index);
  }

  double _getIndicatorLeft(double animationValue) {
    if (_tabOffsets.isEmpty) return 0;

    final fromIndex = animationValue.floor().clamp(0, _tabs.length - 1);
    final toIndex = animationValue.ceil().clamp(0, _tabs.length - 1);
    final progress = animationValue - fromIndex;

    final fromOffset = _tabOffsets[fromIndex];
    final toOffset = _tabOffsets[toIndex];

    return fromOffset + (toOffset - fromOffset) * progress;
  }

  double _getIndicatorWidth(double animationValue) {
    if (_tabWidths.isEmpty) return 0;

    final fromIndex = animationValue.floor().clamp(0, _tabs.length - 1);
    final toIndex = animationValue.ceil().clamp(0, _tabs.length - 1);
    final progress = animationValue - fromIndex;

    final fromWidth = _tabWidths[fromIndex];
    final toWidth = _tabWidths[toIndex];

    return fromWidth + (toWidth - fromWidth) * progress;
  }

  @override
  Widget build(BuildContext context) {
    final animationValue = widget.controller.animation!.value;
    final selectedIndex = widget.controller.index;

    final indicatorLeft = _getIndicatorLeft(animationValue);
    final indicatorWidth = _getIndicatorWidth(animationValue);

    return Container(
      height: 46.h,
      decoration: BoxDecoration(color: AppColors.chatBubbleOther, borderRadius: .circular(40.r)),
      child: Stack(
        children: [
          if (_tabWidths.isNotEmpty)
            Positioned(
              left: indicatorLeft,
              top: 0,
              bottom: 0,
              width: indicatorWidth,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: .circular(40.r),
                  border: .all(color: AppColors.borderGrey),
                ),
              ),
            ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(_tabs.length, (index) {
              final isSelected = selectedIndex == index;
              return GestureDetector(
                key: _tabKeys[index],
                onTap: () => _onTabTap(index),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: .symmetric(horizontal: 26.w),
                  child: SizedBox(
                    height: 40.h,
                    child: Center(
                      child: Text(
                        _tabs[index],
                        style: TextStyles.inter.bold.copyWith(
                          color: isSelected ? AppColors.textColor : AppColors.textColorSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
