import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:legwork/Features/auth/presentation/Provider/update_profile_provider.dart';
import 'package:legwork/Features/auth/presentation/Widgets/auth_loading_indicator.dart';
import 'package:legwork/Features/auth/presentation/Widgets/legwork_elevated_button.dart';
import 'package:legwork/Features/onboarding/presentation/widgets/page_indicator.dart';
import 'package:provider/provider.dart';

import 'ClientProfileCompletion/profile_completion_screen1.dart';
import 'ClientProfileCompletion/profile_completion_screen2.dart';
import 'ClientProfileCompletion/profile_completion_screen3.dart';
import 'ClientProfileCompletion/profile_completion_screen4.dart';

class ClientProfileCompletionFlow extends StatefulWidget {
  final String email;
  const ClientProfileCompletionFlow({
    super.key,
    required this.email,
  });

  @override
  State<ClientProfileCompletionFlow> createState() =>
      _ClientProfileCompletionFlowState();
}

class _ClientProfileCompletionFlowState
    extends State<ClientProfileCompletionFlow> {
  final auth = FirebaseAuth.instance;

  // CONTROLLERS
  final PageController pageController = PageController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController danceStylePrefsController =
      TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController jobDescrController = TextEditingController();
  final TextEditingController jobTitleController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController numOfDancersController = TextEditingController();
  final TextEditingController professionalTitleController =
      TextEditingController();
  final TextEditingController paymentController = TextEditingController();

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
            'danceStylePrefs': danceStylePrefsController.text
                .trim()
                .replaceAll(RegExp(r'[,;\s|/]+'), ',')
                .split(',')
                .toList(),
            'jobOfferings': selectedSkills,
            'hiringHistory': {
              'professionalTitle': professionalTitleController.text,
              'hiringHistories': hiringHistoryList
                  .map((history) => {
                        'jobTitle': history[0],
                        'location': history[1],
                        'date': history[2],
                        'numOfDancers': history[3],
                        'paymentOffered': history[4],
                        'jobDescription': history[5],
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
          '/clientHomeScreen',
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

    // TODO: Implement conditional navigation if pref dance styles is empty
    // NAVIGATE TO NEXT PAGE
    void nextPage() {
      // if (formKey.currentState!.validate()) {
      //   pageController.nextPage(
      //     duration: const Duration(milliseconds: 500),
      //     curve: Curves.easeInOut,
      //   );
      // }
      pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }

    // RETURNED WIDGET
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
                  debugPrint('CLIENT PROFILE COMPLETION LAST PAGE');
                });
              },
              children: [
                ProfileCompletionScreen1(
                  email: auth.currentUser!.email,
                  bioController: bioController,
                  danceStylePrefsController: danceStylePrefsController,
                ),
                ProfileCompletionScreen2(),
                ProfileCompletionScreen3(
                  onPressed: () => pageController.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  ),
                ),
                ProfileCompletionScreen4(
                  dateController: dateController,
                  jobDescrController: jobDescrController,
                  jobTitleController: jobTitleController,
                  locationController: locationController,
                  numOfDancersController: numOfDancersController,
                  paymentController: paymentController,
                  professonalTitleController: professionalTitleController,
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
