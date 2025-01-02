import 'package:flutter/material.dart';

import '../widgets/auth_button.dart';
import '../widgets/auth_textfield.dart';

//TODO: BUILD OUT THE UI ONCE DONE INTEGRATING WITH FIREBASE

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // CONTROLLERS
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
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
              const Text('User log Sign Up'),

              // Email textfield
              AuthTextfield(
                controller: emailController,
                hintText: 'First name',
                obscureText: false,
              ),
              const SizedBox(height: 10),

              // Password text field
              AuthTextfield(
                controller: pwController,
                hintText: 'Last name',
                obscureText: false,
              ),
              const SizedBox(height: 10),

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
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
