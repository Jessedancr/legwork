import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:legwork/features/job_application/presentation/provider/job_application_provider.dart';
import 'package:legwork/features/job_application/presentation/widgets/show_applications_card.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';

class RejectedApplications extends StatefulWidget {
  const RejectedApplications({super.key});

  @override
  State<RejectedApplications> createState() => _RejectedApplicationsState();
}

class _RejectedApplicationsState extends State<RejectedApplications> {
  // INIT STATE
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final provider =
        Provider.of<JobApplicationProvider>(context, listen: false);
    // Only fetch data if it's not already loaded
    if (provider.rejectedAppsWithJobs.isEmpty && !provider.isLoading) {
      await provider.getRejectedApplicationsWithJobs();
    }
  }

  // PULL TO REFRESH FUNC
  Future<void> _refresh() async {
    final provider =
        Provider.of<JobApplicationProvider>(context, listen: false);
    await provider.getRejectedApplicationsWithJobs();
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
          if (provider.rejectedAppsWithJobs.isNotEmpty) {
            return _buildRejectedApplicationsWithJobs(provider);
          }

          return const Center(
            child: Text('No Rejected applications'),
          );
        },
      ),
    );
  }

  Widget _buildRejectedApplicationsWithJobs(JobApplicationProvider provider) {
    return LiquidPullToRefresh(
      onRefresh: _refresh,
      color: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.surface,
      animSpeedFactor: 3.0,
      showChildOpacityTransition: false,
      child: ListView.builder(
        itemCount: provider.rejectedAppsWithJobs.length,
        itemBuilder: (context, index) {
          final application =
              provider.rejectedAppsWithJobs.keys.elementAt(index);
          final job = provider.rejectedAppsWithJobs.values.elementAt(index);

          String formattedCreatedAt =
              DateFormat('dd-MM-yyyy | hh:mma').format(application.appliedAt);

          return ShowApplicationsCard(
            job: job,
            formattedCreatedAt: formattedCreatedAt,
            application: application,
          );
        },
      ),
    );
  }
}
