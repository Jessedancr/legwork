import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:legwork/features/auth/presentation/Widgets/auth_text_form_field.dart';
import 'package:legwork/features/auth/presentation/Widgets/legwork_snackbar_content.dart';

import 'package:legwork/core/Enums/user_type.dart';

import 'package:legwork/core/widgets/legwork_snackbar.dart';

import 'package:provider/provider.dart';

import '../Provider/my_auth_provider.dart';
import '../widgets/auth_button.dart';

import '../widgets/auth_loading_indicator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // final _notificationRemoteDataSourceImpl =
  //     NotificationRemoteDataSourceImpl(firebaseMessaging: fir);
  // TEXTFORMFIELD KEY
  final formKey = GlobalKey<FormState>();

  // CONTROLLERS
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  final TextEditingController userTypecontroller = TextEditingController();

  final auth = FirebaseAuth.instance;

  bool obscureText = true;

  // BUILD METHOD
  @override
  Widget build(BuildContext context) {
    //SCREEN SIZE
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Auth Provider
    var authProvider = Provider.of<MyAuthProvider>(context);

    // LOGIN METHOD
    void userLogin() async {
      if (formKey.currentState!.validate()) {
        // show loading indicator
        showLoadingIndicator(context);

        // Attempt login
        try {
          // Retrieve the device token
          final deviceToken = await FirebaseMessaging.instance.getToken();
          final result = await authProvider.userlogin(
            email: emailController.text.trim(),
            password: pwController.text.trim(),
            userType: userTypecontroller.text.trim().toLowerCase(),
            deviceToken: deviceToken!,
          );

          if (mounted) hideLoadingIndicator(context);

          result.fold(
            // Handle failed login
            (fail) {
              debugPrint('Login failed: $fail'); // Debug message for failure

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 5),
                  content: LegWorkSnackBarContent(
                    screenHeight: screenHeight,
                    context: context,
                    screenWidth: screenWidth,
                    title: 'Oh snap!',
                    subTitle: fail,
                    contentColor: Theme.of(context).colorScheme.error,
                    imageColor: Theme.of(context).colorScheme.onError,
                  ),
                ),
              );
            },
            // Handle successful login
            (user) {
              debugPrint('Login successful: ${user.toString()}');
              debugPrint('Retrieved userType: ${user.userType}');
              if (user.userType == UserType.dancer.name) {
                debugPrint('DANCER BLOCK');
                // Navigator.of(context).pushNamedAndRemoveUntil(
                //   '/dancerProfileCompletionFlow',
                //   (route) => false,
                // );

                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/dancerApp',
                  (route) => false,
                );
              } else if (user.userType == UserType.client.name) {
                // Navigator.of(context).pushNamedAndRemoveUntil(
                //   '/clientProfileCompletionFlow',
                //   (route) => false,
                // ); // This is client's homepage

                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/clientApp',
                  (route) => false,
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 5),
                    content: LegWorkSnackBarContent(
                      screenHeight: screenHeight,
                      context: context,
                      screenWidth: screenWidth,
                      title: 'Oh Snap!',
                      subTitle: 'Invalid user type',
                      contentColor: Theme.of(context).colorScheme.error,
                      imageColor: Theme.of(context).colorScheme.onError,
                    ),
                  ),
                );
              }
            },
          );
        } catch (e) {
          // CATCH ANY OTHER ERROR THAT MAY OCCUR
          if (mounted) hideLoadingIndicator(context);
          LegworkSnackbar(
            title: 'Oops!',
            subTitle: 'An unknown error occurred',
            imageColor: Theme.of(context).colorScheme.onError,
            contentColor: Theme.of(context).colorScheme.error,
          ).show(context);
          debugPrint('Error logging in: $e');
        }
      }
    }

    // THIS METHOD TOGGLES THE OBSCURE TEXT PROPERTY OF THE PW TEXTFIELDS
    var viewPassword = GestureDetector(
      onTap: () {
        setState(() {
          obscureText = !obscureText;
        });
      },
      child: obscureText
          ? const Icon(Icons.remove_red_eye_outlined)
          : SvgPicture.asset(
              'assets/svg/crossed_eye.svg',
              fit: BoxFit.scaleDown,
            ),
    );

    // RETURNED SCAFFOLD
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon
                  Image.asset(
                    'images/logos/dance_icon_purple_cropped.png',
                    width: screenWidth * 0.45,
                    color: Theme.of(context).colorScheme.primary,
                    filterQuality: FilterQuality.high,
                  ),
                  const SizedBox(height: 15),

                  // Welcome back message
                  Text(
                    'Welcome back!',
                    style: GoogleFonts.robotoSlab(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Login to your account',
                    style: GoogleFonts.robotoCondensed(
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 5),

                  // Dancer or Client
                  AuthTextFormField(
                    hintText: 'Are you a dancer or a client',
                    obscureText: false,
                    controller: userTypecontroller,
                    icon: SvgPicture.asset(
                      'assets/svg/user.svg',
                      fit: BoxFit.scaleDown,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter 'dancer' or 'client'";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Email text field
                  AuthTextFormField(
                    keyboardType: TextInputType.emailAddress,
                    hintText: 'Email',
                    obscureText: false,
                    controller: emailController,
                    icon: SvgPicture.asset(
                      'assets/svg/mail.svg',
                      fit: BoxFit.scaleDown,
                    ),
                    helperText: 'Ex: johndoe@gmail.com',
                    validator: (value) {
                      if (!value!.contains('@gmail.com') || value.isEmpty) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Password textfield
                  AuthTextFormField(
                    suffixIcon: viewPassword,
                    hintText: 'Password',
                    obscureText: obscureText,
                    controller: pwController,
                    icon: SvgPicture.asset(
                      'assets/svg/lock-hashtag.svg',
                      fit: BoxFit.scaleDown,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 5),

                  // Forgot password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text('Forgot password?'),
                      ),
                    ],
                  ),

                  // Login button
                  AuthButton(
                    buttonText: 'Login',
                    onPressed: userLogin,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
