import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LegworkElevatedButton extends StatelessWidget {
  final void Function()? onPressed;
  final String buttonText;
  final PageController pageController = PageController();
  final Widget? icon;
  final WidgetStateProperty<Size?>? maximumSize;
  final WidgetStateProperty<Size?>? minimumSize;
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
      style: ButtonStyle(
        maximumSize: maximumSize,
        minimumSize: minimumSize,
        backgroundColor: WidgetStatePropertyAll(
          Theme.of(context).colorScheme.primary,
        ),
        elevation: const WidgetStatePropertyAll(0.0),
        
        splashFactory: InkSplash.splashFactory,
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Button Icon
          icon ?? const SizedBox(width: 0),

          // Button text
          Text(
            buttonText,
            style: GoogleFonts.robotoSlab(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
