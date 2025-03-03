import 'package:flutter/material.dart';

class ViewJobApplicantsScreen extends StatelessWidget {
  final String jobId;
  final String clientId;

  ViewJobApplicantsScreen({
    super.key,
    required this.jobId,
    required this.clientId,
  });

  final TextEditingController proposalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Extract arguments passed to the next screen from the navigation
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    debugPrint("Job ID: ${args['jobId']}, Client ID: ${args['clientId']}");

    final String jobId = args['jobId'];
    final String clientId = args['clientId'];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Job Applicants",
          style: TextStyle(
            fontFamily: 'RobotoSlab',
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Center(
        child: Text("Applying for Job ID: $jobId\nClient ID: $clientId"),
      ),
    );
  }
}
