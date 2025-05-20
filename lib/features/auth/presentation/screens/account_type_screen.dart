import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:legwork/core/Constants/helpers.dart';
import 'package:legwork/core/widgets/legwork_screen_bubble.dart';
import 'package:legwork/features/auth/presentation/widgets/account_type_button.dart';

class AccountTypeScreen extends StatefulWidget {
  const AccountTypeScreen({super.key});

  @override
  State<AccountTypeScreen> createState() => _AccountTypeScreenState();
}

class _AccountTypeScreenState extends State<AccountTypeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.colorScheme.surface,
        body: Stack(
          children: [
            // * Top circular Bubble
            const LegworkScreenBubble(
              outerCircularAvatarRadius: 60,
              innerCircularAvatarRadius: 47,
              right: -30,
              top: -20,
              xAlignValue: 1,
              yAlignValue: -0.8,
            ),

            // * Bottom circular Bubble
            const LegworkScreenBubble(
              outerCircularAvatarRadius: 60,
              innerCircularAvatarRadius: 47,
              left: -30,
              bottom: -20,
              xAlignValue: -1,
              yAlignValue: 0.8,
            ),

            // * Main screen content
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo
                Image.asset(
                  'images/logos/dance_icon_purple_cropped.png',
                  color: context.colorScheme.primary,
                  width: screenWidth(context) * 0.4,
                ),
                const SizedBox(height: 20),

                // Select Account Type
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Select Account Type',
                      style: context.headingXs?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Please Choose Your Profession',
                    )
                  ],
                ),
                const SizedBox(height: 20),

                // Dancer Acct Button
                AccountTypeButton(
                  icon: SvgPicture.asset(
                    'assets/svg/disco_ball.svg',
                    color: context.colorScheme.onPrimary,
                    height: 40,
                  ),
                  buttonText: 'Dancer',
                  onTap: () =>
                      Navigator.of(context).pushNamed('/dancerSignUpScreen'),
                ),
                const SizedBox(height: 20),

                // Client Acct button
                AccountTypeButton(
                  icon: SvgPicture.asset(
                    'assets/svg/briefcase.svg',
                    color: context.colorScheme.onPrimary,
                    height: 40,
                  ),
                  buttonText: 'Client',
                  onTap: () =>
                      Navigator.of(context).pushNamed('/clientSignUpScreen'),
                ),
                const SizedBox(height: 20),

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
                        style: context.text2Xl?.copyWith(
                          color: context.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
