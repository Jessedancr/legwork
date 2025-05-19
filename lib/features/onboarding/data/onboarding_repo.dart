import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/**
 * LOCAL STORAGE IMPLEMENTATION
 * This class interacts with the shared_preferences package to store and retrieve data.
 */

abstract class OnboardingRepo {
  // This function checks if onboarding is complete
  Future<bool> isOnboardingComplete();

  // This function marks onboarding as complete
  Future<void> onboardingCompleted();
}

class OnboardingRepoImpl implements OnboardingRepo {
  @override
  Future<bool> isOnboardingComplete() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    debugPrint('Checking if onboarding is complete');
    return prefs.getBool('onboarding_complete') ?? false;
  }

  @override
  Future<void> onboardingCompleted() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('onboarding_complete', true);
    debugPrint('Your onboarding is compelete');
  }
}
