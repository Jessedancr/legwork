import 'package:flutter/material.dart';
import 'package:legwork/Features/auth/presentation/Widgets/auth_loading_indicator.dart';
import 'package:legwork/Features/auth/presentation/Widgets/legwork_snackbar_content.dart';

import 'package:legwork/Features/auth/presentation/widgets/auth_button.dart';
import 'package:legwork/Features/home/presentation/provider/job_provider.dart';
import 'package:legwork/Features/home/presentation/widgets/post_job_bottom_sheet.dart';
import 'package:provider/provider.dart';

class PostedJobsScreen extends StatefulWidget {
  const PostedJobsScreen({super.key});

  @override
  State<PostedJobsScreen> createState() => _PostedJobsScreenState();
}

class _PostedJobsScreenState extends State<PostedJobsScreen> {
  // CONTROLLERS
  final TextEditingController titleController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController danceStylesController = TextEditingController();
  final TextEditingController payController = TextEditingController();
  final TextEditingController jobDurationController = TextEditingController();
  final TextEditingController amtOfDancersController = TextEditingController();
  final TextEditingController jobDescrController = TextEditingController();
  final SearchController searchController = SearchController();

  @override
  Widget build(BuildContext context) {
    //SCREEN SIZE
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    // PROVIDER
    final jobProvider = Provider.of<JobProvider>(context);

    // METHOD TO POST JOB TO FIREBASE
    void postJob() async {
      Navigator.of(context).pop();
      showLoadingIndicator(context);
      // post job to firebase and display a snack bar with a success message
      try {
        final result = await jobProvider.postJob(
          jobTitle: titleController.text,
          jobLocation: locationController.text,
          pay: payController.text,
          amtOfDancers: amtOfDancersController.text,
          jobDuration: jobDurationController.text,
          jobDescr: jobDescrController.text,
          prefDanceStyles: danceStylesController.text
              .trim()
              .split(RegExp(r'(\s*,\s)+'))
              .where((style) => style
                  .isNotEmpty) // Remove empty entries => entries that meet the condition will stay
              .toList(),
        );

        result.fold(
            // Handle fail
            (fail) {
          debugPrint('Posting job to firebase failed: $fail');
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
                title: 'Omo!',
                subTitle: fail,
                contentColor: Theme.of(context).colorScheme.error,
                imageColor: Theme.of(context).colorScheme.onError,
              ),
            ),
          );
        },

            // Handle success
            (success) {
          debugPrint('Successfully posted job');
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
                title: 'Nice!',
                subTitle: 'Job posted successfully',
                contentColor: Theme.of(context).colorScheme.primary,
                imageColor: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          );
          // Clear controllers
          titleController.clear();
          locationController.clear();
          danceStylesController.clear();
          payController.clear();
          jobDurationController.clear();
          amtOfDancersController.clear();
          jobDescrController.clear();
          searchController.clear();
        });

        hideLoadingIndicator(context);
      } catch (e) {
        debugPrint('Error posting job: $e');
        hideLoadingIndicator(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to post job: $e')),
        );
      }
    }

    // METHOD TO POST NEW JOB
    void openJobModalSheet() {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return PostJobBottomSheet(
            onPressed: postJob,
            titleController: titleController,
            locationController: locationController,
            danceStylesController: danceStylesController,
            payController: payController,
            jobDurationController: jobDurationController,
            amtOfDancersController: amtOfDancersController,
            jobDescrController: jobDescrController,
            searchController: searchController,
          );
        },
      );
    }

    // RETURNED WIDGET
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('POSTED JOBS SCREEN'),
            const SizedBox(height: 25),

            // Button
            AuthButton(
              onPressed: openJobModalSheet,
              buttonText: 'Post new job',
            ),
          ],
        ),
      ),
    );
  }
}
