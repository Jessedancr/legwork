import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:legwork/core/network/online_payment_info.dart';
import 'package:legwork/features/auth/Data/RepoImpl/resume_repo_impl.dart';
import 'package:legwork/features/auth/domain/Entities/user_entities.dart';
import 'package:legwork/features/auth/presentation/Provider/resume_provider.dart';
import 'package:legwork/features/auth/presentation/Screens/auth_status.dart';
import 'package:legwork/features/chat/presentation/provider/chat_provider.dart';
import 'package:legwork/features/chat/presentation/screens/chat_detail_screen.dart';
import 'package:legwork/features/home/data/models/job_model.dart';
import 'package:legwork/features/home/presentation/provider/job_provider.dart';
import 'package:legwork/features/home/presentation/screens/client_screens/client_app.dart';
import 'package:legwork/features/home/presentation/screens/client_screens/edit_client_profile_screen.dart';
import 'package:legwork/features/home/presentation/screens/dancer_screens/dancer_app.dart';
import 'package:legwork/features/home/presentation/screens/dancer_screens/dancer_settings_screen.dart';
import 'package:legwork/features/home/presentation/screens/dancer_screens/edit_profile_screen.dart';
import 'package:legwork/features/job_application/data/models/job_application_model.dart';
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
import 'package:legwork/features/payment/data/data_sources/payment_remote_data_source.dart';
import 'package:legwork/features/payment/data/repo_impl/payment_repo_impl.dart';
import 'package:legwork/features/payment/domain/business_logic/initialize_transaction_business_logic.dart';
import 'package:legwork/features/payment/domain/business_logic/verify_transaction_business_logic.dart';
import 'package:legwork/features/payment/presentation/provider/payment_provider.dart';
import 'package:legwork/features/payment/presentation/screens/payment_screen.dart';
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
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Preserve splash screen until we explicitly remove it
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

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

  final notificationRemoteDataSource = NotificationRemoteDataSourceImpl();

  await notificationRemoteDataSource.setupFlutterNotifications();

  // Call isOnboardingComplete from OnboardingStatusCheck
  final isOnboardingComplete =
      OnboardingStatusCheck().isOnboardingCompleteCall();

  // Instance of auth repo
  final authRepo = AuthRepoImpl();

  // Instance of Resume repo
  final resumeRepo = ResumeRepoImpl();

  final onlinePaymentInfo = OnlinePaymentInfo(
    baseUrl: dotenv.env['PAYSTACK_API_BASE_URL']!,
    secretKey: dotenv.env['PAYSTACK_TEST_SECRET_KEY']!,
  );

  // INSTANCE OF PAYMENT REMOTE DATA SOURCE
  final paymentRemoteDataSource = PaymentRemoteDataSource(
    onlinePaymentInfo: onlinePaymentInfo,
  );

  // INSTANCE OF PAYMENT REPO
  final paymentRepo = PaymentRepoImpl(
    paymentRemoteDataSource: paymentRemoteDataSource,
  );

  // If onboarding is complete, remove splash screen
  if (await isOnboardingComplete) {
    await Future.delayed(const Duration(seconds: 3), () {
      debugPrint('Onboarding is complete, removing splash screen');
      FlutterNativeSplash.remove();
    });
  }

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
          create: (context) => JobProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => JobApplicationProvider(),
        ),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(
          create: (_) => PaymentProvider(
            initTransactionBusinessLogic:
                InitTransactionBusinessLogic(repo: paymentRepo),
            verifyTransactionBusinessLogic:
                VerifyTransactionBusinessLogic(repo: paymentRepo),
          ),
        ),
      ],
      child: MyApp(
        isOnboardingComplete: await isOnboardingComplete,
      ),
    ),
  );
}

// * MY APP
class MyApp extends StatelessWidget {
  final onboardingStatusCheck = OnboardingStatusCheck();
  final bool isOnboardingComplete;
  final auth = FirebaseAuth.instance;

  MyApp({
    super.key,
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
        '/dancerProfileCompletionFlow': (context) {
          final dancerDetails =
              ModalRoute.of(context)!.settings.arguments as DancerEntity;
          return DancerProfileCompletionFlow(
            dancerDetails: dancerDetails,
          );
        },
        '/clientProfileCompletionFlow': (context) {
          final clientDetails =
              ModalRoute.of(context)!.settings.arguments as ClientEntity;

          return ClientProfileCompletionFlow(
            clientDetails: clientDetails,
          );
        },
        '/dancerApp': (context) => const DancerApp(),
        '/clientHomeScreen': (context) => ClientHomeScreen(),
        '/dancerSettingsScreen': (context) => const DancerSettingsScreen(),
        '/clientApp': (context) => const ClientApp(),
        '/clientSettingsScreen': (context) => const ClientSettingsScreen(),
        '/applyForJob': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as JobModel;

          return ApplyForJobScreen(
            jobEntity: args,
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
        },
        '/paymentScreen': (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          final amt = args['amount'] ?? 0.0;
          final email = args['email'] ?? '';
          final dancerId = args['dancerId'] ?? '';
          final clientId = args['clientId'] ?? '';
          return PaymentScreen(
            amount: amt,
            email: email,
            dancerId: dancerId,
            clientId: clientId,
          );
        },
        '/editProfileScreen': (context) {
          final dancerDetails =
              ModalRoute.of(context)!.settings.arguments as DancerEntity;

          return EditProfileScreen(dancerDetails: dancerDetails);
        },
        '/editClientProfileScreen': (context) {
          final clientDetails =
              ModalRoute.of(context)!.settings.arguments as ClientEntity;

          return EditClientProfileScreen(clientDetails: clientDetails);
        },
      },
    );
  }
}
