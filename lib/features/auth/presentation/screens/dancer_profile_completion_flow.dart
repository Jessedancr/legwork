//import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:legwork/Features/auth/presentation/Provider/update_profile_provider.dart';
import 'package:legwork/Features/auth/presentation/Screens/DancerProfileCompletion/profile_completion_screen1.dart';
import 'package:legwork/Features/auth/presentation/Widgets/auth_loading_indicator.dart';
import 'package:provider/provider.dart';

import '../../../onboarding/presentation/widgets/page_indicator.dart';
import 'DancerProfileCompletion/profile_completion_screen2.dart';
import 'DancerProfileCompletion/profile_completion_screen3.dart';

class DancerProfileCompletionFlow extends StatefulWidget {
  const DancerProfileCompletionFlow({
    super.key,
  });

  @override
  State<DancerProfileCompletionFlow> createState() =>
      _DancerProfileCompletionFlowState();
}

class _DancerProfileCompletionFlowState
    extends State<DancerProfileCompletionFlow> {
  final auth = FirebaseAuth.instance;

  // CONTROLLERS
  final PageController pageController = PageController();
  final TextEditingController bioController = TextEditingController();

  // This keeps track on if we are on the lasr page
  bool isLastPage = false;

  // BUILD METHOD
  @override
  Widget build(BuildContext context) {
    // PROVIDER
    final updateProfileProvider = Provider.of<UpdateProfileProvider>(context);

    // SAVE AND UPDATE PROFILE
    void saveAndUpdateProfile() async {
      showLoadingIndicator(context);
      try {
        await updateProfileProvider.updateProfileExecute(
          data: {
            'bio': bioController.text,
          },
        );
        hideLoadingIndicator(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile Updated'),
          ),
        );
        // Navigate to next page
        pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
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

    // RETURNED SCAFFOLD
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
                  debugPrint('DANCER PROFILE COMPLETION LAST PAGE');
                });
              },
              children: [
                const ProfileCompletionScreen2(),
                ProfileCompletionScreen1(
                  email: auth.currentUser!.email,
                  bioController: bioController,
                ),
                const ProfileCompletionScreen3(),
              ],
            ),

            // PAGE INDICATOR
            Positioned(
              bottom: 60,
              left: 150,
              child: PageIndicator(
                pageController: pageController,
                count: 3,
              ),
            ),

            // BUTTONS
            Positioned(
              bottom: 10,
              left: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                  // SKIP BUTTON
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to next page
                      pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: const Text('Skip'),
                  ),

                  // SAVE AND CONTINUE BUTTON
                  ElevatedButton(
                    onPressed: saveAndUpdateProfile,
                    child: const Text('Save and Continue'),
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
