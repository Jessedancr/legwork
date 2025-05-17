import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:legwork/features/auth/presentation/Widgets/auth_text_form_field.dart';
import 'package:legwork/features/auth/presentation/Widgets/legwork_snackbar_content.dart';
import 'package:legwork/core/Enums/user_type.dart';
import 'package:legwork/features/notifications/data/repo_impl/nottification_repo_impl.dart';
import 'package:provider/provider.dart';

import '../Provider/my_auth_provider.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_loading_indicator.dart';

class ClientSignUpScreen extends StatefulWidget {
  const ClientSignUpScreen({super.key});

  @override
  State<ClientSignUpScreen> createState() => _ClientSignUpScreenState();
}

class _ClientSignUpScreenState extends State<ClientSignUpScreen> {
  // TEXTFORMFIELD KEY
  final formKey = GlobalKey<FormState>();

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

  final _notificationRepo = NotificationRepoImpl();

  // Keeps track of the obscure text of the pw textfields
  bool obscureText = true;
  bool obscureText2 = true;

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
      if (formKey.currentState!.validate()) {
        // show loading indicator
        showLoadingIndicator(context);
        try {
          final deviceToken = await _notificationRepo.getDeviceToken();
          final result = await authProvider.userSignUp(
            firstName: firstNameController.text,
            lastName: lastNameController.text,
            username: usernameController.text,
            email: emailController.text,
            organisationName: organisationNameController.text,
            phoneNumber: phoneNumberController.text,
            password: pwController.text,
            userType: UserType.client,
            deviceToken: deviceToken!,
          );

          // hide loading indicator if mounted
          if (mounted) {
            hideLoadingIndicator(context);
          }

          result.fold((fail) {
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
          }, (user) {
            // Handle success
            debugPrint('Sign-up successful: ${user.username}');
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/clientProfileCompletionFlow',
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
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 5),
                content: LegWorkSnackBarContent(
                  screenHeight: screenHeight,
                  context: context,
                  screenWidth: screenWidth,
                  title: 'Oh Snap!',
                  subTitle: 'An unknown error occurred',
                  contentColor: Theme.of(context).colorScheme.error,
                  imageColor: Theme.of(context).colorScheme.onError,
                ),
              ),
            );
          }
          debugPrint('SIGN-UP ERROR: $e');
        }
      }
      if (pwController.text != pwConfirmController.text) {
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
              subTitle: 'Your passwords no match o!',
              contentColor: Theme.of(context).colorScheme.error,
              imageColor: Theme.of(context).colorScheme.onError,
            ),
          ),
        );
        return;
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
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

                    // First and last name text field
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AuthTextFormField(
                          width: screenWidth * 0.4,
                          labelText: 'First name',
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

                        // Last name text field
                        AuthTextFormField(
                          width: screenWidth * 0.4,
                          labelText: 'Last name',
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
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Username textfield
                    AuthTextFormField(
                      labelText: 'username',
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

                    // Organisation name textfield
                    AuthTextFormField(
                      labelText: 'Organisation name',
                      obscureText: false,
                      controller: organisationNameController,
                      icon: SvgPicture.asset(
                        'assets/svg/username.svg',
                        fit: BoxFit.scaleDown,
                      ),
                      keyboardType: TextInputType.name,
                      helperText: 'Optional',
                    ),
                    const SizedBox(height: 10),

                    // Email textfield
                    AuthTextFormField(
                      helperText: 'Ex: johndoe@gmail.com',
                      labelText: 'Email Address',
                      obscureText: false,
                      controller: emailController,
                      icon: SvgPicture.asset(
                        'assets/svg/mail.svg',
                        fit: BoxFit.scaleDown,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'First name is compulsory';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    // Phone number textfield
                    AuthTextFormField(
                      labelText: 'Phone number',
                      obscureText: false,
                      controller: phoneNumberController,
                      icon: SvgPicture.asset(
                        'assets/svg/address_book.svg',
                        fit: BoxFit.scaleDown,
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'First name is compulsory';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    // Password textfield
                    AuthTextFormField(
                      suffixIcon: viewPassword,
                      labelText: 'password',
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
                      labelText: 'confirm password',
                      obscureText: obscureText2,
                      controller: pwConfirmController,
                      icon: SvgPicture.asset(
                        'assets/svg/lock-hashtag.svg',
                        fit: BoxFit.scaleDown,
                      ),
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (pwController.text != pwConfirmController.text ||
                            value!.length < 6) {
                          return "Your passwword no match o!, check am well";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    // Sign up button
                    AuthButton(
                      buttonText: 'Sign up',
                      onPressed: clientSignUp,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
