import 'dart:io';

import 'package:chat/src/main/views/main_view.dart';
import 'package:chat/src/splash/views/splash_view.dart';
import 'package:chat/utils/helpers/route_config.dart';
import 'package:chat/utils/routes/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

enum RouteTransition { standard, slideUp, fade }

class RouteGenerator {
  static final Map<String, RouteConfig> _routes = {
    AppRoutes.initial: RouteConfig(builder: (_) => const SplashView()),
  };

  static Route generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    final routeName = settings.name ?? AppRoutes.initial;

    final conditionalRoute = _handleConditionalRoutes(routeName, args);
    if (conditionalRoute != null) {
      return conditionalRoute;
    }

    final routeConfig = _routes[routeName];
    if (routeConfig != null) {
      return _buildRouteFromConfig(routeName, routeConfig, args);
    }

    return _buildRoute(AppRoutes.initial, const SplashView());
  }

  /// Handles routes that need conditional logic based on arguments
  static Route? _handleConditionalRoutes(String routeName, dynamic args) {
    switch (routeName) {
      case AppRoutes.routeMain:
        return _materialTransitionRoute(AppRoutes.routeMain, const MainView());

      default:
        return null;
    }
  }

  /// Standard route builder with platform-specific transitions
  static Route _buildRoute(String route, Widget widget, {bool enableFullScreen = false}) {
    return Platform.isIOS
        ? CupertinoPageRoute(
            fullscreenDialog: enableFullScreen,
            settings: RouteSettings(name: route),
            builder: (_) => widget,
          )
        : MaterialPageRoute(
            fullscreenDialog: enableFullScreen,
            settings: RouteSettings(name: route),
            builder: (_) => widget,
          );
  }

  /// Builds route from RouteConfig
  static Route _buildRouteFromConfig(String routeName, RouteConfig config, dynamic args) {
    final widget = config.builder(args);

    switch (config.transition) {
      case RouteTransition.slideUp:
        return _slideUpTransitionRoute(
          routeName,
          widget,
          enableFullScreen: config.fullscreenDialog,
        );
      case RouteTransition.fade:
        return _materialTransitionRoute(routeName, widget);
      case RouteTransition.standard:
        return _buildRoute(routeName, widget, enableFullScreen: config.fullscreenDialog);
    }
  }

  /// Slide up transition route (for modals/bottom sheets)
  static Route _slideUpTransitionRoute(
    String route,
    Widget widget, {
    bool enableFullScreen = false,
  }) {
    return PageRouteBuilder(
      fullscreenDialog: enableFullScreen,
      settings: RouteSettings(name: route),
      opaque: false,
      pageBuilder: (context, animation, secondaryAnimation) => widget,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeOut;

        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 250),
    );
  }

  /// Fade transition route (for splash transitions)
  static Route _materialTransitionRoute(String route, Widget widget) {
    return PageRouteBuilder(
      settings: RouteSettings(name: route),
      pageBuilder: (context, animation, secondaryAnimation) => widget,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 300),
    );
  }
}
