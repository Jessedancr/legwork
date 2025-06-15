import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:legwork/core/Constants/helpers.dart';

import 'package:legwork/features/job_application/presentation/provider/job_application_provider.dart';
import 'package:legwork/features/job_application/presentation/widgets/show_applications_card.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class AcceptedApplications extends StatefulWidget {
  const AcceptedApplications({super.key});

  @override
  State<AcceptedApplications> createState() => _AcceptedApplicationsState();
}

class _AcceptedApplicationsState extends State<AcceptedApplications> {
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
    if (provider.acceptedAppsWithJobs.isEmpty && !provider.isLoading) {
      await provider.getAcceptedApplicationsWithJobs();
    }
  }

  // PULL TO REFRESH FUNC
  Future<void> _refresh() async {
    final provider =
        Provider.of<JobApplicationProvider>(context, listen: false);
    await provider.getAcceptedApplicationsWithJobs();
    // provider.notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<JobApplicationProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(
                child: Lottie.asset(
              'assets/lottie/loading.json',
              height: 100,
              fit: BoxFit.cover,
            ));
          }

          // Check if we have accepted applications with jobs data
          if (provider.acceptedAppsWithJobs.isNotEmpty) {
            return _buildAcceptedApplicationsWithJobs(provider);
          }

          return const Center(
            child: Text('No pending applications'),
          );
        },
      ),
    );
  }

  Widget _buildAcceptedApplicationsWithJobs(JobApplicationProvider provider) {
    return LiquidPullToRefresh(
      color: context.colorScheme.primary,
      backgroundColor: context.colorScheme.surface,
      animSpeedFactor: 3.0,
      showChildOpacityTransition: false,
      onRefresh: _refresh,
      child: ListView.builder(
        itemCount: provider.acceptedAppsWithJobs.length,
        itemBuilder: (context, index) {
          final application =
              provider.acceptedAppsWithJobs.keys.elementAt(index);
          final job = provider.acceptedAppsWithJobs.values.elementAt(index);

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
