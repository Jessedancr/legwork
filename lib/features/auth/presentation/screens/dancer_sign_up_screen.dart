import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:legwork/features/auth/presentation/Widgets/auth_text_form_field.dart';
import 'package:legwork/features/auth/presentation/Widgets/legwork_snackbar_content.dart';
import 'package:legwork/core/Enums/user_type.dart';

import 'package:legwork/features/auth/presentation/Provider/my_auth_provider.dart';
import 'package:legwork/features/auth/presentation/widgets/auth_loading_indicator.dart';
import 'package:legwork/features/notifications/data/repo_impl/nottification_repo_impl.dart';

import 'package:provider/provider.dart';

import '../widgets/auth_button.dart';

class DancerSignUpScreen extends StatefulWidget {
  const DancerSignUpScreen({
    super.key,
  });

  @override
  State<DancerSignUpScreen> createState() => _DancerSignUpScreenState();
}

class _DancerSignUpScreenState extends State<DancerSignUpScreen> {
  // TEXTFORMFIELD KEY
  final formKey = GlobalKey<FormState>();

  // CONTROLLERS
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  final TextEditingController pwConfirmController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  final auth = FirebaseAuth.instance;
  final _notificationRepoImpl = NottificationRepoImpl();

  // Keeps track of the obscure text of the pw textfields
  bool obscureText = true;
  bool obscureText2 = true;

  @override
  Widget build(BuildContext context) {
    //SCREEN SIZE
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Auth Provider
    var authProvider = Provider.of<MyAuthProvider>(context);

    // Function to sign dancer in
    void dancerSignUp() async {
      if (formKey.currentState!.validate()) {
        // show loading indicator
        showLoadingIndicator(context);
        try {
          // Retrieve the device token
          final deviceToken = await _notificationRepoImpl.getDeviceToken();
          final result = await authProvider.userSignUp(
            firstName: firstNameController.text.trim(),
            lastName: lastNameController.text.trim(),
            username: usernameController.text.toLowerCase().trim(),
            email: emailController.text.toLowerCase().trim(),
            phoneNumber: int.parse(phoneNumberController.text.trim()),
            password: pwController.text.trim(),
            userType: UserType.dancer,
            deviceToken: deviceToken!,
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
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 5),
                  content: LegWorkSnackBarContent(
                    screenHeight: screenHeight,
                    context: context,
                    screenWidth: screenWidth,
                    title: 'Oh Snap!',
                    subTitle: fail,
                    contentColor: Theme.of(context).colorScheme.error,
                    imageColor: Theme.of(context).colorScheme.onError,
                  ),
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
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 5),
                content: LegWorkSnackBarContent(
                  screenHeight: screenHeight,
                  context: context,
                  screenWidth: screenWidth,
                  title: 'Oh Snap!',
                  subTitle: 'An unknown error occured',
                  contentColor: Theme.of(context).colorScheme.error,
                  imageColor: Theme.of(context).colorScheme.onError,
                ),
              ),
            );
          }
          debugPrint('SIGN-UP ERROR: $e');
        }
      }
    }

    // THIS METHOD TOGGLES THE OBSCURE TEXT PROPERTY OF THE PW TEXTFIELDS
    var viewPassword = GestureDetector(
      onTap: () {
        setState(() {
          obscureText = !obscureText;
        });
      },
      child: obscureText
          ? const Icon(Icons.remove_red_eye_outlined)
          : SvgPicture.asset(
              'assets/svg/crossed_eye.svg',
              fit: BoxFit.scaleDown,
            ),
    );

    var viewConfirmPassword = GestureDetector(
      onTap: () {
        setState(() {
          obscureText2 = !obscureText2;
        });
      },
      child: obscureText2
          ? const Icon(Icons.remove_red_eye_outlined)
          : SvgPicture.asset(
              'assets/svg/crossed_eye.svg',
              fit: BoxFit.scaleDown,
            ),
    );

    // RETURNED SCAFFOLD
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          backgroundColor: Colors.transparent,
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 10.0),
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
                    'Create your Dancer account',
                    style: GoogleFonts.robotoSlab(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // First name textfield
                  AuthTextFormField(
                    hintText: 'First name',
                    obscureText: false,
                    controller: firstNameController,
                    icon: SvgPicture.asset(
                      'assets/svg/user.svg',
                      fit: BoxFit.scaleDown,
                    ),
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'First name is compulsory';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Last name text field
                  AuthTextFormField(
                    hintText: 'last name',
                    obscureText: false,
                    controller: lastNameController,
                    icon: SvgPicture.asset(
                      'assets/svg/user.svg',
                      fit: BoxFit.scaleDown,
                    ),
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
                    icon: SvgPicture.asset(
                      'assets/svg/username.svg',
                      fit: BoxFit.scaleDown,
                    ),
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Username is compulsory';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Email textfield
                  AuthTextFormField(
                    helperText: 'Ex: johndoe@gmail.com',
                    hintText: 'email',
                    obscureText: false,
                    controller: emailController,
                    icon: SvgPicture.asset(
                      'assets/svg/mail.svg',
                      fit: BoxFit.scaleDown,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is compulsory';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),

                  // Phone number textfield
                  AuthTextFormField(
                    hintText: 'phone Number',
                    obscureText: false,
                    controller: phoneNumberController,
                    icon: SvgPicture.asset(
                      'assets/svg/address_book.svg',
                      fit: BoxFit.scaleDown,
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Phone number is compulsory';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Password textfield
                  AuthTextFormField(
                    suffixIcon: viewPassword,
                    hintText: 'password',
                    obscureText: obscureText,
                    controller: pwController,
                    icon: SvgPicture.asset(
                      'assets/svg/open_padlock.svg',
                      fit: BoxFit.scaleDown,
                    ),
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
                    suffixIcon: viewConfirmPassword,
                    hintText: 'confirm password',
                    obscureText: obscureText2,
                    controller: pwConfirmController,
                    keyboardType: TextInputType.visiblePassword,
                    icon: SvgPicture.asset(
                      'assets/svg/lock-hashtag.svg',
                      fit: BoxFit.scaleDown,
                    ),
                    validator: (value) {
                      if (pwController.text != pwConfirmController.text ||
                          value!.length < 6) {
                        return "Your passwword no match o";
                      }
                      return null;
                    },
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
        ),
      ),
    );
  }
}
