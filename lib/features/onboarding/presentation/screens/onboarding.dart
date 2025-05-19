import 'package:flutter/material.dart';
import 'package:legwork/features/onboarding/domain/onboarding_status_check.dart';
import 'package:legwork/features/onboarding/presentation/widgets/onboard_button.dart';
import 'package:legwork/features/onboarding/presentation/widgets/page_indicator.dart';

import 'onboarding_screen2.dart';
import 'onboarding_screen3.dart';
import 'onboarding_screen1.dart';

class Onboarding extends StatefulWidget {
  final OnboardingStatusCheck onboardingStatusCheck;
  const Onboarding({super.key, required this.onboardingStatusCheck});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  // Controller to keep track of what page we are on
  final PageController pageController = PageController();

  // This keeps track on if we are on the lasr page
  bool isLastPage = false;

  // calls the "call" method from the OnboardingStatusCheck class
  Future<void> _completeOnboarding() async {
    // Mark onboarding as complete
    await widget.onboardingStatusCheck.onboardingCompletedCall();
  }

  // List of Onborading screens
  List<Widget> onBoardingScreens = const [
    OnboardingScreen1(),
    OnboardingScreen2(),
    OnboardingScreen3()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Page view
          PageView(
            controller: pageController,
            onPageChanged: (value) {
              setState(() {
                isLastPage = (value == onBoardingScreens.length - 1);
              });
              if (isLastPage) {
                debugPrint('Onboarding Last page');
              }
            },
            children: onBoardingScreens,
          ),

          // Indicator
          Positioned(
            bottom: 10.0,
            left: 40.0,
            right: 40.0,
            child: Column(
              children: [
                // Indicator
                PageIndicator(
                  pageController: pageController,
                  count: onBoardingScreens.length,
                ),
                const SizedBox(height: 10),

                // GET STARTED OR NEXT BUTTON
                OnboardButton(
                  buttonText: isLastPage ? 'Get Started!' : 'Next',
                  onPressed: isLastPage
                      ? () async {
                          await _completeOnboarding();

                          if (!mounted) return;

                          // Navigate to the LOGIN SCREEN
                          Navigator.of(context)
                              .pushReplacementNamed('/acctType');
                        }
                      : () {
                          pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
