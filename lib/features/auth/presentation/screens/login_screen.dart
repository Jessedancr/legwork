import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:legwork/core/enums/user_type.dart';

import 'package:provider/provider.dart';

import '../Provider/my_auth_provider.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_loading_indicator.dart';
import '../widgets/auth_textfield.dart';

//TODO: BUILD OUT THE UI ONCE DONE INTEGRATING WITH FIREBASE
/**
 * TODO: FIND A WAY TO LOG USER IN
 * TODO: WITHOUT EXPLICITILY ASKING FOR USER TYPE DURING LOGGING PROCCESS
 */

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // CONTROLLERS
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  final TextEditingController userTypecontroller = TextEditingController();

  final auth = FirebaseAuth.instance;

  // BUILD METHOD
  @override
  Widget build(BuildContext context) {
    // Auth Provider
    var authProvider = Provider.of<MyAuthProvider>(context);

    // LOGIN METHOD
    void userLogin() async {
      // show loading indicator
      showLoadingIndicator(context);

      // Attempt login
      try {
        final result = await authProvider.userlogin(
          email: emailController.text,
          password: pwController.text,
          userType: userTypecontroller.text,
        );

        if (mounted) hideLoadingIndicator(context);

        result.fold(
          // Handle failed login
          (fail) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Error logging in'),
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
                '/dancersHomeScreen',
                (route) => false,
              );
            } else if (user.userType == UserType.client.name) {
              debugPrint('CLIENT BLOCK');
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/clientsHomeScreen',
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
        if (mounted) {
          hideLoadingIndicator(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Omo something went wrong sha'),
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

              // USERTYPE textfield
              AuthTextfield(
                controller: userTypecontroller,
                hintText: 'userType',
                obscureText: false,
              ),
              const SizedBox(height: 10),

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
