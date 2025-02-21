import 'package:flutter/material.dart';
import 'package:legwork/Features/home/presentation/widgets/legwork_job_container.dart';

class AllJobs extends StatefulWidget {
  const AllJobs({super.key});

  @override
  State<AllJobs> createState() => _AllJobsState();
}

class _AllJobsState extends State<AllJobs> {
  // Navigate to job details screen
  void goToJobDetails() {}

  // Method to apply for job
  void applyForJob() {}

  // BUILD METHOD
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return LegworkJobContainer(
          onJobTap: applyForJob,
          onIconTap: goToJobDetails,
        );
      },
    );
  }
}
