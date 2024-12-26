import 'package:shared_preferences/shared_preferences.dart';

/**
 * LOCAL STORAGE IMPLEMENTATION
 * This class simply interacts with the shared_preferences package to store and retrieve data.
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
    late final SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboarding_complete') ?? false;
  }

  @override
  Future<void> onboardingCompleted() async {
    late final SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    prefs.setBool('onboarding_complete', true);
  }
}
