import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:legwork/Features/auth/presentation/Widgets/auth_text_form_field.dart';
import 'package:legwork/core/Enums/user_type.dart';

import 'package:legwork/Features/auth/presentation/Provider/my_auth_provider.dart';
import 'package:legwork/Features/auth/presentation/widgets/auth_loading_indicator.dart';

import 'package:provider/provider.dart';

import '../widgets/auth_button.dart';

class DancerSignUpScreen extends StatefulWidget {
  const DancerSignUpScreen({
    super.key,
  });

  @override
  State<DancerSignUpScreen> createState() => _DancerSignUpScreenState();
}

class _DancerSignUpScreenState extends State<DancerSignUpScreen> {
  // TEXTFORMFIELD KEY
  final formKey = GlobalKey<FormState>();

  // CONTROLLERS
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  final TextEditingController pwConfirmController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController danceStylesController = TextEditingController();

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    //SCREEN SIZE
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Auth Provider
    var authProvider = Provider.of<MyAuthProvider>(context);

    // Function to sign dancer in
    void dancerSignUp() async {
      if (formKey.currentState!.validate()) {
        // show loading indicator
        showLoadingIndicator(context);
        try {
          final result = await authProvider.userSignUp(
            firstName: firstNameController.text.trim(),
            lastName: lastNameController.text.trim(),
            username: usernameController.text.toLowerCase().trim(),
            email: emailController.text.toLowerCase().trim(),
            phoneNumber: int.parse(phoneNumberController.text.trim()),
            password: pwController.text.trim(),
            danceStyles: danceStylesController.text
                .trim()
                .split(RegExp(r'(\s*,\s)+'))
                .where((style) => style
                    .isNotEmpty) // Remove empty entries => entries that meet the condition will stay
                .toList(),
            userType: UserType.dancer,
          );

          if (mounted) {
            hideLoadingIndicator(context);
          }
          // hide loading indicator if mounted

          result.fold(
            (fail) {
              // Handle failure
              debugPrint(fail.toString());
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(fail),
                ),
              );
            },
            (user) {
              // Handle success
              debugPrint('Sign-up successful: ${user.username}');
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/dancerProfileCompletionFlow',
                (route) => false,
              );
            },
          );
        } catch (e) {
          // Hide loading circle after failed sign up
          // and display snackbar with error message
          if (mounted) {
            hideLoadingIndicator(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.toString()),
              ),
            );
          }
          debugPrint('SIGN-UP ERROR: $e');
        }
      }
    }

    // RETURNED SCAFFOLD
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          backgroundColor: Colors.transparent,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  // Icon
                  Image.asset(
                    'images/logos/dance_icon_purple_cropped.png',
                    width: screenWidth * 0.45,
                    color: Theme.of(context).colorScheme.primary,
                    filterQuality: FilterQuality.high,
                  ),

                  // create your account
                  Text(
                    'Create your Dancer account',
                    style: GoogleFonts.robotoSlab(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // First name textfield
                  AuthTextFormField(
                    hintText: 'First name',
                    obscureText: false,
                    controller: firstNameController,
                    icon: const Icon(Icons.person_outline),
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'First name is compulsory';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Last name text field
                  AuthTextFormField(
                    hintText: 'last name',
                    obscureText: false,
                    controller: lastNameController,
                    icon: const Icon(Icons.person_outline),
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Last name is compulsory';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Username textfield
                  AuthTextFormField(
                    hintText: 'username',
                    obscureText: false,
                    controller: usernameController,
                    icon: Image.asset(
                      'images/icons/username.png',
                      width: 0.5,
                      height: 0.5,
                    ),
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Username is compulsory';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Dance styles textfield
                  AuthTextFormField(
                    helperText: 'Separate each dance style with a comma',
                    hintText: 'dance styles',
                    obscureText: false,
                    controller: danceStylesController,
                    icon: SizedBox(
                      width: screenWidth * 0.8,
                      height: screenHeight * 0.8,
                      child: Image.asset(
                        'images/icons/dance.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please fill in your dance styles, abi you no wan see job ni';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Email textfield
                  AuthTextFormField(
                    hintText: 'email',
                    obscureText: false,
                    controller: emailController,
                    icon: const Icon(Icons.email_outlined),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is compulsory';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),

                  // Phone number textfield
                  AuthTextFormField(
                    hintText: 'phone Number',
                    obscureText: false,
                    controller: phoneNumberController,
                    icon: const Icon(Icons.numbers),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Phone number is compulsory';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Password textfield
                  AuthTextFormField(
                    hintText: 'password',
                    obscureText: true,
                    controller: pwController,
                    icon: const Icon(Icons.lock_open),
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value) {
                      if (value!.length < 6) {
                        return 'This your password no strong reach o';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Confirm password textfield
                  AuthTextFormField(
                    hintText: 'confirm password',
                    obscureText: true,
                    controller: pwConfirmController,
                    keyboardType: TextInputType.visiblePassword,
                    icon: const Icon(Icons.lock_outline_rounded),
                    validator: (value) {
                      if (pwController.text != pwConfirmController.text ||
                          value!.length < 6) {
                        return "Your passwword no match o!, check am well";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Sign up button
                  AuthButton(
                    buttonText: 'Sign up',
                    onPressed: dancerSignUp,
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
