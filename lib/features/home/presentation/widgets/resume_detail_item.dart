import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ResumeDetailItem extends StatelessWidget {
  final String label;
  final String value;
  final String svgIconPath;

  const ResumeDetailItem({
    super.key,
    required this.label,
    required this.value,
    required this.svgIconPath,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          svgIconPath,
          color: colorScheme.secondary,
          fit: BoxFit.scaleDown,
          height: 15,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: '$label: ',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
              children: [
                TextSpan(
                  text: value,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
