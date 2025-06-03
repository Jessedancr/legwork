import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:legwork/core/Constants/helpers.dart';

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
            width: screenWidth,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: contentColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(40),
              ),
            ),
            child: Row(
              children: [
                SizedBox(width: screenWidth * 0.15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title text
                    Text(
                      title,
                      style: context.text2Xl?.copyWith(
                        color: context.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // Subtitle text
                    Text(
                      subTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.textXl?.copyWith(
                        color: context.colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Bubble
        Positioned(
          top: screenHeight * 0.02,
          left: screenWidth * 0.03,
          child: Image.asset(
            'images/icons/bubble.png',
            height: screenHeight * 0.05,
            width: screenWidth * 0.08,
            color: imageColor,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}
