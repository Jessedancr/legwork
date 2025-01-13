import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:legwork/core/Enums/user_type.dart';

import 'package:legwork/Features/auth/presentation/Provider/my_auth_provider.dart';
import 'package:legwork/Features/auth/presentation/widgets/auth_loading_indicator.dart';

import 'package:legwork/Features/auth/presentation/widgets/auth_textfield.dart';
import 'package:provider/provider.dart';

import '../widgets/auth_button.dart';

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
    //SCREEN SIZE
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Auth Provider
    var authProvider = Provider.of<MyAuthProvider>(context);

    // Function to sign dancer in
    void dancerSignUp() async {
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
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: SingleChildScrollView(
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

              // FIRST AND LAST NAME TEXTFIELDS
              AuthTextfield(
                controller: firstNameController,
                hintText: 'First name',
                obscureText: false,
                icon: Icons.person,
              ),
              const SizedBox(height: 10),

              // Last name text field
              AuthTextfield(
                controller: lastNameController,
                hintText: 'Last name',
                obscureText: false,
                icon: Icons.person,
              ),
              const SizedBox(height: 10),

              // Username textfield
              AuthTextfield(
                controller: usernameController,
                hintText: 'Username',
                obscureText: false,
                icon: Icons.person,
              ),
              const SizedBox(height: 10),

              // Dance styles textfield
              AuthTextfield(
                controller: danceStylesController,
                hintText: 'Dance styles',
                obscureText: false,
                icon: Icons.person,
              ),
              const SizedBox(height: 10),

              // Email textfield
              AuthTextfield(
                controller: emailController,
                hintText: 'email',
                obscureText: false,
                icon: Icons.email,
                helperText: 'e.g: johndoe@gmail.com',
              ),
              const SizedBox(height: 18),

              // Phone number textfield
              AuthTextfield(
                controller: phoneNumberController,
                hintText: 'phone Number',
                obscureText: false,
                icon: Icons.numbers,
              ),
              const SizedBox(height: 10),

              // Password textfield
              AuthTextfield(
                controller: pwController,
                hintText: 'password',
                obscureText: true,
                icon: Icons.lock_open,
              ),
              const SizedBox(height: 10),

              // Confirm password textfield
              AuthTextfield(
                controller: pwConfirmController,
                hintText: 'confirm password',
                obscureText: true,
                icon: Icons.lock,
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
    );
  }
}
