import 'package:flutter/material.dart';
import 'package:legwork/features/home/domain/entities/job_entity.dart';
import 'package:legwork/features/home/presentation/provider/job_provider.dart';
import 'package:legwork/features/home/presentation/widgets/legwork_job_container.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';

class OpenJobs extends StatefulWidget {
  const OpenJobs({super.key});

  @override
  State<OpenJobs> createState() => _OpenJobsState();
}

class _OpenJobsState extends State<OpenJobs>
    with AutomaticKeepAliveClientMixin {
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
    super.build(context);

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
    final colorScheme = Theme.of(context).colorScheme;
    return LiquidPullToRefresh(
      onRefresh: _refresh,
      color: colorScheme.primary,
      backgroundColor: colorScheme.surface,
      animSpeedFactor: 3.0,
      showChildOpacityTransition: false,
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
            createdAt: job.createdAt,
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
