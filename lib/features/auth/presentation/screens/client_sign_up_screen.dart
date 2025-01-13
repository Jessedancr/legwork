import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
                'Create your Client account',
                style: GoogleFonts.robotoSlab(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),

              // First name text field
              AuthTextfield(
                controller: firstNameController,
                hintText: 'First name',
                obscureText: false,
                icon: Icons.person,
              ),
              const SizedBox(height: 5),

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

              // Organisation name textfield
              AuthTextfield(
                controller: organisationNameController,
                hintText: 'Organisation name',
                obscureText: false,
                helperText: 'optional',
                icon: Icons.person,
              ),
              const SizedBox(height: 10),

              // Email textfield
              AuthTextfield(
                controller: emailController,
                hintText: 'email',
                obscureText: false,
                icon: Icons.email,
              ),
              const SizedBox(height: 10),

              // Phone number textfield
              AuthTextfield(
                controller: phoneNumberController,
                hintText: 'phone Number',
                obscureText: false,
                icon: Icons.phone,
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
              //const SizedBox(height: 10),

              // Sign up button
              AuthButton(
                buttonText: 'Sign up',
                onPressed: clientSignUp,
              )
            ],
          ),
        ),
      ),
    );
  }
}
