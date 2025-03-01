import 'package:flutter/material.dart';

import '../widgets/account_type_button.dart';

class AccountTypeScreen extends StatefulWidget {
  const AccountTypeScreen({super.key});

  @override
  State<AccountTypeScreen> createState() => _AccountTypeScreenState();
}

class _AccountTypeScreenState extends State<AccountTypeScreen> {
  @override
  Widget build(BuildContext context) {
    // Screen size
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            Image.asset(
              'images/logos/dance_icon_purple_cropped.png',
              color: Theme.of(context).colorScheme.primary,
              width: screenWidth * 0.4,
            ),

            // Select Account Type
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Account Type',
                  style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Please Choose Your Profession',
                  style: TextStyle(fontFamily: 'RobotoCondensed'),
                )
              ],
            ),
            const SizedBox(height: 15),

            // Dancer Acct Button
            AccountTypeButton(
              icon: Image.asset(
                'images/icons/nobg_dancer_icon.png',
                filterQuality: FilterQuality.high,
                height: 110,
              ),
              buttonText: 'Dancer',
              onTap: () =>
                  Navigator.of(context).pushNamed('/dancerSignUpScreen'),
            ),
            const SizedBox(height: 15),

            // Client Acct button
            AccountTypeButton(
              icon: Icon(
                Icons.person,
                size: 60,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              buttonText: 'Client',
              onTap: () =>
                  Navigator.of(context).pushNamed('/clientSignUpScreen'),
            ),
            const SizedBox(height: 15),

            // Already have an acct? Login
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account?'),
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed('/loginScreen'),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontFamily: 'RobotoCondensed',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
