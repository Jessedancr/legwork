import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LegworkElevatedButton extends StatelessWidget {
  final void Function()? onPressed;
  final String buttonText;
  final PageController pageController = PageController();
  LegworkElevatedButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(
          Theme.of(context).colorScheme.primary,
        ),
        elevation: const WidgetStatePropertyAll(0.0),
        splashFactory: InkSplash.splashFactory,
      ),
      onPressed: onPressed,
      child: Text(
        buttonText,
        style: GoogleFonts.robotoSlab(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}
