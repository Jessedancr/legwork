import 'package:flutter/material.dart';
import 'package:legwork/core/Constants/helpers.dart';
import 'package:lottie/lottie.dart';

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
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: isLoading
          ? SizedBox(
              height: 30,
              width: 30,
              child: Lottie.asset(
                'assets/lottie/loading.json',
              ),
            )
          : Text(
              buttonText,
              style: context.textLg?.copyWith(
                color: context.colorScheme.primary,
                fontWeight: FontWeight.w400,
              ),
            ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10),
        side: BorderSide(
          color: context.colorScheme.primary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}
