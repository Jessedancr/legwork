import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:legwork/Features/job_application/data/models/job_application_model.dart';

class JobApplicationDetailScreen extends StatelessWidget {
  const JobApplicationDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final JobApplicationModel app =
        ModalRoute.of(context)!.settings.arguments as JobApplicationModel;

    final String dancerId = app.dancerId;
    final String proposal = app.proposal;
    final String status = app.applicationStatus;
    final String applicationId = app.applicationId;

    Future<void> onAcceptApplication() async {
      FirebaseFirestore.instance
          .collection('jobApplications')
          .doc(applicationId)
          .update({'applicationStatus': 'accepted'});
      Navigator.pop(context);
      debugPrint('You have accepted this application');
    }

    Future<void> onRejectApplication() async {
      FirebaseFirestore.instance
          .collection('jobApplications')
          .doc(applicationId)
          .update({'applicationStatus': 'rejected'});
      Navigator.pop(context);
      debugPrint('You have rejected this application');
    }

    return Scaffold(
      appBar: AppBar(title: Text('Application from $dancerId')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Proposal:", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(proposal),
            const SizedBox(height: 20),
            Text("Status: $status"),
            const SizedBox(height: 30),
            Row(
              children: [
                ElevatedButton(
                  onPressed: onAcceptApplication,
                  child: const Text("Accept"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: onRejectApplication,
                  child: const Text("Reject"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
