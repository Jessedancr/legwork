import 'package:flutter/material.dart';

class GlassBox extends StatelessWidget {
  final Widget child;
  const GlassBox({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Screen size
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return ClipRRect(
      child: SizedBox(
        height: screenHeight * 0.4,
        width: screenWidth,
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
                    Colors.black,
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
