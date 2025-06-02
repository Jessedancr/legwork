import 'package:flutter/material.dart';
import 'package:legwork/core/Constants/helpers.dart';

class LegworkElevatedButton extends StatelessWidget {
  final void Function()? onPressed;
  final String buttonText;
  final PageController pageController = PageController();
  final dynamic icon;
  final Size? maximumSize;
  final Size? minimumSize;
  final Color? backgroundColor;
  LegworkElevatedButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
    this.icon,
    this.maximumSize,
    this.minimumSize,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    // RETURNED WIDGET
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        maximumSize: maximumSize,
        minimumSize: minimumSize,
        backgroundColor: backgroundColor ?? context.colorScheme.primary,
        elevation: 2.0,
        splashFactory: InkSplash.splashFactory,
        enableFeedback: true,
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: icon == null
            ? MainAxisAlignment.center
            : MainAxisAlignment.spaceAround,
        children: [
          // Button text
          Text(
            buttonText,
            style: context.textXs?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colorScheme.onPrimary,
            ),
          ),

          // Button Icon
          if (icon != null) icon,
        ],
      ),
    );
  }
}
