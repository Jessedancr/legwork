import 'package:flutter/material.dart';

class LegworkFilledIconButton extends StatelessWidget {
  final Color? backgroundColor;
  final void Function()? onPressed;
  final Widget icon;
  const LegworkFilledIconButton({
    super.key,
    this.backgroundColor,
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(backgroundColor),
      ),
      onPressed: onPressed,
      icon: icon,
    );
  }
}
