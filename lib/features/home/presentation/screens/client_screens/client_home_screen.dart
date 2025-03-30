import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:legwork/Features/auth/presentation/Widgets/auth_loading_indicator.dart';
import 'package:legwork/Features/auth/presentation/Widgets/legwork_snackbar_content.dart';
import 'package:legwork/Features/home/domain/entities/job_entity.dart';
import 'package:legwork/Features/home/presentation/provider/job_provider.dart';
import 'package:legwork/Features/home/presentation/screens/client_screens/client_tabs/open_jobs.dart';
import 'package:legwork/Features/home/presentation/screens/dancer_screens/dancer_tabs/jobs_for_you.dart';
import 'package:legwork/Features/home/presentation/widgets/clients_drawer.dart';
import 'package:legwork/Features/home/presentation/widgets/post_job_bottom_sheet.dart';
import 'package:provider/provider.dart';

class ClientHomeScreen extends StatefulWidget {
  // CONTROLLERS
  final TextEditingController titleController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController danceStylesController = TextEditingController();
  final TextEditingController payController = TextEditingController();
  final TextEditingController jobDurationController = TextEditingController();
  final TextEditingController amtOfDancersController = TextEditingController();
  final TextEditingController jobDescrController = TextEditingController();
  final SearchController searchController = SearchController();

  ClientHomeScreen({super.key});

  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  late Future<void> _fetchJobsFuture;

  @override
  void initState() {
    super.initState();
    _fetchJobsFuture = loadAllJobs();
  }

  Future<void> loadAllJobs() async {
    final jobProvider = Provider.of<JobProvider>(context, listen: false);
    await jobProvider.fetchJobs();
  }

  // BUILD METHOD
  @override
  Widget build(BuildContext context) {
    //SCREEN SIZE
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    // PROVIDER
    final jobProvider = Provider.of<JobProvider>(context);
    // METHOD TO POST JOB TO FIREBASE
    void postJob({required String jobId, required String clientId}) async {
      Navigator.of(context).pop();
      showLoadingIndicator(context);
      // post job to firebase and display a snack bar with a success message
      try {
        final result = await jobProvider.postJob(
            job: JobEntity(
          jobTitle: widget.titleController.text,
          jobLocation: widget.locationController.text,
          pay: widget.payController.text,
          amtOfDancers: widget.amtOfDancersController.text,
          jobDuration: widget.jobDurationController.text,
          jobDescr: widget.jobDescrController.text,
          jobType: widget.searchController.text,
          jobId: jobId,
          clientId: clientId,
          status: true,
          prefDanceStyles: widget.danceStylesController.text
              .trim()
              .split(RegExp(r'(\s*,\s)+'))
              .where((style) => style
                  .isNotEmpty) // Remove empty entries => entries that meet the condition will stay
              .toList(),
          createdAt: DateTime.now(),
        ));

        result.fold(
            // Handle fail
            (fail) {
          debugPrint('Posting job to firebase failed: $fail');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 5),
              content: LegWorkSnackBarContent(
                screenHeight: screenHeight,
                context: context,
                screenWidth: screenWidth,
                title: 'Omo!',
                subTitle: fail,
                contentColor: Theme.of(context).colorScheme.error,
                imageColor: Theme.of(context).colorScheme.onError,
              ),
            ),
          );
        },

            // Handle success
            (success) async {
          debugPrint('Successfully posted job');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 5),
              content: LegWorkSnackBarContent(
                screenHeight: screenHeight,
                context: context,
                screenWidth: screenWidth,
                title: 'Nice!',
                subTitle: 'Job posted successfully',
                contentColor: Theme.of(context).colorScheme.primary,
                imageColor: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          );
          // Clear controllers
          widget.titleController.clear();
          widget.locationController.clear();
          widget.danceStylesController.clear();
          widget.payController.clear();
          widget.jobDurationController.clear();
          widget.amtOfDancersController.clear();
          widget.jobDescrController.clear();
          widget.searchController.clear();

          // Refresh job list
          await jobProvider.fetchJobs();
        });

        hideLoadingIndicator(context);
      } catch (e) {
        debugPrint('Error posting job: $e');
        hideLoadingIndicator(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to post job: $e')),
        );
      }
    }

    // METHOD TO POST NEW JOB
    void openJobModalSheet() {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return PostJobBottomSheet(
            onPressed: () async {
              // Generate jobId and get clientId
              final String jobId =
                  Provider.of<JobProvider>(context, listen: false)
                      .jobRepo
                      .jobService
                      .db
                      .collection('jobs')
                      .doc()
                      .id;
              final String clientId =
                  FirebaseAuth.instance.currentUser?.uid ?? '';

              // Call postJob with jobId and clientId
              postJob(jobId: jobId, clientId: clientId);
            },
            titleController: widget.titleController,
            locationController: widget.locationController,
            danceStylesController: widget.danceStylesController,
            payController: widget.payController,
            jobDurationController: widget.jobDurationController,
            amtOfDancersController: widget.amtOfDancersController,
            jobDescrController: widget.jobDescrController,
            searchController: widget.searchController,
          );
        },
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        //* Drawer
        drawer: const ClientsDrawer(),

        //* Floating action button
        floatingActionButton: FloatingActionButton(
          onPressed: openJobModalSheet,
          child: const Icon(Icons.add),
        ),

        //* AppBar
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0,
          centerTitle: true,
          title: const TabBar(
            tabs: [
              Tab(text: 'Open Jobs'),
              Tab(text: 'Closed Jobs'),
            ],
          ),
          leading: Builder(
            builder: (context) => IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(
                Icons.menu,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ),

        //* Body
        body: FutureBuilder(
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

            return const TabBarView(
              children: [
                OpenJobs(),
                JobsForYou(),
              ],
            );
          },
        ),
      ),
    );
  }
}
