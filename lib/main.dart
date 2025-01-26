import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:legwork/Features/auth/Data/RepoImpl/resume_repo_impl.dart';
import 'package:legwork/Features/auth/presentation/Provider/resume_provider.dart';
import 'package:legwork/Features/auth/presentation/Screens/auth_status.dart';
import 'package:legwork/Features/home/presentation/screens/dancer_screens/app.dart';
import 'package:legwork/Features/home/presentation/screens/dancer_screens/dancer_settings_screen.dart';

import 'package:legwork/core/Constants/color_schemes.dart';
import 'package:legwork/Features/auth/Data/RepoImpl/auth_repo_impl.dart';
import 'package:legwork/Features/auth/presentation/Provider/my_auth_provider.dart';
import 'package:legwork/Features/auth/presentation/Screens/account_type_or_register.dart';
import 'package:legwork/Features/auth/presentation/Screens/account_type_screen.dart';
import 'package:legwork/Features/auth/presentation/Screens/client_profile_completion_flow.dart';
import 'package:legwork/Features/onboarding/data/onboarding_repo.dart';
import 'package:legwork/firebase_options.dart';
import 'package:provider/provider.dart';

import 'Features/auth/presentation/Provider/update_profile_provider.dart';
import 'Features/auth/presentation/Screens/client_sign_up_screen.dart';
import 'Features/auth/presentation/Screens/dancer_sign_up_screen.dart';
import 'Features/auth/presentation/Screens/dancer_profile_completion_flow.dart';
import 'Features/auth/presentation/Screens/login_screen.dart';
import 'Features/home/presentation/screens/client_home_screen.dart';
import 'Features/onboarding/domain/onboarding_status_check.dart';
import 'Features/onboarding/presentation/screens/onboarding.dart';

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

  // Instance of auth repo
  final authRepo = AuthRepoImpl();

  // Instance of Resume repo
  final resumeRepo = ResumeRepoImpl();

  // THIS FUNCTION IS CALLED WHEN THE APP IS LAUNCHED
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MyAuthProvider(authRepo: authRepo),
        ),
        ChangeNotifierProvider(
          create: (context) => ResumeProvider(resumeRepo: resumeRepo),
        ),
        ChangeNotifierProvider(
          create: (context) => UpdateProfileProvider(),
        ),
      ],
      child: MyApp(
        onboardingStatusCheck: onboardingStatusCheck,
        isOnboardingComplete: isOnboardingComplete,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final OnboardingStatusCheck onboardingStatusCheck;
  final bool isOnboardingComplete;
  final auth = FirebaseAuth.instance;

  MyApp({
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
          ? AuthStatus()
          : Onboarding(
              onboardingStatusCheck: onboardingStatusCheck,
            ),
      routes: {
        '/acctType': (context) => const AccountTypeScreen(),
        '/loginScreen': (context) => LoginScreen(),
        '/clientSignUpScreen': (context) => ClientSignUpScreen(),
        '/dancerSignUpScreen': (context) => DancerSignUpScreen(),
        '/dancerProfileCompletionFlow': (context) =>
            const DancerProfileCompletionFlow(),
        '/clientProfileCompletionFlow': (context) =>
            ClientProfileCompletionFlow(
              email: auth.currentUser!.email ?? '',
            ),
        '/dancerApp': (context) => App(),
        '/clientHomeScreen': (context) => ClientHomeScreen(),
        '/dancerSettingsScreen': (context) => DancerSettingsScreen()
      },
    );
  }
}
