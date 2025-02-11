import 'dart:ui';

import 'package:flutter/material.dart';

class BlurEffect extends StatelessWidget {
  final height;
  final Widget child;
  final double width;
  final Color? firstGradientColor;
  final Color? secondGradientColor;
  final double? sigmaX;
  final double? sigmaY;
  final Alignment? begin;
  final Alignment? end;

  const BlurEffect({
    super.key,
    required this.child,
    required this.height,
    required this.width,
    this.sigmaX,
    this.sigmaY,
    this.firstGradientColor,
    this.secondGradientColor,
    this.begin,
    this.end
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: SizedBox(
        height: height,
        width: width,
        child: Stack(
          children: [
            // Blur effect
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: sigmaX ?? 3,
                sigmaY: sigmaY ?? 3,
              ),
              child: Container(),
            ),

            // gradient efect
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    firstGradientColor ??
                        Theme.of(context).colorScheme.primary.withOpacity(0.8),
                    secondGradientColor ?? Colors.black.withOpacity(0.5),
                  ],
                  begin: begin ?? Alignment.topLeft,
                  end: end ?? Alignment.bottomRight,
                ),
              ),
            ),

            // child
            child,
          ],
        ),
      ),
    );
  }
}
