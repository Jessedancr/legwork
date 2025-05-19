import 'package:legwork/features/onboarding/data/onboarding_repo.dart';

/**
 * This class simply calls the methods from the OnboardingRepo class
 */

class OnboardingStatusCheck {
  final OnboardingRepo repo = OnboardingRepoImpl();

  Future<bool> isOnboardingCompleteCall() async {
    return await repo.isOnboardingComplete();
  }

  Future<void> onboardingCompletedCall() async {
    return await repo.onboardingCompleted();
  }
}
