import 'dart:io';

import 'package:flutter/material.dart';
import 'package:legwork/core/Constants/helpers.dart';
import 'package:legwork/core/widgets/legwork_snackbar.dart';
import 'package:legwork/features/auth/domain/Entities/user_entities.dart';
import 'package:legwork/features/auth/presentation/Provider/my_auth_provider.dart';
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
  late MyAuthProvider authProvider;

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
  File? selectedImage;

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
          'danceStylePrefs': danceStylePrefsController.text
              .trim()
              .split(RegExp(r'(\s*,\s)+'))
              .where((style) => style.isNotEmpty)
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

        // If an image was selected, run both operations concurrently.
        if (selectedImage != null) {
          final results = await Future.wait([
            updateProfileProvider.updateProfileExecute(data: data),
            updateProfileProvider.uploadProfileImage(imageFile: selectedImage!),
          ]);

          final updateProfile = results[0];
          final uploadProfileImage = results[1];

          uploadProfileImage.fold(
            (fail) {
              hideLoadingIndicator(context);
              debugPrint(fail);
              LegworkSnackbar(
                title: 'Omo!',
                subTitle: fail,
                contentColor: context.colorScheme.error,
                imageColor: context.colorScheme.onError,
              ).show(context);
            },
            (success) {
              hideLoadingIndicator(context);
              debugPrint('Image upload successful: $success');
            },
          );

          updateProfile.fold(
            // handle failure
            (fail) {
              hideLoadingIndicator(context);
              debugPrint(fail.toString());
              LegworkSnackbar(
                title: 'Omo!',
                subTitle: fail,
                contentColor: context.colorScheme.error,
                imageColor: context.colorScheme.onError,
              ).show(context);
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
        } else {
          // No image selected: only update the profile
          final updateProfile =
              await updateProfileProvider.updateProfileExecute(data: data);

          updateProfile.fold(
            // handle failure
            (fail) {
              hideLoadingIndicator(context);
              debugPrint(fail.toString());
              LegworkSnackbar(
                title: 'Omo!',
                subTitle: fail,
                contentColor: context.colorScheme.error,
                imageColor: context.colorScheme.onError,
              ).show(context);
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
        }
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

    //  * Profile completition screens
    List<Widget> profileCompletitionScreen = [
      ProfileCompletionScreen1(
        username: widget.clientDetails.username,
        bioController: bioController,
        danceStylePrefsController: danceStylePrefsController,
        selectedImage: selectedImage,
        onImageSelected: (File image) {
          setState(() {
            selectedImage = image;
          });
        },
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
