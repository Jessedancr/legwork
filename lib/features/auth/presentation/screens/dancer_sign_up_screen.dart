import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:legwork/core/Constants/helpers.dart';
import 'package:legwork/core/widgets/legwork_screen_bubble.dart';
import 'package:legwork/core/widgets/legwork_snackbar.dart';
import 'package:legwork/features/auth/domain/Entities/user_entities.dart';
import 'package:legwork/features/auth/presentation/Widgets/auth_text_form_field.dart';
import 'package:legwork/core/enums/user_type.dart';
import 'package:legwork/features/auth/presentation/Provider/my_auth_provider.dart';
import 'package:legwork/features/auth/presentation/widgets/auth_button.dart';
import 'package:legwork/features/auth/presentation/widgets/auth_loading_indicator.dart';
import 'package:legwork/features/notifications/data/repo_impl/nottification_repo_impl.dart';

import 'package:provider/provider.dart';

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

  final _notificationRepoImpl = NotificationRepoImpl();

  // Keeps track of the obscure text of the pw textfields
  bool obscureText = true;
  bool obscureText2 = true;

  @override
  Widget build(BuildContext context) {
    // Auth Provider
    var authProvider = Provider.of<MyAuthProvider>(context);

    // Function to sign dancer in
    void dancerSignUp() async {
      if (formKey.currentState!.validate()) {
        // show loading indicator
        showLoadingIndicator(context);
        try {
          final deviceToken = await _notificationRepoImpl.getDeviceToken();

          final dancerEntity = DancerEntity(
            firstName: firstNameController.text.trim(),
            lastName: lastNameController.text.trim(),
            username: usernameController.text.toLowerCase().trim(),
            email: emailController.text.trim(),
            password: pwController.text,
            phoneNumber: phoneNumberController.text,
            userType: UserType.dancer.name,
            deviceToken: deviceToken!,
          );
          // Retrieve the device token
          final result = await authProvider.userSignUp(
            userEntity: dancerEntity,
          );

          if (mounted) {
            hideLoadingIndicator(context);
          }
          // hide loading indicator if mounted

          result.fold(
            (fail) {
              // Handle failure
              debugPrint(fail.toString());
              LegworkSnackbar(
                title: 'Omo!',
                subTitle: fail,
                imageColor: context.colorScheme.onError,
                contentColor: context.colorScheme.error,
              ).show(context);
            },
            (user) {
              // Handle success
              debugPrint('Sign-up successful: ${user.username}');
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/dancerProfileCompletionFlow',
                (route) => false,
                arguments: dancerEntity,
              );
            },
          );
        } catch (e) {
          // Hide loading circle after failed sign up
          // and display snackbar with error message
          if (mounted) {
            LegworkSnackbar(
              title: 'Omo!',
              subTitle: 'An unknown error occured',
              imageColor: context.colorScheme.error,
              contentColor: context.colorScheme.onError,
            ).show(context);
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
              color: context.colorScheme.onPrimaryContainer,
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
              color: context.colorScheme.onPrimaryContainer,
              fit: BoxFit.scaleDown,
            ),
    );

    // RETURNED SCAFFOLD
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // * Top circular container
            const LegworkScreenBubble(
              outerCircularAvatarRadius: 60,
              innerCircularAvatarRadius: 47,
              right: -30,
              top: -20,
              xAlignValue: 1,
              yAlignValue: -0.8,
            ),

            // * Bottom circular container
            const LegworkScreenBubble(
              outerCircularAvatarRadius: 60,
              innerCircularAvatarRadius: 47,
              left: -30,
              bottom: -20,
              xAlignValue: -1,
              yAlignValue: 0.8,
            ),

            // * Main screen content
            Center(
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
                          width: screenWidth(context) * 0.45,
                          color: context.colorScheme.primary,
                          filterQuality: FilterQuality.high,
                        ),
                        const SizedBox(height: 10),

                        // create your account
                        Text(
                          'Create your Dancer account',
                          style: context.text2Xl?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // First name textfield
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AuthTextFormField(
                              width: screenWidth(context) * 0.4,
                              labelText: 'First name',
                              obscureText: false,
                              controller: firstNameController,
                              icon: SvgPicture.asset(
                                'assets/svg/user.svg',
                                fit: BoxFit.scaleDown,
                                color: context.colorScheme.onPrimaryContainer,
                              ),
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'compulsory';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),

                            // Last name text field
                            AuthTextFormField(
                              width: screenWidth(context) * 0.40,
                              labelText: 'last name',
                              obscureText: false,
                              controller: lastNameController,
                              icon: SvgPicture.asset(
                                'assets/svg/user.svg',
                                color: context.colorScheme.onPrimaryContainer,
                                fit: BoxFit.scaleDown,
                              ),
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'compulsory';
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
                            color: context.colorScheme.onPrimaryContainer,
                            fit: BoxFit.scaleDown,
                          ),
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'compulsory';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),

                        // Email textfield
                        AuthTextFormField(
                          helperText: 'Ex: johndoe@gmail.com',
                          labelText: 'email',
                          obscureText: false,
                          controller: emailController,
                          icon: SvgPicture.asset(
                            'assets/svg/mail.svg',
                            color: context.colorScheme.onPrimaryContainer,
                            fit: BoxFit.scaleDown,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'compulsory';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),

                        // Phone number textfield
                        AuthTextFormField(
                          labelText: 'phone Number',
                          obscureText: false,
                          controller: phoneNumberController,
                          icon: SvgPicture.asset(
                            'assets/svg/address_book.svg',
                            color: context.colorScheme.onPrimaryContainer,
                            fit: BoxFit.scaleDown,
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'compulsory';
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
                            color: context.colorScheme.onPrimaryContainer,
                            fit: BoxFit.scaleDown,
                          ),
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value!.length < 6) {
                              return 'Your password no strong reach o';
                            } else if (pwController.text !=
                                pwConfirmController.text) {
                              return "Your passwword no match o";
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
                          keyboardType: TextInputType.visiblePassword,
                          icon: SvgPicture.asset(
                            'assets/svg/lock-hashtag.svg',
                            color: context.colorScheme.onPrimaryContainer,
                            fit: BoxFit.scaleDown,
                          ),
                          validator: (value) {
                            if (pwController.text != pwConfirmController.text) {
                              return "Your passwword no match o";
                            } else if (value!.length < 6) {
                              'Your password no strong reach o';
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

            // * Custom app bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.only(top: 10, left: 10),
                child: IconButton(
                  alignment: const Alignment(-1, 0),
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_ios),
                  color: context.colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
