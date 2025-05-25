import 'package:flutter/material.dart';
import 'package:legwork/core/Constants/helpers.dart';

import '../widgets/onboard_bottom_gradient.dart';

class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({
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
            color: Theme.of(context).colorScheme.surface,
            child: Image.asset(
              'images/OnboardingImages/onboarding_image2.jpg',
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
                      'Discover Opportunities!',
                      style: context.headingSm?.copyWith(
                        color: context.colorScheme.surface,
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
                        'Connect with top gigs and showcase your talent effortlessly',
                        textAlign: TextAlign.center,
                        style: context.textXl?.copyWith(
                          color: context.colorScheme.surface,
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
