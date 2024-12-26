import 'package:flutter/material.dart';
import 'package:legwork/features/onboarding/domain/onboarding_status_check.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../widgets/onboard_button.dart';
import 'onboarding_screen2.dart';
import 'onboarding_screen3.dart';
import 'welcome_screen1.dart';

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
    final repo = widget.onboardingStatusCheck.repo;
    await repo.onboardingCompleted(); // to mark onboarding as complete
  }

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
                isLastPage = (value == 2);
                debugPrint('LAST PAGE');
              });
            },
            children: const [
              WelcomeScreen1(),
              OnboardingScreen2(),
              OnboardingScreen3()
            ],
          ),

          // Indicator
          Container(
            alignment: const Alignment(0, 0.75),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Skip button
                OnboardButton(
                  buttonText: 'SKIP',
                  onPressed: () => pageController.jumpToPage(2),
                ),

                // Indicator
                SmoothPageIndicator(
                  effect: const SwapEffect(),
                  controller: pageController,
                  count: 3,
                ),

                // GET STARTED OR NEXT button
                isLastPage
                    ? OnboardButton(
                        buttonText: 'GET STARTED!',
                        onPressed: () async {
                          await _completeOnboarding();

                          if (!mounted) return;

                          // Navigate to the LOGIN SCREEN
                          Navigator.of(context).pushReplacementNamed('/login');
                        },
                      )
                    : OnboardButton(
                        buttonText: 'NEXT',
                        onPressed: () {
                          pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
                      )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
