import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

import 'package:chat/core/constants/strings.dart';
import 'package:chat/core/theme/colors.dart';
import 'package:chat/core/theme/text_styles.dart';
import 'package:chat/generated/assets.dart';
import 'package:chat/src/home/views/home_view.dart';
import 'package:chat/src/main/views/widgets/placeholder_view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  late final PageController pageController;
  late final ValueNotifier<int> selectedIndex;

  final List<String> navIconsActive = [
    Assets.bottomNavHomeActive,
    Assets.bottomNavOfferActive,
    Assets.bottomNavSettingsActive,
  ];

  final List<String> navIconsInactive = [
    Assets.bottomNavHomeSubtle,
    Assets.bottomNavOfferSubtle,
    Assets.bottomNavSettingsSubtle,
  ];

  final List<String> navTexts = [Strings.home, Strings.offer, Strings.settings];

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    pageController.dispose();
    selectedIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {}
      },
      child: Scaffold(
        body: PageView(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            HomeView(),
            PlaceholderView(title: Strings.offer),
            PlaceholderView(title: Strings.settings),
          ],
        ),
        bottomNavigationBar: Theme(
          data: ThemeData(splashColor: Colors.transparent, highlightColor: Colors.transparent),
          child: DecoratedBox(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(width: 1, color: Color(0xffE6E7EB))),
            ),
            child: ValueListenableBuilder(
              valueListenable: selectedIndex,
              builder: (_, value, __) => BottomNavigationBar(
                currentIndex: value,
                showSelectedLabels: true,
                backgroundColor: AppColors.white,
                type: .fixed,
                showUnselectedLabels: true,
                onTap: (val) => updateSelectedIndex(val),
                selectedLabelStyle: TextStyles.inter.bottomNavSelected,
                unselectedLabelStyle: TextStyles.inter.bottomNavUnselected,
                selectedItemColor: AppColors.black,
                unselectedItemColor: AppColors.textColorSecondary,
                items: List.generate(
                  navTexts.length,
                  (index) => BottomNavigationBarItem(
                    icon: Padding(
                      padding: const .only(bottom: 6, top: 8),
                      child: Container(
                        height: 24,
                        alignment: Alignment.center,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder: (Widget child, Animation<double> animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: ScaleTransition(
                                scale: animation.drive(Tween<double>(begin: 0.90, end: 1.0)),
                                child: child,
                              ),
                            );
                          },
                          child: SvgPicture.asset(
                            selectedIndex.value == index
                                ? navIconsActive[index]
                                : navIconsInactive[index],
                            key: ValueKey<bool>(selectedIndex.value == index),
                            height: selectedIndex.value == index ? 24 : 22,
                          ),
                        ),
                      ),
                    ),
                    label: navTexts[index],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _init() {
    pageController = PageController(initialPage: 0, keepPage: true);
    selectedIndex = ValueNotifier(0);
  }

  void updateSelectedIndex(int index) {
    selectedIndex.value = index;
    pageController.jumpToPage(index);
  }
}
