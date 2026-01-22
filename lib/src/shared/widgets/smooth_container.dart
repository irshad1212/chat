import 'package:flutter/material.dart';

import 'package:chat/utils/packages/figma_squircle/src/smooth_border_radius.dart';
import 'package:chat/utils/packages/figma_squircle/src/smooth_rectangle_border.dart';

class SmoothContainer extends StatelessWidget {
  final Widget? child;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Decoration? decoration;
  final Decoration? foregroundDecoration;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? margin;
  final Matrix4? transform;
  final AlignmentGeometry? transformAlignment;
  final Clip clipBehavior;
  final bool animated;

  const SmoothContainer({
    super.key,
    this.child,
    this.alignment,
    this.padding,
    this.color,
    this.decoration,
    this.foregroundDecoration,
    this.width,
    this.height,
    this.constraints,
    this.margin,
    this.transform,
    this.transformAlignment,
    this.clipBehavior = Clip.none,
    this.animated = false,
  });

  @override
  Widget build(BuildContext context) {
    final finalDecoration = _getOptimizedDecoration();
    return animated
        ? AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.decelerate,
            alignment: alignment,
            padding: padding,
            color: color,
            decoration: finalDecoration,
            foregroundDecoration: foregroundDecoration,
            width: width,
            height: height,
            constraints: constraints,
            margin: margin,
            transform: transform,
            transformAlignment: transformAlignment,
            clipBehavior: clipBehavior,
            child: child,
          )
        : Container(
            alignment: alignment,
            padding: padding,
            color: color,
            decoration: finalDecoration,
            foregroundDecoration: foregroundDecoration,
            width: width,
            height: height,
            constraints: constraints,
            margin: margin,
            transform: transform,
            transformAlignment: transformAlignment,
            clipBehavior: clipBehavior,
            child: child,
          );
  }

  Decoration? _getOptimizedDecoration() {
    // Early return if not a BoxDecoration
    final boxDecoration = decoration;
    if (boxDecoration is! BoxDecoration) return decoration;

    // Early return if no border radius to optimize
    final borderRadius = boxDecoration.borderRadius;
    if (borderRadius == null) return decoration;

    // Extract radius - handle both BorderRadius and BorderRadiusDirectional
    final double radius;
    if (borderRadius is BorderRadius) {
      radius = borderRadius.topLeft.x;
    } else if (borderRadius is BorderRadiusDirectional) {
      radius = borderRadius.topStart.x;
    } else {
      return decoration;
    }

    // Extract border side more efficiently
    final border = boxDecoration.border;
    final BorderSide borderSide;
    if (border is Border) {
      borderSide = border.top;
    } else if (border is BorderDirectional) {
      borderSide = border.start;
    } else {
      borderSide = BorderSide.none;
    }

    return ShapeDecoration(
      color: boxDecoration.color,
      shadows: boxDecoration.boxShadow,
      gradient: boxDecoration.gradient,
      image: boxDecoration.image,
      shape: SmoothRectangleBorder(
        side: borderSide,
        borderRadius: SmoothBorderRadius(cornerRadius: radius, cornerSmoothing: 1),
      ),
    );
  }
}
