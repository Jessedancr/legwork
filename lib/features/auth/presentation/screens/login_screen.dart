import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:legwork/core/Enums/user_type.dart';

import 'package:provider/provider.dart';

import '../Provider/my_auth_provider.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_dropdown_menu.dart';
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
    //SCREEN SIZE
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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
                '/dancerProfileCompletionFlow',
                (route) => false,
              );
            } else if (user.userType == UserType.client.name) {
              debugPrint('CLIENT BLOCK');
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/clientProfileCompletionFlow',
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
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Image.asset(
                'images/logos/dance_icon_purple_cropped.png',
                width: screenWidth * 0.45,
                color: Theme.of(context).colorScheme.primary,
                filterQuality: FilterQuality.high,
              ),
              const SizedBox(height: 15),

              // Welcome back message
              Text(
                'Welcome back!',
                style: GoogleFonts.robotoSlab(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Login to your account',
                style: GoogleFonts.robotoCondensed(
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 5),

              // TODO: DROP DOWN MENU FOR USER TYPE

              // USERTYPE textfield
              AuthTextfield(
                controller: userTypecontroller,
                hintText: 'userType',
                obscureText: false,
                icon: Icons.person,
              ),
              const SizedBox(height: 10),

              // Email textfield
              AuthTextfield(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
                icon: Icons.email,
                helperText: 'e.g: Johndoe@gmail.com',
              ),
              const SizedBox(height: 20),

              // Password text field
              AuthTextfield(
                controller: pwController,
                hintText: 'Password',
                obscureText: true,
                icon: Icons.lock,
              ),
              const SizedBox(height: 5),

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
