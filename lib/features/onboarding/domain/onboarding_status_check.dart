import '../data/onboarding_repo.dart';

/**
 * This class simply calls the "isOnboardingComplete" method 
 * in the "OnboardingRepo" class
 */

class OnboardingStatusCheck {
  final OnboardingRepo repo;

  // constructor
  OnboardingStatusCheck({required this.repo});

  Future<bool> isOnboardingCompleteCall() async {
    return await repo.isOnboardingComplete();
  }
}
