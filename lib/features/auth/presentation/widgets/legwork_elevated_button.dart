import 'package:flutter/material.dart';

// TODO: PROPERLY STYLE THIS BUTTON

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
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
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
            style: textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
