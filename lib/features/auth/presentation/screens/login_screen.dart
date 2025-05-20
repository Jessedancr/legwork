import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:legwork/core/Constants/helpers.dart';
import 'package:legwork/core/widgets/legwork_screen_bubble.dart';
import 'package:legwork/features/auth/domain/Entities/user_entities.dart';
import 'package:legwork/features/auth/presentation/Provider/my_auth_provider.dart';
import 'package:legwork/features/auth/presentation/Widgets/auth_text_form_field.dart';
import 'package:legwork/core/Enums/user_type.dart';
import 'package:legwork/core/widgets/legwork_snackbar.dart';
import 'package:legwork/features/auth/presentation/widgets/auth_button.dart';
import 'package:legwork/features/auth/presentation/widgets/auth_loading_indicator.dart';
import 'package:legwork/features/notifications/data/repo_impl/nottification_repo_impl.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // TEXTFORMFIELD KEY
  final formKey = GlobalKey<FormState>();

  // CONTROLLERS
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  final TextEditingController userTypecontroller = TextEditingController();

  bool obscureText = true;

  final _notificationRepoImpl = NotificationRepoImpl();

  // BUILD METHOD
  @override
  Widget build(BuildContext context) {
    // Auth Provider
    var authProvider = Provider.of<MyAuthProvider>(context);

    // LOGIN METHOD
    void userLogin() async {
      if (formKey.currentState!.validate()) {
        // show loading indicator
        showLoadingIndicator(context);

        // Attempt login
        try {
          // Retrieve the device token
          final deviceToken = await _notificationRepoImpl.getDeviceToken();

          // Create appropriate user entity based on user type
          final userType = userTypecontroller.text.trim().toLowerCase();
          UserEntity userEntity;

          // If dancer, create dancer entity
          if (userType == UserType.dancer.name) {
            userEntity = DancerEntity(
              email: emailController.text.trim(),
              password: pwController.text.trim(),
              userType: UserType.dancer.name,
              deviceToken: deviceToken!,
              firstName: '',
              lastName: '',
              phoneNumber: '',
              username: '',
            );
          }

          // If client, create client entity
          else if (userType == UserType.client.name) {
            userEntity = ClientEntity(
              email: emailController.text.trim(),
              password: pwController.text.trim(),
              userType: UserType.client.name,
              deviceToken: deviceToken!,
              firstName: '',
              lastName: '',
              phoneNumber: '',
              username: '',
            );
          }

          // Show error message if user type is invalid
          else {
            hideLoadingIndicator(context);
            LegworkSnackbar(
              title: "Invalid user type",
              subTitle: 'Please enter either "dancer" or "client"',
              imageColor: context.colorScheme.onError,
              contentColor: context.colorScheme.error,
            ).show(context);
            return;
          }

          final result = await authProvider.userlogin(userEntity: userEntity);

          if (mounted) hideLoadingIndicator(context);

          result.fold(
            // Handle failed login
            (fail) {
              debugPrint('Login failed: $fail'); // Debug message for failure
              LegworkSnackbar(
                title: 'Omo!',
                subTitle: fail,
                imageColor: context.colorScheme.error,
                contentColor: context.colorScheme.onError,
              ).show(context);
            },
            // Handle successful login
            (user) {
              debugPrint('Login successful: ${user.toString()}');
              debugPrint('Retrieved userType: ${user.userType}');
              if (user.userType == UserType.dancer.name) {
                // Navigator.of(context).pushNamedAndRemoveUntil(
                //   '/dancerApp',
                //   (route) => false,
                // );
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/dancerProfileCompletionFlow',
                  (route) => false,
                );
              } else if (user.userType == UserType.client.name) {
                // Navigator.of(context).pushNamedAndRemoveUntil(
                //   '/clientApp',
                //   (route) => false,
                // );

                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/clientProfileCompletionFlow', (route) => false);
              } else {
                LegworkSnackbar(
                  title: "Omo!",
                  subTitle: 'Invalid user type',
                  imageColor: context.colorScheme.onError,
                  contentColor: context.colorScheme.error,
                ).show(context);
              }
            },
          );
        } catch (e) {
          // CATCH ANY OTHER ERROR THAT MAY OCCUR
          if (mounted) hideLoadingIndicator(context);
          LegworkSnackbar(
            title: 'Omo!',
            subTitle: 'An unknown error occurred',
            imageColor: Theme.of(context).colorScheme.onError,
            contentColor: Theme.of(context).colorScheme.error,
          ).show(context);
          debugPrint('Error logging in: $e');
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
                child: Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon
                        Image.asset(
                          'images/logos/dance_icon_purple_cropped.png',
                          width: screenWidth(context) * 0.45,
                          color: context.colorScheme.primary,
                          filterQuality: FilterQuality.high,
                        ),
                        const SizedBox(height: 15),

                        // Welcome back message
                        Text(
                          'Welcome back!',
                          style: context.headingXs?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.colorScheme.onSurface,
                          ),
                        ),

                        Text(
                          'Login to your account',
                          style: context.textMd?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: context.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 15),

                        // Dancer or Client
                        AuthTextFormField(
                          labelText: 'Are you a dancer or a client',
                          obscureText: false,
                          controller: userTypecontroller,
                          icon: SvgPicture.asset(
                            'assets/svg/user.svg',
                            fit: BoxFit.scaleDown,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter 'dancer' or 'client'";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),

                        // Email text field
                        AuthTextFormField(
                          keyboardType: TextInputType.emailAddress,
                          labelText: 'Email',
                          obscureText: false,
                          controller: emailController,
                          icon: SvgPicture.asset(
                            'assets/svg/mail.svg',
                            fit: BoxFit.scaleDown,
                          ),
                          helperText: 'Ex: johndoe@gmail.com',
                          validator: (value) {
                            if (!value!.contains('@gmail.com') ||
                                value.isEmpty) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Password textfield
                        AuthTextFormField(
                          suffixIcon: viewPassword,
                          labelText: 'Password',
                          obscureText: obscureText,
                          controller: pwController,
                          icon: SvgPicture.asset(
                            'assets/svg/lock-hashtag.svg',
                            fit: BoxFit.scaleDown,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),

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
