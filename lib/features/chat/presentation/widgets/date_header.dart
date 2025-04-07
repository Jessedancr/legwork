import 'package:flutter/material.dart';

class DateHeader extends StatelessWidget {
  const DateHeader({
    super.key,
    required this.theme,
  });

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          DateTime.now().toString().substring(0, 10),
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
          ),
        ),
      ),
    );
  }
}
