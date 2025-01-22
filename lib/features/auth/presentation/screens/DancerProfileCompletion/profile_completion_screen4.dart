import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:legwork/Features/auth/presentation/Widgets/auth_button.dart';
import 'package:legwork/Features/auth/presentation/Widgets/auth_text_form_field.dart';
import 'package:legwork/Features/auth/presentation/Widgets/blur_effect.dart';
import 'package:legwork/Features/auth/presentation/Widgets/legwork_elevated_button.dart';
import 'package:legwork/Features/auth/presentation/widgets/auth_textfield.dart';
import 'package:legwork/Features/home/presentation/widgets/work_experience_bottom_sheet.dart';

class ProfileCompletionScreen4 extends StatefulWidget {
  const ProfileCompletionScreen4({super.key});

  @override
  State<ProfileCompletionScreen4> createState() =>
      _ProfileCompletionScreen4State();
}

class _ProfileCompletionScreen4State extends State<ProfileCompletionScreen4> {
  // CONTROLLERS
  final TextEditingController professonalTitleController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    // SCREEN SIZE
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // METHOD THAT SHOWS BOTTOM SHEET TO ADD WORK EXPERIENCE
    void addWorkExperience() {
      showModalBottomSheet(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        context: context,
        builder: (context) {
          return WorkExperienceBottomSheet();
        },
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Center(
          child: Column(
            children: [
              // EXPANDED ICON FOR IMAGE
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
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          children: [
                            Text(
                              'Got it! Now add a title to your resume',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.robotoSlab(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 10.0,
                                bottom: 10.0,
                              ),
                              child: Text(
                                'Describe your expertise in your own words',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.robotoSlab(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Text(
                              'This will help you stand out to employers',
                              style: GoogleFonts.robotoSlab(
                                fontWeight: FontWeight.w300,
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // EXPANDED ICON FOR REST OF SCREEN CONTENT
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
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Column(
                        children: [
                          // Text field
                          AuthTextFormField(
                            hintText: 'Professional title',
                            helperText:
                                'Ex: Professional dancer and choreographer',
                            obscureText: false,
                            controller: professonalTitleController,
                            icon: Image.asset('images/icons/title.png'),
                          ),
                          const SizedBox(height: 25),

                          // Work experience button
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: AuthButton(
                              onPressed: addWorkExperience,
                              buttonText: 'Add work experience',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
