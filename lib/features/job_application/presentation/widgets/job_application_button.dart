import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class JobApplicationButton extends StatelessWidget {
  final bool _isLoading;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final void Function()? onPressed;
  final Color backgroundColor;
  final Color buttonTextColor;
  final String buttonText;
  final String? svgIconPath; // Optional SVG icon path
  final IconData? normalIcon; // Optional normal icon
  final Color? iconColor; // Optional icon color
  final Color? svgIconColor;

  const JobApplicationButton({
    super.key,
    required bool isLoading,
    required this.colorScheme,
    required this.textTheme,
    required this.onPressed,
    required this.backgroundColor,
    required this.buttonText,
    required this.buttonTextColor,
    this.svgIconPath, // Optional SVG icon
    this.normalIcon, // Optional normal icon
    this.iconColor,
    this.svgIconColor,
  }) : _isLoading = isLoading;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: _isLoading
          ? null
          : svgIconPath != null
              ? SvgPicture.asset(
                  svgIconPath!,
                  color: svgIconColor,
                )
              : normalIcon != null
                  ? Icon(
                      normalIcon,
                      color: iconColor,
                    )
                  : const SizedBox.shrink(),
      label: _isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
          : Text(
              buttonText,
              style: textTheme.labelLarge?.copyWith(
                color: buttonTextColor,
              ),
            ),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0.5,
        padding: const EdgeInsets.symmetric(vertical: 12),
        backgroundColor: backgroundColor,
      ),
    );
  }
}
