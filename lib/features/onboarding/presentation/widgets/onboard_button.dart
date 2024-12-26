import 'package:flutter/material.dart';

class OnboardButton extends StatelessWidget {
  final String buttonText;
  final void Function()? onPressed;
  const OnboardButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        buttonText,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
