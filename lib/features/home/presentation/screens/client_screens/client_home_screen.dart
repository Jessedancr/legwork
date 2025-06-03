import 'package:flutter/material.dart';
import 'package:legwork/core/Constants/helpers.dart';
import 'package:legwork/core/widgets/legwork_snackbar.dart';
import 'package:legwork/features/auth/presentation/Widgets/auth_loading_indicator.dart';
import 'package:legwork/features/home/domain/entities/job_entity.dart';
import 'package:legwork/features/home/presentation/provider/job_provider.dart';
import 'package:legwork/features/home/presentation/screens/client_screens/client_tabs/open_jobs.dart';
import 'package:legwork/features/home/presentation/screens/dancer_screens/dancer_tabs/jobs_for_you.dart';
import 'package:legwork/features/home/presentation/widgets/clients_drawer.dart';
import 'package:legwork/features/home/presentation/widgets/post_job_bottom_sheet.dart';
import 'package:lottie/lottie.dart';
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
    // PROVIDER
    final jobProvider = Provider.of<JobProvider>(context);
    // METHOD TO POST JOB TO FIREBASE
    void postJob() async {
      if (formKey.currentState!.validate()) {
        Navigator.of(context).pop();
        showLoadingIndicator(context);
        final jobEntity = JobEntity(
          jobTitle: widget.titleController.text,
          jobLocation: widget.locationController.text,
          pay: widget.payController.text,
          amtOfDancers: widget.amtOfDancersController.text,
          jobDuration: widget.jobDurationController.text,
          jobDescr: widget.jobDescrController.text,
          jobType: selectedJobType ?? 'N/A',
          jobId: 'jobId',
          clientId: 'clientId',
          status: true,
          prefDanceStyles: widget.danceStylesController.text
              .trim()
              .split(RegExp(r'(\s*,\s)+'))
              .where((style) => style
                  .isNotEmpty) // Remove empty entries => entries that meet the condition will stay
              .toList(),
          createdAt: DateTime.now(),
        );

        try {
          final result = await jobProvider.postJob(job: jobEntity);

          result.fold(
              // Handle fail
              (fail) {
            debugPrint('Posting job to firebase failed: $fail');
            LegworkSnackbar(
              title: 'Omo!',
              subTitle: fail,
              imageColor: context.colorScheme.onError,
              contentColor: context.colorScheme.error,
            ).show(context);
          },
              // Handle success
              (success) async {
            debugPrint('Successfully posted job');
            LegworkSnackbar(
              title: 'Sharp guy!',
              subTitle: 'Job posted successfuly',
              imageColor: context.colorScheme.onPrimary,
              contentColor: context.colorScheme.primary,
            ).show(context);
            // Clear controllers
            widget.titleController.clear();
            widget.locationController.clear();
            widget.danceStylesController.clear();
            widget.payController.clear();
            widget.jobDurationController.clear();
            widget.amtOfDancersController.clear();
            widget.jobDescrController.clear();
            widget.searchController.clear();
            selectedJobType = null;

            // Refresh job list
            await jobProvider.fetchJobs();
          });

          hideLoadingIndicator(context);
        } catch (e) {
          debugPrint('Error posting job: $e');
          hideLoadingIndicator(context);
          LegworkSnackbar(
            title: 'Omo!',
            subTitle: 'Unexpected error occured',
            imageColor: context.colorScheme.onError,
            contentColor: context.colorScheme.error,
          ).show(context);
        }
      }
    }

    // METHOD TO POST NEW JOB
    void openJobModalSheet() {
      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return PostJobBottomSheet(
            onPressed: postJob,
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
          backgroundColor: context.colorScheme.primary.withOpacity(0.8),
          child: const Icon(Icons.add),
        ),

        //* AppBar
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          backgroundColor: context.colorScheme.surface,
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
                color: context.colorScheme.onSurface,
              ),
            ),
          ),
        ),

        //* Body
        body: FutureBuilder(
          future: _fetchJobsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Lottie.asset(
                  'assets/lottie/loadingList.json',
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),
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
