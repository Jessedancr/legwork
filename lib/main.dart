import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:legwork/features/auth/Data/RepoImpl/resume_repo_impl.dart';
import 'package:legwork/features/auth/presentation/Provider/resume_provider.dart';
import 'package:legwork/features/auth/presentation/Screens/auth_status.dart';
import 'package:legwork/features/chat/presentation/provider/chat_provider.dart';
import 'package:legwork/features/chat/presentation/screens/chat_detail_screen.dart';
import 'package:legwork/features/home/data/models/job_model.dart';
import 'package:legwork/features/home/data/repo_impl/job_repo_impl.dart';
import 'package:legwork/features/home/presentation/provider/job_provider.dart';
import 'package:legwork/features/home/presentation/screens/client_screens/client_app.dart';
import 'package:legwork/features/home/presentation/screens/dancer_screens/dancer_app.dart';
import 'package:legwork/features/home/presentation/screens/dancer_screens/dancer_settings_screen.dart';
import 'package:legwork/features/job_application/data/models/job_application_model.dart';
import 'package:legwork/features/job_application/data/repo_impl/job_application_repo_impl.dart';
import 'package:legwork/features/job_application/domain/business_logic/get_job_applicants_business_logic.dart';
import 'package:legwork/features/job_application/presentation/provider/job_application_provider.dart';
import 'package:legwork/features/job_application/presentation/screens/apply_for_job_screen.dart';
import 'package:legwork/features/job_application/presentation/screens/job_application_details_screen.dart';
import 'package:legwork/features/job_application/presentation/screens/view_job_applicants_screen.dart';
import 'package:legwork/features/notifications/data/data_sources/notification_remote_data_source.dart';

import 'package:legwork/core/Constants/color_schemes.dart';
import 'package:legwork/features/auth/Data/RepoImpl/auth_repo_impl.dart';
import 'package:legwork/features/auth/presentation/Provider/my_auth_provider.dart';
import 'package:legwork/features/auth/presentation/Screens/account_type_screen.dart';
import 'package:legwork/features/auth/presentation/Screens/client_profile_completion_flow.dart';
import 'package:legwork/features/onboarding/data/onboarding_repo.dart';
import 'package:legwork/firebase_options.dart';
import 'package:provider/provider.dart';

import 'features/auth/presentation/Provider/update_profile_provider.dart';
import 'features/auth/presentation/Screens/client_sign_up_screen.dart';
import 'features/auth/presentation/Screens/dancer_sign_up_screen.dart';
import 'features/auth/presentation/Screens/dancer_profile_completion_flow.dart';
import 'features/auth/presentation/Screens/login_screen.dart';
import 'features/home/presentation/screens/client_screens/client_home_screen.dart';
import 'features/home/presentation/screens/client_screens/client_settings_screen.dart';
import 'features/onboarding/domain/onboarding_status_check.dart';
import 'features/onboarding/presentation/screens/onboarding.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  // This is required in order to use async in main
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize hive
  await Hive.initFlutter();

  // Register JobApplicationModel adapter
  Hive.registerAdapter(JobApplicationModelAdapter());

  // Register JobModel adapter
  Hive.registerAdapter(JobModelAdapter());

  // Open job applications Hive box
  await Hive.openBox<JobApplicationModel>('job_applications_box');

  // Open jobs hive box
  await Hive.openBox<JobModel>('jobs_box');

  // Load .env file
  await dotenv.load(fileName: ".env");

  // Firebase setup
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Instane of Notification remote data source
  final notificationRemoteDataSource = NotificationRemoteDataSourceImpl(
    firebaseMessaging: FirebaseMessaging.instance,
  );

  await notificationRemoteDataSource.setupFlutterNotifications();

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

  // Instance of Job repo
  final jobRepo = JobRepoImpl();

  // Instance of job application repo
  final jobApplicationRepo = JobApplicationRepoImpl();

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
        ChangeNotifierProvider(
          create: (context) => JobProvider(jobRepo: jobRepo),
        ),
        ChangeNotifierProvider(
          create: (context) => JobApplicationProvider(
            jobApplicationRepo: jobApplicationRepo,
            getJobApplicantsBusinessLogic: GetJobApplicantsBusinessLogic(
              jobApplicationRepo: jobApplicationRepo,
            ),
          ),
        ),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
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
        '/loginScreen': (context) => const LoginScreen(),
        '/clientSignUpScreen': (context) => const ClientSignUpScreen(),
        '/dancerSignUpScreen': (context) => const DancerSignUpScreen(),
        '/dancerProfileCompletionFlow': (context) =>
            const DancerProfileCompletionFlow(),
        '/clientProfileCompletionFlow': (context) =>
            ClientProfileCompletionFlow(
              email: auth.currentUser!.email ?? '',
            ),
        '/dancerApp': (context) => const DancerApp(),
        '/clientHomeScreen': (context) => ClientHomeScreen(),
        '/dancerSettingsScreen': (context) => const DancerSettingsScreen(),
        '/clientApp': (context) => const ClientApp(),
        '/clientSettingsScreen': (context) => const ClientSettingsScreen(),
        '/applyForJob': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments as Map<String, String>;
          return ApplyForJobScreen(
            jobId: args['jobId'] ?? '',
            clientId: args['clientId'] ?? '',
            jobDescr: args['jobDescr'] ?? '',
            clientImageUrl: '',
          );
        },
        '/viewJobApplicantsScreen': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments as Map<String, String>;

          // Provide default values if arguments are null or incomplete
          final jobId = args['jobId'] ?? '';
          final clientId = args['clientId'] ?? '';

          return ViewJobApplicantsScreen(
            jobId: jobId,
            clientId: clientId,
          );
        },
        '/job_application_detail': (context) =>
            const JobApplicationDetailScreen(),
        '/chatDetailScreen': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments as Map<String, String>;
          final conversationId = args['conversationId'] ?? '';
          final otherParticipantId = args['otherParticipantId'] ?? '';

          return ChatDetailScreen(
            conversationId: conversationId,
            otherParticipantId: otherParticipantId,
          );
        }
      },
    );
  }
}
