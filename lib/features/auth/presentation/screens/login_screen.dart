import 'package:dartz/dartz.dart' hide State;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:legwork/Features/auth/presentation/Widgets/auth_text_form_field.dart';
import 'package:legwork/core/Enums/user_type.dart';

import 'package:provider/provider.dart';

import '../Provider/my_auth_provider.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_dropdown_menu.dart';
import '../widgets/auth_loading_indicator.dart';
import '../widgets/auth_textfield.dart';

//TODO: BUILD OUT THE UI ONCE DONE INTEGRATING WITH FIREBASE

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // TEXTFORMFIELD KEY
  final formKey = GlobalKey<FormState>();

  // CONTROLLERS
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  final TextEditingController userTypecontroller = TextEditingController();

  final auth = FirebaseAuth.instance;

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
          final result = await authProvider.userlogin(
            email: emailController.text,
            password: pwController.text.toLowerCase(),
            userType: userTypecontroller.text.toLowerCase(),
          );

          if (mounted) hideLoadingIndicator(context);

          result.fold(
            // Handle failed login
            (fail) {
              debugPrint('Login failed: $fail'); // Debug message for failure
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  content: Text(fail),
                ),
              );
            },
            // Handle successful login
            (user) {
              debugPrint('Login successful: ${user.toString()}');
              debugPrint('Retrieved userType: ${user.userType}');
              if (user.userType == UserType.dancer.name) {
                debugPrint('DANCER BLOCK');
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/dancerProfileCompletionFlow',
                  (route) => false,
                );
              } else if (user.userType == UserType.client.name) {
                debugPrint('CLIENT BLOCK');
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/clientProfileCompletionFlow',
                  (route) => false,
                ); // This is client's homepage
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Invalid user type'),
                  ),
                );
              }
            },
          );
        } catch (e) {
          // CATCH ANY OTHER ERROR THAT MAY OCCUR
          if (mounted) hideLoadingIndicator(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Theme.of(context).colorScheme.error,
              content: const Text('Something went wrong. Please try again.'),
            ),
          );
          debugPrint('Error logging in: $e');
        }
      }
    }

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

                  // TODO: DROP DOWN MENU FOR USER TYPE
                  AuthTextFormField(
                    hintText: 'Are you a dancer or a client',
                    obscureText: false,
                    controller: userTypecontroller,
                    icon: Icons.person,
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
                    hintText: 'Email',
                    obscureText: false,
                    controller: emailController,
                    icon: Icons.email,
                    validator: (value) {
                      if (!value!.contains('@gmail.com') || value.isEmpty) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Password text field
                  // AuthTextfield(
                  //   controller: pwController,
                  //   hintText: 'Password',
                  //   obscureText: true,
                  //   icon: Icons.lock,
                  // ),
                  AuthTextFormField(
                    hintText: 'Password',
                    obscureText: true,
                    controller: pwController,
                    icon: Icons.lock,
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
