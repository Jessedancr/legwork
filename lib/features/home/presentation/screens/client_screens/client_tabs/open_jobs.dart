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

  bool isLoading = true;
  late Future<void> _fetchJobsFuture;

  // PULL TO REFRESH FUNCTION
  Future<void> _refresh() async {
    setState(() {
      isLoading = true;
    });
    await loadAllJobs();
    setState(() {
      isLoading = false;
    });
  }

  // ON STARTUP
  @override
  void initState() {
    super.initState();
    _fetchJobsFuture = loadAllJobs();
  }

  // Load all posts
  Future<void> loadAllJobs() async {
    await jobProvider.fetchJobs();
    setState(() {
      isLoading = false;
    });
  }

  void viewJobApplicants({required String jobId, required String clientId}) {
    Navigator.pushNamed(
      context,
      '/viewJobApplicantsScreen',
      arguments: {'jobId': jobId, 'clientId': clientId},
    );
  }

  //* BUILD METHOD
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchJobsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text(
                  'Fetching jobs please wait...',
                  style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                )
              ],
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        final jobs = listeningProvider.allJobs;

        if (jobs.isEmpty) {
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

        List<JobEntity> openJobs = jobs["openJobs"] ?? [];
        return buildJobList(openJobs);
      },
    );
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
            onJobTap: () => viewJobApplicants(
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
            createdAt: job.createdAt!,
          );
        },
      ),
    );
  }
}
