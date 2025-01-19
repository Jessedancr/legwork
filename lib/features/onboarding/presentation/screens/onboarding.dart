import 'package:flutter/material.dart';
import 'package:legwork/Features/onboarding/domain/onboarding_status_check.dart';

import '../widgets/onboard_button.dart';
import '../widgets/page_indicator.dart';
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
                debugPrint('ONBOARDING LAST PAGE');
              });
            },
            children: const [
              OnboardingScreen1(),
              OnboardingScreen2(),
              OnboardingScreen3()
            ],
          ),

          // Indicator
          Positioned(
            bottom: 10.0,
            left: 40.0,
            right: 40.0,
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Indicator
                PageIndicator(
                  pageController: pageController,
                  count: 3,
                  dotColor: Theme.of(context).colorScheme.primaryContainer,
                ),
                const SizedBox(height: 10),

                // GET STARTED OR NEXT button
                isLastPage
                    ? OnboardButton(
                        buttonText: 'GET STARTED!',
                        onPressed: () async {
                          await _completeOnboarding();

                          if (!mounted) return;

                          // Navigate to the LOGIN SCREEN
                          Navigator.of(context)
                              .pushReplacementNamed('/acctType');
                        },
                      )
                    : OnboardButton(
                        buttonText: 'Next',
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
