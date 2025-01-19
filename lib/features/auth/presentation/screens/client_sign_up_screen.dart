import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:legwork/Features/auth/presentation/Widgets/auth_text_form_field.dart';
import 'package:legwork/core/Enums/user_type.dart';
import 'package:provider/provider.dart';

import '../Provider/my_auth_provider.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_loading_indicator.dart';
import '../widgets/auth_textfield.dart';

class ClientSignUpScreen extends StatefulWidget {
  const ClientSignUpScreen({super.key});

  @override
  State<ClientSignUpScreen> createState() => _ClientSignUpScreenState();
}

class _ClientSignUpScreenState extends State<ClientSignUpScreen> {
  // TEXTFORMFIELD KEY
  final formKey = GlobalKey<FormState>();

  // CONTROLLERS
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController organisationNameController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  final TextEditingController pwConfirmController = TextEditingController();

  // BUILD METHOD
  @override
  Widget build(BuildContext context) {
    //SCREEN SIZE
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    // Auth Provider
    var authProvider = Provider.of<MyAuthProvider>(context);

    // CLIENT SIGN UP METHOD
    void clientSignUp() async {
      if (formKey.currentState!.validate()) {
        // show loading indicator
        showLoadingIndicator(context);
        try {
          final result = await authProvider.userSignUp(
            firstName: firstNameController.text,
            lastName: lastNameController.text,
            username: usernameController.text,
            email: emailController.text,
            organisationName: organisationNameController.text,
            phoneNumber: int.parse(phoneNumberController.text),
            password: pwController.text,
            userType: UserType.client,
          );

          // hide loading indicator if mounted
          if (mounted) {
            hideLoadingIndicator(context);
          }

          result.fold((fail) {
            // Handle failure
            debugPrint(fail.toString());
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Some unknown error occured'),
              ),
            );
          }, (user) {
            // Handle success
            debugPrint('Sign-up successful: ${user.username}');
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/clientCompleteProfileScreen',
              (route) => false,
            );
          });
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
      if (pwController.text != pwConfirmController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).colorScheme.error,
            content: const Text('Passwords do not match!'),
          ),
        );
        return;
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
                    'Create your Client account',
                    style: GoogleFonts.robotoSlab(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // First name text field
                  AuthTextFormField(
                    hintText: 'First name',
                    obscureText: false,
                    controller: firstNameController,
                    icon: Icons.person,
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'First name is compulsory';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 5),

                  // Last name text field
                  AuthTextFormField(
                    hintText: 'Last name',
                    obscureText: false,
                    controller: lastNameController,
                    icon: Icons.person,
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
                    icon: Icons.person,
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Username is compulsory';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Organisation name textfield
                  AuthTextFormField(
                    hintText: 'Organisation name',
                    obscureText: false,
                    controller: organisationNameController,
                    icon: Icons.person,
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(height: 10),

                  // Email textfield
                  AuthTextFormField(
                    hintText: 'Email Address',
                    obscureText: false,
                    controller: emailController,
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'First name is compulsory';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Phone number textfield
                  AuthTextFormField(
                    hintText: 'Phone number',
                    obscureText: false,
                    controller: phoneNumberController,
                    icon: Icons.numbers,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'First name is compulsory';
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
                    icon: Icons.lock_open,
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
                    icon: Icons.lock,
                    keyboardType: TextInputType.name,
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
                    onPressed: clientSignUp,
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
