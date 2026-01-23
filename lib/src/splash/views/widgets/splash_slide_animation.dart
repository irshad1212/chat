import 'package:flutter/material.dart';

class SplashSlideAnimation extends StatefulWidget {
  final Widget child;

  const SplashSlideAnimation({super.key, required this.child});

  @override
  State<SplashSlideAnimation> createState() => _SplashSlideAnimationState();
}

class _SplashSlideAnimationState extends State<SplashSlideAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late Animation<double> fadeAnimation;
  late Animation<double> slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: const Duration(milliseconds: 1200), vsync: this);
    fadeAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    slideAnimation = Tween(
      begin: -25.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: slideAnimation,
      child: widget.child,
      builder: (BuildContext context, Widget? child) {
        return Transform.translate(
          offset: Offset(0.0, slideAnimation.value),
          child: FadeTransition(opacity: fadeAnimation, child: child),
        );
      },
    );
  }
}
