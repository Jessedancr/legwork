import 'package:flutter/material.dart';
//import '../../../../core/Constants/color_schemes.dart';

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
    // Screen size
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // RETURNED WIDGET
    return Material(
      color: Colors.transparent,
      child: Ink(
        height: screenHeight * 0.06,
        width: screenWidth * 0.3,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
            width: 2.0,
          ),
        ),
        child: InkWell(
          onTap: onPressed,
          splashColor: Colors.grey,
          splashFactory: InkSplash.splashFactory,
          borderRadius: BorderRadius.circular(30),
          child: Center(
            child: Text(
              buttonText,
              style: const TextStyle(
                color: Color(0xffFFFFF0),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
