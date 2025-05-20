import 'package:flutter/material.dart';
import 'package:legwork/core/Constants/helpers.dart';

// TODO: PROPERLY STYLE THIS BUTTON

class LegworkElevatedButton extends StatelessWidget {
  final void Function()? onPressed;
  final String buttonText;
  final PageController pageController = PageController();
  final dynamic icon;
  final Size? maximumSize;
  final Size? minimumSize;
  LegworkElevatedButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
    this.icon,
    this.maximumSize,
    this.minimumSize,
  });

  @override
  Widget build(BuildContext context) {
    // RETURNED WIDGET
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        maximumSize: maximumSize,
        minimumSize: minimumSize,
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 2.0,
        splashFactory: InkSplash.splashFactory,
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: icon == null
            ? MainAxisAlignment.center
            : MainAxisAlignment.spaceEvenly,
        children: [
          // Button Icon
          if (icon != null) icon,

          // Button text
          Text(
            buttonText,
            style: context.textXs?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
