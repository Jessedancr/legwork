import 'package:flutter/material.dart';

class LegworkDrawerTile extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final void Function()? onTap;
  const LegworkDrawerTile({
    super.key,
    required this.leading,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 20.0,
        horizontal: 10,
      ),
      child: ListTile(
        title: title,
        tileColor: Theme.of(context).colorScheme.onPrimaryContainer,
        leading: leading,
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }
}
