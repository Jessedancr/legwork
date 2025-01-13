import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/account_type_button.dart';

//TODO: COME BACK TO ADD A SPLASH EFFECT ON THE BUTTONS

class AccountTypeScreen extends StatefulWidget {
  const AccountTypeScreen({super.key});

  @override
  State<AccountTypeScreen> createState() => _AccountTypeScreenState();
}

class _AccountTypeScreenState extends State<AccountTypeScreen> {
  @override
  Widget build(BuildContext context) {
    // Screen size
    final screenHeight = MediaQuery.of(context).size.height;
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Account Type',
                  style: GoogleFonts.robotoSlab(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  'Please Choose Your Profession',
                  style: GoogleFonts.robotoCondensed(),
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
                  child: Text(
                    'Login',
                    style: GoogleFonts.robotoCondensed(
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
