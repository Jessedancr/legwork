import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountTypeButton extends StatelessWidget {
  final String buttonText;
  final Function()? onTap;
  final dynamic icon;
  const AccountTypeButton({
    super.key,
    required this.buttonText,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // Screen size
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Returned Widget
    return Ink(
      height: screenHeight * 0.15,
      width: screenWidth * 0.85,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(30),
      ),
      child: InkWell(
        splashColor: Colors.grey,
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
              style: TextStyle(
                fontFamily: 'RobotoCondensed',
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),

            Icon(
              Icons.arrow_forward,
              size: 30,
              color: Theme.of(context).colorScheme.onPrimary,
            )
          ],
        ),
      ),
    );
  }
}
