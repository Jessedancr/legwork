import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:legwork/Features/auth/presentation/Provider/update_profile_provider.dart';
import 'package:legwork/Features/auth/presentation/Widgets/auth_loading_indicator.dart';
import 'package:legwork/Features/auth/presentation/Widgets/legwork_elevated_button.dart';
import 'package:legwork/Features/onboarding/presentation/widgets/page_indicator.dart';
import 'package:provider/provider.dart';

import 'ClientProfileCompletion/profile_completion_screen1.dart';
import 'ClientProfileCompletion/profile_completion_screen2.dart';
import 'ClientProfileCompletion/profile_completion_screen3.dart';

class ClientProfileCompletionFlow extends StatefulWidget {
  final String email;
  const ClientProfileCompletionFlow({
    super.key,
    required this.email,
  });

  @override
  State<ClientProfileCompletionFlow> createState() =>
      _ClientProfileCompletionFlowState();
}

class _ClientProfileCompletionFlowState
    extends State<ClientProfileCompletionFlow> {
  final auth = FirebaseAuth.instance;

  // CONTROLLERS
  final PageController pageController = PageController();
  final TextEditingController bioController = TextEditingController();

  // This keeps track on if we are on the lasr page
  bool isLastPage = false;

  // BUILD METHOD
  @override
  Widget build(BuildContext context) {
    //SCREEN SIZE
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // PROVIDER
    final updateProfileProvider = Provider.of<UpdateProfileProvider>(context);

    // SAVE AND UPDATE PROFILE
    void saveAndUpdateProfile() async {
      showLoadingIndicator(context);
      try {
        await updateProfileProvider.updateProfileExecute(
          data: {
            'bio': bioController.text,
            'jobPrefs': selectedSkills,
          },
        );
        hideLoadingIndicator(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile Updated'),
          ),
        );

        Navigator.of(context).pushNamedAndRemoveUntil(
          '/clientHomeScreen',
          (route) => false,
        );
      } catch (e) {
        debugPrint('error updating profile');
        hideLoadingIndicator(context);
        debugPrint('Error updating profile: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e')),
        );
      }
    }

    // NAVIGATE TO NEXT PAGE
    void nextPage() {
      pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }

    // RETURNED WIDGET
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // Page view
            PageView(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (value) {
                setState(() {
                  isLastPage = (value == 2);
                  debugPrint('CLIENT PROFILE COMPLETION LAST PAGE');
                });
              },
              children: [
                ProfileCompletionScreen1(
                  email: auth.currentUser!.email,
                  bioController: bioController,
                ),
                ProfileCompletionScreen2(),
                ProfileCompletionScreen3(),
              ],
            ),

            // PAGE INDICATOR
            Positioned(
              bottom: screenHeight * 0.1,
              left: screenWidth * 0.45,
              child: PageIndicator(
                pageController: pageController,
                count: 3,
              ),
            ),

            // BUTTONS
            Positioned(
              bottom: screenHeight * 0.01,
              left: screenWidth * 0.05,
              child: Row(
                children: [
                  // PREVIOUS PAGE BUTTON
                  IconButton(
                    onPressed: () {
                      // back to previous screen
                      pageController.previousPage(
                          duration: const Duration(microseconds: 500),
                          curve: Curves.easeInOut);
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  SizedBox(width: screenWidth * 0.05),

                  // SAVE AND CONTINUE BUTTON
                  isLastPage
                      ? LegworkElevatedButton(
                          buttonText: 'Save and continue',
                          onPressed: saveAndUpdateProfile,
                        )
                      : LegworkElevatedButton(
                          onPressed: nextPage,
                          buttonText: 'Next',
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
