import 'package:flutter/material.dart';

import 'package:chat/utils/packages/figma_squircle/src/smooth_border_radius.dart';
import 'package:chat/utils/packages/figma_squircle/src/smooth_rectangle_border.dart';

class SmoothMaterial extends StatelessWidget {
  const SmoothMaterial({super.key, this.child, this.clip, this.color, this.radiusAll});

  final Color? color;

  final Clip? clip;

  final double? radiusAll;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: clip ?? Clip.hardEdge,
      color: color,
      shape: SmoothRectangleBorder(
        borderRadius: SmoothBorderRadius(cornerRadius: radiusAll ?? 0, cornerSmoothing: 1),
      ),
      child: child,
    );
  }
}
