import 'package:flutter/material.dart';
import 'package:legwork/Features/auth/presentation/Widgets/auth_loading_indicator.dart';
import 'package:legwork/Features/auth/presentation/Widgets/legwork_snackbar_content.dart';
import 'package:legwork/Features/job_application/domain/entities/job_application_entity.dart';
import 'package:legwork/Features/job_application/presentation/provider/job_application_provider.dart';
import 'package:provider/provider.dart';

class ApplyForJobScreen extends StatefulWidget {
  final String jobId;
  final String clientId;

  const ApplyForJobScreen({
    super.key,
    required this.jobId,
    required this.clientId,
  });

  @override
  State<ApplyForJobScreen> createState() => _ApplyForJobScreenState();
}

class _ApplyForJobScreenState extends State<ApplyForJobScreen> {
  final TextEditingController proposalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //SCREEN SIZE
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    // Extract arguments passed to the next screen from the navigation
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    debugPrint("Job ID: ${args['jobId']}, Client ID: ${args['clientId']}");

    final String jobId = args['jobId'];
    final String clientId = args['clientId'];
    final jobApplicationProvider =
        Provider.of<JobApplicationProvider>(context, listen: false);

    // Method to apply for job
    Future<void> applyForJob() async {
      showLoadingIndicator(context);
      // Post application to firebase and display snack bar with success message
      try {
        final application = JobApplicationEntity(
          jobId: jobId,
          dancerId: '',
          clientId: clientId,
          applicationStatus: "pending",
          proposal: proposalController.text,
          appliedAt: DateTime.now(),
        );
        final result = await jobApplicationProvider.applyForJob(application);

        result.fold(
          // Handle fail
          (fail) {
            debugPrint('Error posting application to firebase: $fail');
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
                  title: 'Oops!',
                  subTitle: 'Error applying for job. Please try again.',
                  contentColor: Theme.of(context).colorScheme.error,
                  imageColor: Theme.of(context).colorScheme.onError,
                ),
              ),
            );
          },

          // handle success
          (success) {
            debugPrint('Job application submitted successfully');
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
                  title: 'Nice!',
                  subTitle: 'Job application submitted successfully',
                  contentColor: Theme.of(context).colorScheme.primary,
                  imageColor: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            );
          },
        );
      } catch (e) {
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
              title: 'Oops!',
              subTitle: 'Unknown error occured. Please try again.',
              contentColor: Theme.of(context).colorScheme.error,
              imageColor: Theme.of(context).colorScheme.onError,
            ),
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Apply for Job",
          style: TextStyle(
            fontFamily: 'RobotoSlab',
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: proposalController,
              decoration: const InputDecoration(
                hintText: "Enter your proposal",
              ),
            ),
            ElevatedButton(
              onPressed: applyForJob,
              child: const Text("Apply"),
            ),
          ],
        ),
      ),
    );
  }
}
