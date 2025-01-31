//import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:legwork/Features/auth/presentation/Provider/update_profile_provider.dart';
import 'package:legwork/Features/auth/presentation/Screens/DancerProfileCompletion/profile_completion_screen1.dart';
import 'package:legwork/Features/auth/presentation/Screens/DancerProfileCompletion/profile_completion_screen4.dart';
import 'package:legwork/Features/auth/presentation/Widgets/auth_loading_indicator.dart';
import 'package:legwork/Features/auth/presentation/Widgets/legwork_elevated_button.dart';
import 'package:provider/provider.dart';

import '../../../onboarding/presentation/widgets/page_indicator.dart';
import 'DancerProfileCompletion/profile_completion_screen2.dart';
import 'DancerProfileCompletion/profile_completion_screen3.dart';

class DancerProfileCompletionFlow extends StatefulWidget {
  const DancerProfileCompletionFlow({
    super.key,
  });

  @override
  State<DancerProfileCompletionFlow> createState() =>
      _DancerProfileCompletionFlowState();
}

class _DancerProfileCompletionFlowState
    extends State<DancerProfileCompletionFlow> {
  final auth = FirebaseAuth.instance;

  // CONTROLLERS
  final PageController pageController = PageController();
  final SearchController searchController = SearchController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController professonalTitleController =
      TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController employerController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController jobDescrController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController jobPaycontroller = TextEditingController();

  // This keeps track on if we are on the lasr page
  bool isLastPage = false;

  // BUILD METHOD
  @override
  Widget build(BuildContext context) {
    //SCREEN SIZE
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // PROVIDER
    final updateProfileProvider = Provider.of<UpdateProfileProvider>(context);

    // SAVE AND UPDATE PROFILE
    void saveAndUpdateProfile() async {
      showLoadingIndicator(context);
      try {
        await updateProfileProvider.updateProfileExecute(
          data: {
            'bio': bioController.text,
            'jobPrefs': {
              'prefPay': jobPaycontroller.text,
              'prefLocation': selectedLocations,
              'prefJobTypes': selectedSkills,
            },
            'resume': {
              'professionalTitle': professonalTitleController.text,
              'workExperiences': workExperienceList
                  .map((experience) => {
                        'jobTitle': experience[0],
                        'employer': experience[1],
                        'location': experience[2],
                        'date': experience[3],
                        'jobDescription': experience[4],
                      })
                  .toList(),
            }
          },
        );

        hideLoadingIndicator(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile Updated'),
          ),
        );

        Navigator.of(context).pushNamedAndRemoveUntil(
          '/dancerApp',
          (route) => false,
        );
      } catch (e) {
        debugPrint('error updating profile');
        hideLoadingIndicator(context);
        debugPrint('Error updating profile: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e')),
        );
      }
    }

    // NAVIGATE TO NEXT PAGE
    void nextPage() {
      pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }

    // RETURNED SCAFFOLD
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            // Page view
            PageView(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (value) {
                setState(() {
                  isLastPage = (value == 3);
                  debugPrint('DANCER PROFILE COMPLETION LAST PAGE');
                });
              },
              children: [
                ProfileCompletionScreen1(
                  email: auth.currentUser!.email,
                  bioController: bioController,
                  jobPaycontroller: jobPaycontroller,
                ),
                const ProfileCompletionScreen2(),
                ProfileCompletionScreen3(
                  onPressed: () => pageController.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  ),
                ),
                ProfileCompletionScreen4(
                  dateController: dateController,
                  employerController: employerController,
                  jobDescrController: jobDescrController,
                  locationController: locationController,
                  professonalTitleController: professonalTitleController,
                  titleController: titleController,
                ),
              ],
            ),

            // PAGE INDICATOR
            Positioned(
              bottom: screenHeight * 0.04,
              left: screenWidth * 0.38,
              child: PageIndicator(
                pageController: pageController,
                count: 4,
                dotColor: Theme.of(context).colorScheme.primaryContainer,
              ),
            ),

            // PREVIOUS ICON BUTTON
            Positioned(
              bottom: screenHeight * 0.01,
              left: screenWidth * 0.05,
              child: IconButton(
                onPressed: () {
                  // back to previous screen
                  pageController.previousPage(
                    duration: const Duration(microseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
                icon: const Icon(Icons.arrow_back),
              ),
            ),

            // SAVE AND CONTINUE BUTTON
            Positioned(
              bottom: screenHeight * 0.01,
              right: screenWidth * 0.05,
              child: isLastPage
                  ? LegworkElevatedButton(
                      buttonText: 'Done',
                      onPressed: saveAndUpdateProfile,
                    )
                  : LegworkElevatedButton(
                      onPressed: nextPage,
                      buttonText: 'Next',
                    ),
            )
          ],
        ),
      ),
    );
  }
}
