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

  // ON STARTUP
  @override
  void initState() {
    super.initState();

    loadAllJobs();
  }

  // Load all posts
  Future<void> loadAllJobs() async {
    await jobProvider.fetchJobs();
    setState(() {
      isLoading = false;
    });
  }

  // Method to apply for job
  void applyForJob({required String jobId, required String clientId}) {
    Navigator.pushNamed(
      context,
      '/applyForJob',
      arguments: {'jobId': jobId, 'clientId': clientId},
    );
  }

  //* BUILD METHOD
  @override
  Widget build(BuildContext context) {
    final jobs = listeningProvider.allJobs;

    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text(
              'Fetching Jobs...',
              style: TextStyle(
                fontFamily: 'RobotoSlab',
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    // Handle case where no jobs exists
    if (jobs.isEmpty) {
      debugPrint("Jobs: $jobs");
      return const Center(
        child: Text(
          'Nothing here...YET',
          style: TextStyle(
            fontFamily: 'RobotoSlab',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    List<JobEntity> allJobs = jobs["allJobs"] ?? [];
    return buildJobList(allJobs);
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
            onJobTap: () => applyForJob(
              clientId: job.clientId,
              jobId: job.jobId,
            ),
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
