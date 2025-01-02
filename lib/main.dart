import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:legwork/core/Constants/color_schemes.dart';
import 'package:legwork/features/auth/presentation/screens/account_type_or_register.dart';
import 'package:legwork/features/auth/presentation/screens/account_type_screen.dart';
import 'package:legwork/features/onboarding/data/onboarding_repo.dart';
import 'package:legwork/firebase_options.dart';

import 'features/auth/presentation/screens/client_sign_up_screen.dart';
import 'features/auth/presentation/screens/dancer_sign_up_screen.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/onboarding/domain/onboarding_status_check.dart';
import 'features/onboarding/presentation/screens/onboarding.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  // This is required in order to use async in main
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env file
  await dotenv.load(fileName: ".env");

  // Firebase setup
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
      theme: seedScheme,
      home: isOnboardingComplete
          ? AccountTypeOrRegister()
          : Onboarding(
              onboardingStatusCheck: onboardingStatusCheck,
            ),
      routes: {
        '/acctType': (context) => AccountTypeScreen(),
        '/loginScreen': (context) => LoginScreen(),
        '/clientSignUpScreen': (context) => ClientSignUpScreen(),
        '/dancerSignUpScreen': (context) => DancerSignUpScreen(),
      },
    );
  }
}
