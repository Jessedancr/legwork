import 'package:flutter/material.dart';
import 'package:legwork/core/Constants/helpers.dart';

class OnboardBottomGradient extends StatelessWidget {
  final Widget child;
  const OnboardBottomGradient({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: SizedBox(
        height: screenHeight(context) * 0.4,
        width: screenWidth(context),
        child: Stack(
          children: [
            // Gradient effect
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                    Colors.black.withOpacity(0.9),
                    Colors.black
                  ],
                ),
              ),
            ),

            // child
            child
          ],
        ),
      ),
    );
  }
}
