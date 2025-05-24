import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:legwork/core/Constants/helpers.dart';
import 'package:legwork/features/auth/presentation/Widgets/blur_effect.dart';
import 'package:legwork/features/auth/presentation/Widgets/legwork_elevated_button.dart';

class ProfileCompletionScreen3 extends StatefulWidget {
  final void Function()? onPressed;
  const ProfileCompletionScreen3({
    super.key,
    required this.onPressed,
  });

  @override
  State<ProfileCompletionScreen3> createState() =>
      _ProfileCompletionScreen3State();
}

class _ProfileCompletionScreen3State extends State<ProfileCompletionScreen3> {
  // FILE PICKER METHOD
  Future<void> _uploadHiringHistory() async {
    final result = await FilePicker.platform.pickFiles();
  }

  // BUILD METHOD
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
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Tell us more about yourself',
                              style: context.text2Xl?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: context.colorScheme.surface,
                              ),
                            ),
                            Text(
                              'You can either upload your hiring history or manually fill it out.',
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
                    color: context.colorScheme.surface,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Upload hiring history
                      LegworkElevatedButton(
                        icon: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Image.asset(
                            'images/icons/upload_2.png',
                            height: 20,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                        maximumSize: Size(
                          screenWidth(context) * 0.55,
                          screenHeight(context) * 0.1,
                        ),
                        onPressed: _uploadHiringHistory,
                        buttonText: 'Upload hiring history',
                      ),
                      const SizedBox(height: 20),

                      // Fill out manually
                      LegworkElevatedButton(
                        maximumSize: Size(
                          screenWidth(context) * 0.55,
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
