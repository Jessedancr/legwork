import 'package:flutter/material.dart';

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
    //SCREEN SIZE
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // RETURNED WIDGET
    return Ink(
      height: screenHeight * 0.05,
      width: screenWidth * 0.3,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(40),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(40),
        onTap: onPressed,
        splashColor: Theme.of(context).colorScheme.onPrimary,
        splashFactory: InkSplash.splashFactory,
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
