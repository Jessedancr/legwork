import 'package:flutter/material.dart';
import 'package:legwork/Features/home/domain/entities/job_entity.dart';
import 'package:legwork/Features/home/presentation/provider/job_provider.dart';
import 'package:legwork/Features/home/presentation/widgets/legwork_job_container.dart';
import 'package:provider/provider.dart';

class AllJobs extends StatefulWidget {
  const AllJobs({super.key});

  @override
  State<AllJobs> createState() => _AllJobsState();
}

class _AllJobsState extends State<AllJobs> {
  // PROVIDERS
  late final jobProvider = Provider.of<JobProvider>(context, listen: false);
  late final listeningProvider = Provider.of<JobProvider>(context);

  // PULL TO REFRESH FUNCTION
  Future<void> _refresh() {
    jobProvider.fetchJobs();
    return Future.delayed(const Duration(seconds: 3));
  }

  // ON STARTUP
  @override
  void initState() {
    super.initState();

    loadAllJobs();
  }

  // Load all posts
  Future<void> loadAllJobs() async {
    await jobProvider.fetchJobs();
  }

  // Navigate to job details screen
  void goToJobDetails() {}

  // Method to apply for job
  void applyForJob() {}

  //* BUILD METHOD
  @override
  Widget build(BuildContext context) {
    final jobs = listeningProvider.allJobs;

    // Handle case where no jobs existS
    if (jobs.isEmpty) {
      debugPrint("Jobs: $jobs");
      return const Center(
        child: Text('Nothing here...YET'),
      );
    }

    // Extract job lists
    List<JobEntity> allJobs = jobs["allJobs"] ?? [];
    debugPrint('All Jobs: $allJobs');
    return buildJobList(allJobs);
  }

  // BUILD JOBS LIST
  Widget buildJobList(List<JobEntity> jobs) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.builder(
        itemCount: jobs.length,
        itemBuilder: (context, index) {
          // Get each individual post
          final job = jobs[index];

          // Display it in UI
          return LegworkJobContainer(
            onJobTap: applyForJob,
            onIconTap: goToJobDetails,
            jobTitle: job.jobTitle,
            pay: job.pay,
            jobDescr: job.jobDescr,
            amtOfDancers: job.amtOfDancers,
            jobDuration: job.jobDuration,
            jobLocation: job.jobLocation,
            jobType: job.jobType,
          );
        },
      ),
    );
  }
}
