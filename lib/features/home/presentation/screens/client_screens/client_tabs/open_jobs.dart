import 'package:flutter/material.dart';
import 'package:legwork/Features/home/domain/entities/job_entity.dart';
import 'package:legwork/Features/home/presentation/provider/job_provider.dart';
import 'package:legwork/Features/home/presentation/widgets/legwork_job_container.dart';
import 'package:provider/provider.dart';

class OpenJobs extends StatefulWidget {
  const OpenJobs({super.key});

  @override
  State<OpenJobs> createState() => _OpenJobsState();
}

class _OpenJobsState extends State<OpenJobs> {
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

  //* BUILD METHOD
  @override
  Widget build(BuildContext context) {
    final jobs = listeningProvider.allJobs;

    // Handle case where no jobs exists
    if (jobs.isEmpty) {
      debugPrint("Jobs: $jobs");
      return const Center(
        child: Text('Nothing here...YET'),
      );
    }

    List<JobEntity> openJobs = jobs["openJobs"] ?? [];
    // List<JobEntity> closedJobs = jobs["closedJobs"] ?? [];
    return buildJobList(openJobs);
  }

  // BUILD JOBS LIST
  Widget buildJobList(List<JobEntity> jobs) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.builder(
        itemCount: jobs.length,
        itemBuilder: (context, index) {
          // Get each individual job
          final job = jobs[index];

          // Display it in UI
          return LegworkJobContainer(
            onJobTap: () {},
            onIconTap: () {},
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
