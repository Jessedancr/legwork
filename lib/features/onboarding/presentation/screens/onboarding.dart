import 'package:flutter/material.dart';
import 'package:legwork/core/Constants/helpers.dart';
import 'package:legwork/features/onboarding/domain/onboarding_status_check.dart';
import 'package:legwork/features/onboarding/presentation/widgets/onboard_button.dart';
import 'package:legwork/features/onboarding/presentation/widgets/page_indicator.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'onboarding_screen2.dart';
import 'onboarding_screen3.dart';
import 'onboarding_screen1.dart';

class Onboarding extends StatefulWidget {
  final OnboardingStatusCheck onboardingStatusCheck;
  const Onboarding({
    super.key,
    required this.onboardingStatusCheck,
  });

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  // Controller to keep track of what page we are on
  final PageController pageController = PageController();

  // This keeps track on if we are on the lasr page
  bool isLastPage = false;

  // Preload images
  @override
  void initState() {
    super.initState();
    // Preload images in the background
    // * addPostFrameCallback waits for the widget to fully render before running _preloadImages()
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _preloadImages();
    });
  }

  Future<void> _preloadImages() async {
    // if (!mounted) return;

    // * Access flutter's image cache in the PaintingBinding class
    final imageCache = PaintingBinding.instance.imageCache;
    // Increase the cache size
    imageCache.maximumSize = 100;
    imageCache.maximumSizeBytes = 100 << 20; // 100 MB

    // Preload all onboarding images
    await Future.wait([
      precacheImage(
          const AssetImage('images/OnboardingImages/onboarding_image1.jpg'),
          context),
      precacheImage(
        const AssetImage('images/OnboardingImages/onboarding_image2.jpg'),
        context,
      ),
      precacheImage(
        const AssetImage('images/OnboardingImages/onboarding_image3.jpg'),
        context,
      ),
    ]);

    // Remove splash screen after images are loaded
    FlutterNativeSplash.remove();
    debugPrint('Onboarding images loaded, splash screen removed');
  }

  // calls the "call" method from the OnboardingStatusCheck class
  Future<void> _completeOnboarding() async {
    // Mark onboarding as complete
    await widget.onboardingStatusCheck.onboardingCompletedCall();

    // Remove splash screen when onboarding is completed
    FlutterNativeSplash.remove();
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

          // Indicator + button
          Positioned(
            bottom: screenHeight(context) * 0.03,
            left: screenWidth(context) * 0.1,
            right: screenWidth(context) * 0.1,
            child: Column(
              children: [
                // Indicator
                PageIndicator(
                  pageController: pageController,
                  count: onBoardingScreens.length,
                ),
                const SizedBox(height: 10),

                // Button
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
