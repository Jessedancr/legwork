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
    required String jobId,
    required String clientId,
    required String jobDescr,
  }) {
    Navigator.pushNamed(
      context,
      '/applyForJob',
      arguments: {'jobId': jobId, 'clientId': clientId, 'jobDescr': jobDescr},
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
            child: CircularProgressIndicator(),
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

        List<JobEntity> allJobs = jobs["allJobs"] ?? [];
        return buildJobList(allJobs);
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
            onJobTap: () => applyForJob(
              clientId: job.clientId,
              jobId: job.jobId,
              jobDescr: job.jobDescr,
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
