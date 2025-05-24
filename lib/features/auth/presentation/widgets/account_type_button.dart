import 'package:flutter/material.dart';
import 'package:legwork/core/Constants/helpers.dart';

class AccountTypeButton extends StatelessWidget {
  final String buttonText;
  final Function()? onTap;
  final Widget icon;
  const AccountTypeButton({
    super.key,
    required this.buttonText,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // Returned Widget
    return Ink(
      height: screenHeight(context) * 0.15,
      width: screenWidth(context) * 0.85,
      decoration: BoxDecoration(
        color: context.colorScheme.primary,
        borderRadius: BorderRadius.circular(30),
      ),
      child: InkWell(
        splashColor: context.colorScheme.primary,
        splashFactory: InkSplash.splashFactory,
        borderRadius: BorderRadius.circular(30),
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Acct type icon
            icon,

            Text(
              buttonText,
              style: context.text2Xl?.copyWith(
                color: context.colorScheme.onPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),

            Icon(
              Icons.arrow_forward_ios,
              size: 20,
              color: context.colorScheme.onPrimary,
            )
          ],
        ),
      ),
    );
  }
}
