import 'package:dartz/dartz.dart' hide State;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:legwork/core/enums/user_type.dart';
import 'package:legwork/features/auth/presentation/screens/clients_home_screen.dart';
import 'package:provider/provider.dart';

import '../Provider/my_auth_provider.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_loading_indicator.dart';
import '../widgets/auth_textfield.dart';
import 'dancers_home_screen.dart';

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

  final auth = FirebaseAuth.instance;

  // BUILD METHOD
  @override
  Widget build(BuildContext context) {
    // Auth Provider
    var authProvider = Provider.of<MyAuthProvider>(context);

    // LOGIN METHOD
    void userLogin() async {
      const UserType userType = UserType.dancer;
      // show loading indicator
      showLoadingIndicator(context);
      try {
        final result = await authProvider.userlogin(
          email: emailController.text,
          password: pwController.text,
          userType: userType,
        );

        if (mounted) hideLoadingIndicator(context);

        result.fold(
          // Handle failed login
          (fail) {
            ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(
                content: Text(fail),
              ),
            );
          },
          (user) {
            // Handle successful login
            debugPrint('Login successful: ${user.username}');
            if (userType == UserType.dancer) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/dancersHomeScreen',
                (route) => false,
              );
            } else {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/clientsHomeScreen',
                (route) => false,
              ); // This is client's homepage
            }
          },
        );
      } catch (e) {
        if (mounted) {
          hideLoadingIndicator(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
            ),
          );
        }
        debugPrint('Error loggin in: $e');
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
              const Text('User log Sign Up'),

              // Email textfield
              AuthTextfield(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
              ),
              const SizedBox(height: 10),

              // Password text field
              AuthTextfield(
                controller: pwController,
                hintText: 'Password',
                obscureText: true,
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
                onPressed: userLogin,
              )
            ],
          ),
        ),
      ),
    );
  }
}
