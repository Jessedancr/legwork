//import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:legwork/Features/auth/presentation/Provider/resume_provider.dart';
import 'package:legwork/Features/auth/presentation/Screens/DancerProfileCompletion/profile_completion_screen1.dart';
import 'package:provider/provider.dart';

import '../../../onboarding/presentation/widgets/page_indicator.dart';
import 'DancerProfileCompletion/profile_completion_screen2.dart';
import 'DancerProfileCompletion/profile_completion_screen3.dart';

class DancerProfileCompletionFlow extends StatefulWidget {
  //final String userEmail;
  const DancerProfileCompletionFlow({
    super.key,
    //this.userEmail,
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
 

  // This keeps track on if we are on the lasr page
  bool isLastPage = false;

  // BUILD METHOD
  @override
  Widget build(BuildContext context) {
    // RETURNED SCAFFOLD
    return Scaffold(
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
              ProfileCompletionScreen1(
                email: auth.currentUser!.email,
                
              ),
              const ProfileCompletionScreen2(),
              const ProfileCompletionScreen3(),
            ],
          ),

          // BUTTONS AND INDICATOR
          Positioned(
            bottom: 10,
            left: 40,
            right: 40,
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

                // PAGE INDICATOR
                PageIndicator(
                  pageController: pageController,
                  count: 3,
                ),

                // SAVE AND CONTINUE BUTTON
                ElevatedButton(
                  onPressed: () {
                    // Navigate to next page
                    pageController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: const Text('Continue'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
