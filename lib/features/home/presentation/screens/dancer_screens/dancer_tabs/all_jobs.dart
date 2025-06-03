import 'package:flutter/material.dart';
import 'package:legwork/features/home/domain/entities/job_entity.dart';
import 'package:legwork/features/home/presentation/provider/job_provider.dart';
import 'package:legwork/features/home/presentation/widgets/legwork_job_container.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class AllJobs extends StatefulWidget {
  const AllJobs({super.key});

  @override
  State<AllJobs> createState() => _AllJobsState();
}

class _AllJobsState extends State<AllJobs> with AutomaticKeepAliveClientMixin {
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

  // Method to apply for job
  void applyForJob({
    required JobEntity jobEntity,
  }) {
    Navigator.pushNamed(
      context,
      '/applyForJob',
      arguments: jobEntity,
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
          return Center(
            child: Lottie.asset(
              'assets/lottie/loading.json',
              height: 100,
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

        List<JobEntity> allJobs = jobs["allJobs"] ?? [];
        return buildJobList(allJobs);
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
            onJobTap: () => applyForJob(
              jobEntity: job,
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
