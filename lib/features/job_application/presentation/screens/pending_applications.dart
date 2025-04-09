import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:legwork/features/job_application/presentation/provider/job_application_provider.dart';
import 'package:legwork/features/job_application/presentation/widgets/show_applications_card.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';

class PendingApplications extends StatefulWidget {
  const PendingApplications({super.key});

  @override
  State<PendingApplications> createState() => _PendingApplicationsState();
}

class _PendingApplicationsState extends State<PendingApplications> {
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
    if (provider.pendingAppsWithJobs.isEmpty && !provider.isLoading) {
      await provider.getPendingApplicationsWithJobs();
    }
  }

  // PULL TO REFRESH FUNC
  Future<void> _refresh() async {
    final provider =
        Provider.of<JobApplicationProvider>(context, listen: false);
    await provider.getPendingApplicationsWithJobs();
    // provider.notifyListeners();
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
    return LiquidPullToRefresh(
      onRefresh: _refresh,
      color: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.surface,
      animSpeedFactor: 3.0,
      showChildOpacityTransition: false,
      child: ListView.builder(
        itemCount: provider.pendingAppsWithJobs.length,
        itemBuilder: (context, index) {
          final application =
              provider.pendingAppsWithJobs.keys.elementAt(index);
          final job = provider.pendingAppsWithJobs.values.elementAt(index);

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
