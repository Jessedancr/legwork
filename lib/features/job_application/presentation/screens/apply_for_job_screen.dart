import 'package:flutter/material.dart';

class ApplyForJobScreen extends StatelessWidget {
  final String jobId;
  final String clientId;

  ApplyForJobScreen({
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
    // final provider =
    //     Provider.of<JobApplicationProvider>(context, listen: false);

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
      body: Center(
        child: Text("Applying for Job ID: $jobId\nClient ID: $clientId"),
      ),

      // Column(
      //   children: [
      //     TextField(
      //       controller: proposalController,
      //       decoration: const InputDecoration(
      //         hintText: "Enter your proposal",
      //       ),
      //     ),
      //     ElevatedButton(
      //       onPressed: () {
      //         final application = JobApplicationEntity(
      //           jobId: jobId,
      //           dancerId: "currentDancerId",
      //           clientId: clientId,
      //           applicationStatus: "pending",
      //           proposal: proposalController.text,
      //           appliedAt: DateTime.now(),
      //         );
      //         provider.applyForJob(application);
      //       },
      //       child: const Text("Apply"),
      //     ),
      //   ],
      // ),
    );
  }
}
