import 'package:flutter/material.dart';
import 'package:legwork/core/Constants/helpers.dart';
import 'package:legwork/features/onboarding/presentation/widgets/onboard_bottom_gradient.dart';

class OnboardingScreen1 extends StatelessWidget {
  const OnboardingScreen1({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            height: screenHeight(context),
            width: screenWidth(context),
            color: context.colorScheme.surface,
            child: Image.asset(
              'images/OnboardingImages/onboarding_image1.jpg',
              fit: BoxFit.cover,
              width: screenWidth(context),
              height: screenHeight(context),
              cacheWidth: (screenWidth(context) * 2.7).toInt(),
              cacheHeight: (screenHeight(context) * 2).toInt(),
              filterQuality: FilterQuality.medium,
            ),
          ),

          // Content
          Container(
            alignment: const Alignment(0, 1),
            child: OnboardBottomGradient(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Title
                    Text(
                      'Welcome To Legwork!',
                      style: context.headingSm?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // Subtitle
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 10.0,
                      ),
                      child: Text(
                        'Empowering Nigerian dancers: Join the platform that puts your talents to work',
                        textAlign: TextAlign.center,
                        style: context.textXl?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
