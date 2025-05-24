import 'package:flutter/material.dart';
import 'package:legwork/core/Constants/helpers.dart';

class LegworkListTile extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final void Function()? onTap;
  const LegworkListTile({
    super.key,
    required this.leading,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: title,
      tileColor: context.colorScheme.scrim,
      leading: leading,
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}
