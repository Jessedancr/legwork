import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LegWorkSnackBarContent extends StatelessWidget {
  final BuildContext context;
  final double screenHeight;
  final double screenWidth;
  final String title;
  final String subTitle;
  final Color contentColor;
  final Color imageColor;
  const LegWorkSnackBarContent({
    super.key,
    required this.screenHeight,
    required this.context,
    required this.screenWidth,
    required this.title,
    required this.subTitle,
    required this.contentColor,
    required this.imageColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IntrinsicHeight(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: contentColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(40),
              ),
            ),
            child: Row(
              children: [
                SizedBox(width: screenWidth * 0.13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title text
                      Text(
                        title,
                        style: GoogleFonts.robotoSlab(
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Subtitle text
                      Text(
                        subTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.robotoCondensed(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Bubble
        Positioned(
          bottom: screenHeight * 0.02,
          left: screenWidth * 0.02,
          child: Image.asset(
            'images/icons/bubble.png',
            height: screenHeight * 0.06,
            width: screenWidth * 0.09,
            color: imageColor,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}
