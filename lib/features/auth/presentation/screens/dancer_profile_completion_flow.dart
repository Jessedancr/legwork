//import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:legwork/features/auth/presentation/Provider/update_profile_provider.dart';
import 'package:legwork/features/auth/presentation/Screens/DancerProfileCompletion/profile_completion_screen1.dart';
import 'package:legwork/features/auth/presentation/Screens/DancerProfileCompletion/profile_completion_screen5.dart';
import 'package:legwork/features/auth/presentation/Screens/DancerProfileCompletion/profile_completion_screen3.dart';
import 'package:legwork/features/auth/presentation/Widgets/auth_loading_indicator.dart';
import 'package:legwork/features/auth/presentation/Widgets/legwork_elevated_button.dart';
import 'package:legwork/features/auth/presentation/Widgets/legwork_snackbar_content.dart';
import 'package:provider/provider.dart';

import '../../../onboarding/presentation/widgets/page_indicator.dart';
import 'DancerProfileCompletion/profile_completion_screen2.dart';
import 'DancerProfileCompletion/profile_completion_screen4.dart';

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
  // final _authRemoteDataSource = AuthRemoteDataSourceImpl();

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
  final TextEditingController danceStylesController = TextEditingController();

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
        final result = await updateProfileProvider.updateProfileExecute(
          data: {
            'bio': bioController.text,
            'jobPrefs': {
              'danceStyles': danceStylesController.text
                  .trim()
                  .split(RegExp(r'(\s*,\s)+'))
                  .where((style) => style.isNotEmpty)
                  .toList(),
              'jobTypes': selectedSkills,
              'jobLocations': selectedLocations,
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

        result.fold(
            // handle failure
            (fail) {
          hideLoadingIndicator(context);
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
                title: 'Oh snap!',
                subTitle: fail,
                contentColor: Theme.of(context).colorScheme.error,
                imageColor: Theme.of(context).colorScheme.onError,
              ),
            ),
          );
        },
            // handle success
            (success) {
          debugPrint('Profile completion successful');
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
                title: 'Congrats!',
                subTitle: 'Welcome to LEGWORK!',
                contentColor: Theme.of(context).colorScheme.primary,
                imageColor: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          );

          Navigator.of(context).pushNamedAndRemoveUntil(
            '/dancerApp',
            (route) => false,
          );
        });
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
                  isLastPage = (value == 4);
                  debugPrint('DANCER PROFILE COMPLETION LAST PAGE');
                });
              },
              children: [
                ProfileCompletionScreen1(
                  email: auth.currentUser!.email,
                  bioController: bioController,
                  danceStylesController: danceStylesController,
                ),
                const ProfileCompletionScreen2(),
                const ProfileCompletionScreen3(),
                ProfileCompletionScreen4(
                  onPressed: () => pageController.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  ),
                ),
                ProfileCompletionScreen5(
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
                count: 5,
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
