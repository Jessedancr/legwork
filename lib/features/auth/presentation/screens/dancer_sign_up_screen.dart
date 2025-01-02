import 'package:flutter/material.dart';
import 'package:legwork/features/auth/presentation/widgets/auth_textfield.dart';

import '../widgets/auth_button.dart';

//TODO: PROPERLY BUILD OUT THE UI ONCE DONE INTEGRATING WITH FIREBASE

class DancerSignUpScreen extends StatefulWidget {
  const DancerSignUpScreen({super.key});

  @override
  State<DancerSignUpScreen> createState() => _DancerSignUpScreenState();
}

class _DancerSignUpScreenState extends State<DancerSignUpScreen> {
  // Controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  final TextEditingController pwConfirmController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
