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

  // ON STARTUP
  @override
  void initState() {
    super.initState();

    loadAllJobs();
  }

  // Load all posts
  Future<void> loadAllJobs() async {
    await jobProvider.getJobs();
  }

  // Navigate to job details screen
  void goToJobDetails() {}

  // Method to apply for job
  void applyForJob() {}

  // BUILD METHOD
  @override
  Widget build(BuildContext context) {
    return buildJobList(listeningProvider.allJobs);

    //     ListView.builder(
    //   itemCount: 10,
    //   itemBuilder: (context, index) {
    //     return LegworkJobContainer(
    //       onJobTap: applyForJob,
    //       onIconTap: goToJobDetails,
    //     );
    //   },
    // );
  }

  // BUILD JOBS LIST
  Widget buildJobList(List<JobEntity> jobs) {
    return jobs.isEmpty
        //* Return this is job list is empty
        ? const Center(
            child: Text('Nothing here...'),
          )

        //* Job list is not empty
        : ListView.builder(
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
              );
            },
          );
  }
}
