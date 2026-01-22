import 'package:chat/utils/routes/route_generator.dart';
import 'package:flutter/material.dart';

class RouteConfig {
  final Widget Function(dynamic args) builder;
  final RouteTransition transition;
  final bool fullscreenDialog;

  const RouteConfig({
    required this.builder,
    this.transition = RouteTransition.standard,
    this.fullscreenDialog = false,
  });
}
