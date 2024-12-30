import 'package:flutter/material.dart';
import 'package:legwork/core/Constants/color_schemes.dart';
import 'package:legwork/features/auth/presentation/screens/login_screen.dart';
import 'package:legwork/features/onboarding/data/onboarding_repo.dart';

import 'features/onboarding/domain/onboarding_status_check.dart';
import 'features/onboarding/presentation/screens/onboarding.dart';

void main() async {
  // This is required in order to use async in main
  WidgetsFlutterBinding.ensureInitialized();

  // Instance of onboarding repo
  final onboardingRepo = OnboardingRepoImpl();

  // Instance of onboarding status check
  final onboardingStatusCheck = OnboardingStatusCheck(repo: onboardingRepo);

  // Check if onboarding is complete
  final isOnboardingComplete =
      await onboardingStatusCheck.isOnboardingCompleteCall();

  runApp(MyApp(
    isOnboardingComplete: isOnboardingComplete,
    onboardingStatusCheck: onboardingStatusCheck,
  ));
}

class MyApp extends StatelessWidget {
  final OnboardingStatusCheck onboardingStatusCheck;
  final bool isOnboardingComplete;
  const MyApp({
    super.key,
    required this.onboardingStatusCheck,
    required this.isOnboardingComplete,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      home: isOnboardingComplete
          ? const LoginScreen()
          : Onboarding(
              onboardingStatusCheck: onboardingStatusCheck,
            ),
      routes: {
        '/login': (context) => LoginScreen(),
      },
    );
  }
}
