import 'package:flutter/material.dart';
import 'package:legwork/core/Constants/helpers.dart';

class OnboardButton extends StatelessWidget {
  final String buttonText;
  final void Function()? onPressed;
  final Color? buttonColor;
  final Color? borderColor;
  const OnboardButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.buttonColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    // RETURNED WIDGET
    return Material(
      color: Colors.transparent,
      child: Ink(
        height: screenHeight(context) * 0.06,
        width: screenWidth(context) * 0.3,
        decoration: BoxDecoration(
          color: buttonColor ?? Colors.black,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: borderColor ?? context.colorScheme.primary,
            width: 2.0,
          ),
        ),
        child: InkWell(
          onTap: onPressed,
          splashColor: context.colorScheme.primary,
          splashFactory: InkSplash.splashFactory,
          borderRadius: BorderRadius.circular(30),
          child: Center(
            child: Text(
              buttonText,
              style: context.textXs?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
