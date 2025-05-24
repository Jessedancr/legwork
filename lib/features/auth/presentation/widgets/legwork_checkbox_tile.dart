import 'package:flutter/material.dart';
import 'package:legwork/core/Constants/helpers.dart';

class LegworkCheckboxTile extends StatelessWidget {
  final String title;
  final bool checkedValue;
  final void Function(bool?)? onChanged;
  const LegworkCheckboxTile({
    super.key,
    required this.title,
    required this.checkedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // RETURNED WIDGET
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: context.colorScheme.scrim,
          borderRadius: BorderRadius.circular(30),
        ),
        width: double.infinity,
        height: screenHeight(context) * 0.07,
        child: Row(
          children: [
            Checkbox(
              value: checkedValue,
              onChanged: onChanged,
              fillColor: WidgetStatePropertyAll(context.colorScheme.surface),
              activeColor: context.colorScheme.primary,
              checkColor: Colors.black,
              shape: const CircleBorder(),
            ),
            Text(
              title,
              style: context.textMd?.copyWith(
                color: context.colorScheme.surface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
