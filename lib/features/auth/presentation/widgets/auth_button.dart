import 'package:flutter/material.dart';
import 'package:legwork/core/Constants/helpers.dart';

class AuthButton extends StatelessWidget {
  final void Function()? onPressed;
  final String buttonText;
  const AuthButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    // RETURNED WIDGET
    return Ink(
      height: screenHeight(context) * 0.05,
      width: screenWidth(context) * 0.3,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(40),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(40),
        onTap: onPressed,
        splashColor: Theme.of(context).colorScheme.primary,
        splashFactory: InkSplash.splashFactory,
        child: Center(
          child: Text(
            buttonText,
            style: context.textMd?.copyWith(
              color: context.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
