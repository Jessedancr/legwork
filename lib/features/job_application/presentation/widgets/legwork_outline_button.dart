import 'package:flutter/material.dart';

class LegworkOutlineButton extends StatelessWidget {
  final void Function()? onPressed;
  final bool isLoading;
  final Widget? icon;
  final String buttonText;
  const LegworkOutlineButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.isLoading = false,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: colorScheme.primary,
                strokeWidth: 2.0,
              ),
            )
          : Text(
              buttonText,
              style: textTheme.labelLarge?.copyWith(
                color: colorScheme.primary,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: BorderSide(
          color: colorScheme.primary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}
