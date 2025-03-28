import 'package:flutter/material.dart';
import 'package:legwork/Features/job_application/presentation/provider/job_application_provider.dart';
import 'package:provider/provider.dart';

class PendingApplications extends StatefulWidget {
  const PendingApplications({super.key});

  @override
  State<PendingApplications> createState() => _PendingApplicationsState();
}

class _PendingApplicationsState extends State<PendingApplications> {
  @override
  void initState() {
    super.initState();

    Future.microtask(
      () => Provider.of<JobApplicationProvider>(context, listen: false)
          .getPendingApplications(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<JobApplicationProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          final applications = provider.pendingApplications;

          if (applications.isEmpty) {
            debugPrint('Pending Applications: $applications');
            return const Center(
              child: Text('No pending applications'),
            );
          }

          return ListView.builder(
            itemCount: applications.length,
            itemBuilder: (context, index) {
              final application = applications[index];

              return ListTile(
                title: Text('Job ID: ${application.jobId}'),
                subtitle: Text('Applied on: ${application.appliedAt}'),
                trailing: Text(application.applicationStatus),
                onTap: () {
                  // Navigate to job details or perform any action
                },
              );
            },
          );
        },
      ),
    );
  }
}
