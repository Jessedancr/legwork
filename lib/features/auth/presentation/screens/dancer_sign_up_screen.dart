import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:legwork/core/enums/user_type.dart';

import 'package:legwork/features/auth/presentation/Provider/my_auth_provider.dart';
import 'package:legwork/features/auth/presentation/widgets/auth_loading_indicator.dart';

import 'package:legwork/features/auth/presentation/widgets/auth_textfield.dart';
import 'package:provider/provider.dart';

import '../widgets/auth_button.dart';
import 'package:legwork/features/auth/presentation/screens/dancers_home_screen.dart';

//TODO: PROPERLY BUILD OUT THE UI ONCE DONE INTEGRATING WITH FIREBASE

class DancerSignUpScreen extends StatefulWidget {
  const DancerSignUpScreen({
    super.key,
  });

  @override
  State<DancerSignUpScreen> createState() => _DancerSignUpScreenState();
}

class _DancerSignUpScreenState extends State<DancerSignUpScreen> {
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
    // Auth Provider
    var authProvider = Provider.of<MyAuthProvider>(context);

    // Function to sign dancer in
    void dancerSignUpFunction() async {
      if (pwController.text != pwConfirmController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Passwords do not match!'),
          ),
        );
        return;
      } else {
        // show loading indicator
        showLoadingIndicator(context);
        try {
          final result = await authProvider.userSignUp(
            firstName: firstNameController.text,
            lastName: lastNameController.text,
            username: usernameController.text,
            email: emailController.text,
            phoneNumber: int.parse(phoneNumberController.text),
            password: pwController.text,
            danceStyles: danceStylesController.text.split(','),
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
                const SnackBar(
                  content: Text('Some unknown error occured'),
                ),
              );
            },
            (user) {
              // Handle success
              debugPrint('Sign-up successful: ${user.username}');
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => DancersHomeScreen(
                    uid: auth.currentUser!.uid,
                  ),
                ),
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
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Icon
              const Icon(
                Icons.person,
                size: 50,
              ),

              // Some texr for the form
              const Text('Dancer Sign Up'),

              // First name text field
              AuthTextfield(
                controller: firstNameController,
                hintText: 'First name',
                obscureText: false,
              ),
              const SizedBox(height: 10),

              // Last name text field
              AuthTextfield(
                controller: lastNameController,
                hintText: 'Last name',
                obscureText: false,
              ),
              const SizedBox(height: 10),

              // Username textfield
              AuthTextfield(
                controller: usernameController,
                hintText: 'Username',
                obscureText: false,
              ),
              const SizedBox(height: 10),

              // Dance styles textfield
              AuthTextfield(
                controller: danceStylesController,
                hintText: 'Dance styles',
                obscureText: false,
              ),
              const SizedBox(height: 10),

              // Email textfield
              AuthTextfield(
                controller: emailController,
                hintText: 'email',
                obscureText: false,
              ),
              const SizedBox(height: 10),

              // Phone number textfield
              AuthTextfield(
                controller: phoneNumberController,
                hintText: 'phone Number',
                obscureText: false,
              ),
              const SizedBox(height: 10),

              // Password textfield
              AuthTextfield(
                controller: pwController,
                hintText: 'password',
                obscureText: true,
              ),
              const SizedBox(height: 10),

              // Confirm password textfield
              AuthTextfield(
                controller: pwConfirmController,
                hintText: 'confirm password',
                obscureText: true,
              ),
              const SizedBox(height: 10),

              // Sign up button
              AuthButton(
                buttonText: 'Sign up',
                onPressed: dancerSignUpFunction,
              )
            ],
          ),
        ),
      ),
    );
  }
}
