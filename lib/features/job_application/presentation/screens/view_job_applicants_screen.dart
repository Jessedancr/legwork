import 'package:flutter/material.dart';
import 'package:legwork/Features/job_application/presentation/provider/job_application_provider.dart';
import 'package:legwork/Features/job_application/presentation/widgets/applicant_card.dart';
import 'package:provider/provider.dart';

class ViewJobApplicantsScreen extends StatefulWidget {
  final String jobId;
  final String clientId;

  const ViewJobApplicantsScreen({
    super.key,
    required this.jobId,
    required this.clientId,
  });

  @override
  State<ViewJobApplicantsScreen> createState() =>
      _ViewJobApplicantsScreenState();
}

class _ViewJobApplicantsScreenState extends State<ViewJobApplicantsScreen> {
  final TextEditingController proposalController = TextEditingController();
  // Map to store dancer details
  final Map<String, Map<String, dynamic>> dancerDetails = {};
  bool isLoadingDancerDetails = true; // Track loading state for dancer details

  // Init state to fetch all job applications when the screen loads
  @override
  void initState() {
    super.initState();
    fetchJobApplicationsAndDancerDetails();
  }

  // FETCH JOB APPLICATIONS AND DANCER DETAILS
  Future<void> fetchJobApplicationsAndDancerDetails() async {
    final provider =
        Provider.of<JobApplicationProvider>(context, listen: false);

    // Fetch all job applications
    await provider.getJobApplications(widget.jobId);

    // Fetch dancer details for each application
    final applications = provider.allApplications;
    for (var application in applications) {
      final result =
          await provider.getDancerDetails(dancerId: application.dancerId);
      result.fold(
          // handle fail
          (fail) => debugPrint(
                'Error fetching dancer details for ${application.dancerId}: $fail',
              ),

          // handle success
          (dancerData) {
        setState(() {
          // Store all dancer details in the map
          dancerDetails[application.dancerId] = dancerData;
          debugPrint(dancerData.toString());
        });
      });
    }
    // Mark dancer details loading as complete
    setState(() {
      isLoadingDancerDetails = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Extract arguments passed to the screen from the navigation
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    debugPrint("Job ID: ${args['jobId']}, Client ID: ${args['clientId']}");

    // Color scheme
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    // Text theme
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,

      // * APPBAR
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        title: Text(
          "Job Applicants",
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
            letterSpacing: 0.3,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: colorScheme.onSurface,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),

      // * BODY
      body: Consumer<JobApplicationProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return _buildLoadingState();
          }

          if (provider.allApplications.isEmpty) {
            debugPrint(
              "Job applications: ${provider.allApplications.toString()}",
            );
            return _buildEmptyState();
          }

          return _buildApplicantsList(provider);
        },
      ),
    );
  }

  // WIDGET TO BE DISPLAYED WHEN THE APPLICATIONS ARE STILL LOADING
  Widget _buildLoadingState() {
    // Color scheme
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 150,
                    height: 16,
                    color: colorScheme.surfaceDim,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    height: 12,
                    color: colorScheme.surfaceDim,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 200,
                    height: 12,
                    color: colorScheme.surfaceDim,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/no_applicants.png',
            height: 150,
            width: 150,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.person_off_outlined,
              size: 80,
              color: Color(0xFFBDBDBD),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "No applicants yet",
            style: TextStyle(
              fontFamily: 'RobotoSlab',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF303030),
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              "When dancers apply for this job, they'll appear here.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'RobotoSlab',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF757575),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicantsList(JobApplicationProvider provider) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return RefreshIndicator(
      onRefresh: fetchJobApplicationsAndDancerDetails,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: provider.allApplications.length,
        itemBuilder: (context, index) {
          final app = provider.allApplications[index];
          final dancer = dancerDetails[app.dancerId] ?? {};

          return ApplicantCard(
            app: app,
            dancer: dancer,
            colorScheme: colorScheme,
            textTheme: textTheme,
          );
        },
      ),
    );
  }
}
