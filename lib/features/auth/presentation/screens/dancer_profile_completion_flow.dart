import 'package:flutter/material.dart';
import 'package:legwork/core/Constants/helpers.dart';
import 'package:legwork/core/widgets/legwork_snackbar.dart';
import 'package:legwork/features/auth/domain/Entities/user_entities.dart';
import 'package:legwork/features/auth/presentation/Provider/my_auth_provider.dart';
import 'package:legwork/features/auth/presentation/Provider/update_profile_provider.dart';
import 'package:legwork/features/auth/presentation/Screens/DancerProfileCompletion/profile_completion_screen1.dart';
import 'package:legwork/features/auth/presentation/Screens/DancerProfileCompletion/profile_completion_screen5.dart';
import 'package:legwork/features/auth/presentation/Screens/DancerProfileCompletion/profile_completion_screen3.dart';
import 'package:legwork/features/auth/presentation/Widgets/auth_loading_indicator.dart';
import 'package:legwork/features/auth/presentation/Widgets/legwork_elevated_button.dart';
import 'package:legwork/features/auth/presentation/Widgets/legwork_snackbar_content.dart';
import 'package:legwork/features/onboarding/presentation/widgets/page_indicator.dart';
import 'package:provider/provider.dart';

import 'DancerProfileCompletion/profile_completion_screen2.dart';
import 'DancerProfileCompletion/profile_completion_screen4.dart';

class DancerProfileCompletionFlow extends StatefulWidget {
  final DancerEntity dancerDetails;
  const DancerProfileCompletionFlow({
    super.key,
    required this.dancerDetails,
  });

  @override
  State<DancerProfileCompletionFlow> createState() =>
      _DancerProfileCompletionFlowState();
}

class _DancerProfileCompletionFlowState
    extends State<DancerProfileCompletionFlow> {
  late MyAuthProvider authProvider;

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
  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<MyAuthProvider>(context, listen: false);
  }

  // BUILD METHOD
  @override
  Widget build(BuildContext context) {
    // PROVIDER
    final updateProfileProvider = Provider.of<UpdateProfileProvider>(context);

    // SAVE AND UPDATE PROFILE
    void saveAndUpdateProfile() async {
      showLoadingIndicator(context);
      try {
        Map<String, dynamic> data = {
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
        };
        final result =
            await updateProfileProvider.updateProfileExecute(data: data);

        result.fold(
          // handle failure
          (fail) {
            hideLoadingIndicator(context);
            debugPrint(fail.toString());
            LegworkSnackbar(
              title: 'Omo!',
              subTitle: fail,
              contentColor: context.colorScheme.error,
              imageColor: context.colorScheme.onError,
            );
          },
          // handle success
          (success) {
            debugPrint('Profile completion successful');
            hideLoadingIndicator(context);
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/dancerApp',
              (route) => false,
            );
            LegworkSnackbar(
              title: 'Sharp guy!',
              subTitle: 'Welcome to LEGWORK',
              imageColor: context.colorScheme.onPrimary,
              contentColor: context.colorScheme.primary,
            ).show(context);
          },
        );
      } catch (e) {
        debugPrint('error updating profile');
        hideLoadingIndicator(context);
        debugPrint('Error updating profile: $e');
        LegworkSnackbar(
          title: 'Omo!',
          subTitle: 'An unknown error occured',
          imageColor: context.colorScheme.onError,
          contentColor: context.colorScheme.error,
        ).show(context);
      }
    }

    // NAVIGATE TO NEXT PAGE
    void nextPage() {
      pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }

    // * Profile ocmpletition screens
    List<Widget> profileCompletionScreens = [
      ProfileCompletionScreen1(
        email: widget.dancerDetails.email,
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
    ];
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
                  isLastPage = (value == profileCompletionScreens.length - 1);
                });
                if (isLastPage) {
                  debugPrint('Dancer profile completiton Last page');
                }
              },
              children: profileCompletionScreens,
            ),

            // PAGE INDICATOR
            Positioned(
              bottom: screenHeight(context) * 0.04,
              left: screenWidth(context) * 0.38,
              child: PageIndicator(
                pageController: pageController,
                count: profileCompletionScreens.length,
                dotColor: context.colorScheme.primaryContainer,
              ),
            ),

            // PREVIOUS ICON BUTTON
            Positioned(
              bottom: screenHeight(context) * 0.01,
              left: screenWidth(context) * 0.05,
              child: IconButton(
                onPressed: () {
                  // back to previous screen
                  pageController.previousPage(
                    duration: const Duration(microseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
                icon: const Icon(Icons.arrow_back_ios),
              ),
            ),

            // SAVE AND CONTINUE BUTTON
            Positioned(
              bottom: screenHeight(context) * 0.01,
              right: screenWidth(context) * 0.05,
              child: LegworkElevatedButton(
                onPressed: isLastPage ? saveAndUpdateProfile : nextPage,
                buttonText: isLastPage ? 'Done' : 'Next',
              ),
            )
          ],
        ),
      ),
    );
  }
}
