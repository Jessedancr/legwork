import 'package:flutter/material.dart';
import 'package:legwork/core/Constants/helpers.dart';

class LegworkTextButton extends StatelessWidget {
  final Color? foregroundColor;
  final void Function()? onPressed;
  final String buttonText;
  const LegworkTextButton({
    super.key,
    required this.foregroundColor,
    required this.onPressed,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        buttonText,
        style: context.textMd?.copyWith(
          fontWeight: FontWeight.w500,
          color: foregroundColor,
        ),
      ),
    );
  }
}
