import 'package:flutter/material.dart';
import 'package:legwork/core/Constants/helpers.dart';

class LegworkScreenBubble extends StatelessWidget {
  final double? right;
  final double? left;
  final double? top;
  final double? bottom;
  final double? xAlignValue;
  final double? yAlignValue;
  final double outerCircularAvatarRadius;
  final double innerCircularAvatarRadius;
  const LegworkScreenBubble({
    super.key,
    required this.outerCircularAvatarRadius,
    required this.innerCircularAvatarRadius,
    this.bottom,
    this.left,
    this.right,
    this.top,
    this.xAlignValue,
    this.yAlignValue,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: CircleAvatar(
        backgroundColor: context.colorScheme.primaryContainer,
        radius: outerCircularAvatarRadius,
        child: Align(
          alignment: Alignment(xAlignValue!, yAlignValue!),
          child: CircleAvatar(
            radius: innerCircularAvatarRadius,
            backgroundColor: context.colorScheme.primary.withOpacity(0.8),
          ),
        ),
      ),
    );
  }
}
