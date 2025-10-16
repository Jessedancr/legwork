import 'package:flutter/material.dart';
import 'package:legwork/core/Constants/helpers.dart';
import 'package:legwork/features/home/domain/entities/job_entity.dart';
import 'package:legwork/features/home/presentation/provider/job_provider.dart';
import 'package:legwork/features/home/presentation/widgets/legwork_job_container.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';

class ClosedJobs extends StatefulWidget {
  const ClosedJobs({super.key});

  @override
  State<ClosedJobs> createState() => _ClosedJobsState();
}

class _ClosedJobsState extends State<ClosedJobs>
    with AutomaticKeepAliveClientMixin {
  // PROVIDERS
  late final jobProvider = Provider.of<JobProvider>(context, listen: false);
  late final listeningProvider = Provider.of<JobProvider>(context);

  bool isLoading = true;

  // PULL TO REFRESH FUNCTION
  Future<void> _refresh() async {
    setState(() {
      isLoading = true;
    });
    await jobProvider.fetchJobs();
    setState(() {
      isLoading = false;
    });
  }

  void viewJobApplicants({
    required String jobId,
    required String clientId,
    required bool status,
  }) {
    Navigator.pushNamed(
      context,
      '/viewJobApplicantsScreen',
      arguments: {
        'jobId': jobId,
        'clientId': clientId,
        'status': status,
      },
    );
  }

  //* BUILD METHOD
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final jobs = listeningProvider.allJobs;
    List<JobEntity> closedJobs = jobs["closedJobs"] ?? [];

    return LiquidPullToRefresh(
      onRefresh: _refresh,
      color: context.colorScheme.primary,
      backgroundColor: context.colorScheme.surface,
      animSpeedFactor: 3.0,
      showChildOpacityTransition: false,
      child: ListView.builder(
        itemCount: closedJobs.length,
        itemBuilder: (context, index) {
          // Get each individual job
          final job = closedJobs[index];

          // Display it in UI
          return LegworkJobContainer(
            onJobTap: () => viewJobApplicants(
              clientId: job.clientId,
              jobId: job.jobId,
              status: job.status,
            ),
            jobTitle: job.jobTitle,
            pay: job.pay,
            jobDescr: job.jobDescr,
            amtOfDancers: job.amtOfDancers,
            jobDuration: job.jobDuration,
            jobLocation: job.jobLocation,
            jobType: job.jobType,
            createdAt: job.createdAt,
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
