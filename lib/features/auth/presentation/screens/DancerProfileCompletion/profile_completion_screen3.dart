import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:legwork/Features/auth/presentation/Widgets/blur_effect.dart';
import 'package:legwork/Features/auth/presentation/Widgets/legwork_elevated_button.dart';

class ProfileCompletionScreen3 extends StatefulWidget {
  final void Function()? onPressed;
  const ProfileCompletionScreen3({super.key, required this.onPressed});

  @override
  State<ProfileCompletionScreen3> createState() =>
      _ProfileCompletionScreen3State();
}

class _ProfileCompletionScreen3State extends State<ProfileCompletionScreen3> {
  // FILE PICKER METHOD
  Future<void> _uploadResume() async {
    final result = await FilePicker.platform.pickFiles();
  }

  @override
  Widget build(BuildContext context) {
    //SCREEN SIZE
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // RETURNED WIDGET
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
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
                  ),
                  child: Center(
                    child: BlurEffect(
                      height: screenHeight * 0.18,
                      width: screenWidth * 0.8,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'How would you like to tell us more about yourself?',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.robotoSlab(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'You can either upload your resume or manually fill it out.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.robotoSlab(
                                color: Colors.white,
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
                  width: screenWidth,
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
                        maximumSize: WidgetStatePropertyAll(
                          Size(screenWidth * 0.6, screenHeight * 0.1),
                        ),
                        onPressed: _uploadResume,
                        buttonText: 'Upload resume',
                      ),
                      const SizedBox(height: 20),

                      // Fill out manually
                      LegworkElevatedButton(
                        maximumSize: WidgetStatePropertyAll(
                          Size(screenWidth * 0.6, screenHeight * 0.1),
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
