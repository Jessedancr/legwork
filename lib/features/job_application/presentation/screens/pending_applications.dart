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
    _loadData();
  }

  Future<void> _loadData() async {
    final provider =
        Provider.of<JobApplicationProvider>(context, listen: false);
    // Only fetch data if it's not already loaded
    if (provider.pendingAppsWithJobs.isEmpty && !provider.isLoading) {
      await provider.getPendingApplicationsWithJobs();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<JobApplicationProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Check if we have pending applications with jobs data
          if (provider.pendingAppsWithJobs.isNotEmpty) {
            return _buildPendingApplicationsWithJobs(provider);
          }

          return const Center(
            child: Text('No pending applications'),
          );
        },
      ),
    );
  }

  Widget _buildPendingApplicationsWithJobs(JobApplicationProvider provider) {
    return ListView.builder(
      itemCount: provider.pendingAppsWithJobs.length,
      itemBuilder: (context, index) {
        final application = provider.pendingAppsWithJobs.keys.elementAt(index);
        final job = provider.pendingAppsWithJobs.values.elementAt(index);

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          color: Theme.of(context).colorScheme.primaryContainer,
          child: ListTile(
            title: Text(job.jobTitle),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(job.jobDescr),
                const SizedBox(height: 4),
                Text('Applied on: ${application.appliedAt}'),
                Text('Status: ${application.applicationStatus}'),
              ],
            ),
            trailing: const Icon(Icons.chevron_right),
          ),
        );
      },
    );
  }
}
