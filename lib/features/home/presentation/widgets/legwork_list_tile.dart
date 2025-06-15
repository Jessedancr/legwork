import 'package:flutter/material.dart';
import 'package:legwork/core/Constants/helpers.dart';

class LegworkListTile extends StatelessWidget {
  final Widget leading;
  final Widget? title;
  final void Function()? onTap;
  final Widget? trailingWidget;
  const LegworkListTile({
    super.key,
    required this.leading,
    this.title,
    required this.onTap,
    this.trailingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: title,
      tileColor: context.colorScheme.onSurface,
      leading: leading,
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      trailing: trailingWidget,
    );
  }
}
