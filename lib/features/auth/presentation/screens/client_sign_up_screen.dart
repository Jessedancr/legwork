import 'package:flutter/material.dart';
import 'package:legwork/core/enums/user_type.dart';
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
              '/clientsHomeScreen',
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
              const Text('CLIENT SIGN UP'),

              // First name text field
              AuthTextfield(
                controller: firstNameController,
                hintText: 'First name',
                obscureText: false,
              ),
              const SizedBox(height: 5),

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

              // Organisation name textfield
              AuthTextfield(
                controller: organisationNameController,
                hintText: 'Organisation name',
                obscureText: false,
                helperText: 'optional',
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
