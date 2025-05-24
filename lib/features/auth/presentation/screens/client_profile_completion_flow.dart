import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:legwork/core/Constants/helpers.dart';
import 'package:legwork/core/widgets/legwork_snackbar.dart';
import 'package:legwork/features/auth/domain/Entities/user_entities.dart';
import 'package:legwork/features/auth/presentation/Provider/update_profile_provider.dart';
import 'package:legwork/features/auth/presentation/Widgets/auth_loading_indicator.dart';
import 'package:legwork/features/auth/presentation/Widgets/legwork_elevated_button.dart';
import 'package:legwork/features/onboarding/presentation/widgets/page_indicator.dart';
import 'package:provider/provider.dart';

import 'ClientProfileCompletion/profile_completion_screen1.dart';
import 'ClientProfileCompletion/profile_completion_screen2.dart';
import 'ClientProfileCompletion/profile_completion_screen3.dart';
import 'ClientProfileCompletion/profile_completion_screen4.dart';

class ClientProfileCompletionFlow extends StatefulWidget {
  final ClientEntity clientDetails;
  const ClientProfileCompletionFlow({
    required this.clientDetails,
    super.key,
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
    // PROVIDER
    final updateProfileProvider = Provider.of<UpdateProfileProvider>(context);

    // SAVE AND UPDATE PROFILE
    void saveAndUpdateProfile() async {
      showLoadingIndicator(context);
      try {
        Map<String, dynamic> data = {
          'bio': bioController.text,
          'danceStylePrefs': danceStylePrefsController.text
              .trim()
              .replaceAll(RegExp(r'[,;\s|/]+'), ',')
              .split(',')
              .toList(),
          'jobOfferings': selectedJobTypes,
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
              '/clientApp',
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
          subTitle: 'Failed to update profile: $e',
          imageColor: context.colorScheme.onError,
          contentColor: context.colorScheme.error,
        ).show(context);
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

    //  * Profile completition screens
    List<Widget> profileCompletitionScreen = [
      ProfileCompletionScreen1(
        email: widget.clientDetails.email,
        bioController: bioController,
        danceStylePrefsController: danceStylePrefsController,
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
        jobDescrController: jobDescrController,
        jobTitleController: jobTitleController,
        locationController: locationController,
        numOfDancersController: numOfDancersController,
        paymentController: paymentController,
        professonalTitleController: professionalTitleController,
      ),
    ];

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
                  isLastPage = (value == profileCompletitionScreen.length - 1);
                });
                if (isLastPage) {
                  debugPrint('Cliemt profile completiton Last page');
                }
              },
              children: profileCompletitionScreen,
            ),

            // PAGE INDICATOR
            Positioned(
              bottom: screenHeight(context) * 0.04,
              left: screenWidth(context) * 0.38,
              child: PageIndicator(
                pageController: pageController,
                count: profileCompletitionScreen.length,
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
