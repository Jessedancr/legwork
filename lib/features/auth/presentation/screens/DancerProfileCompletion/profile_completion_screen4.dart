import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:legwork/core/Constants/helpers.dart';
import 'package:legwork/features/auth/presentation/Widgets/blur_effect.dart';
import 'package:legwork/features/auth/presentation/Widgets/legwork_elevated_button.dart';

class ProfileCompletionScreen4 extends StatefulWidget {
  final void Function()? onPressed;
  const ProfileCompletionScreen4({super.key, required this.onPressed});

  @override
  State<ProfileCompletionScreen4> createState() =>
      _ProfileCompletionScreen4State();
}

class _ProfileCompletionScreen4State extends State<ProfileCompletionScreen4> {
  // FILE PICKER METHOD
  Future<void> _uploadResume() async {
    final result = await FilePicker.platform.pickFiles();
  }

  @override
  Widget build(BuildContext context) {
    // RETURNED WIDGET
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Center(
          child: Column(
            children: [
              // EXPANDED WIDGET FOR IMAGE
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/depictions/img_depc1.jpg'),
                      filterQuality: FilterQuality.high,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Center(
                    child: BlurEffect(
                      height: screenHeight(context) * 0.18,
                      width: screenWidth(context) * 0.8,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'How would you like to tell us more about yourself?',
                              textAlign: TextAlign.center,
                              style: context.textXl?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: context.colorScheme.surface,
                              ),
                            ),
                            Text(
                              'You can either upload your resume or manually fill it out.',
                              textAlign: TextAlign.center,
                              style: context.textSm?.copyWith(
                                fontWeight: FontWeight.w400,
                                color: context.colorScheme.surface,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // EXPANDED WIDGET FOR THE REST OF SCREEN CONTENT
              Expanded(
                flex: 2,
                child: Container(
                  width: screenWidth(context),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Upload resume
                      LegworkElevatedButton(
                        icon: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Image.asset(
                            'images/icons/upload_2.png',
                            height: 20,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                        maximumSize: Size(screenWidth(context) * 0.6,
                            screenHeight(context) * 0.1),
                        onPressed: _uploadResume,
                        buttonText: 'Upload resume',
                      ),
                      const SizedBox(height: 20),

                      // Fill out manually
                      LegworkElevatedButton(
                        maximumSize: Size(
                          screenWidth(context) * 0.6,
                          screenHeight(context) * 0.1,
                        ),
                        onPressed: widget.onPressed,
                        buttonText: 'Fill out manually',
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
