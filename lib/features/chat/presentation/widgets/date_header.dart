import 'package:flutter/material.dart';
import 'package:legwork/core/Constants/helpers.dart';

class DateHeader extends StatelessWidget {
  const DateHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: context.colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          DateTime.now().toString().substring(0, 10),
          style: context.textXs?.copyWith(
            color: Colors.grey[700],
          ),
        ),
      ),
    );
  }
}
