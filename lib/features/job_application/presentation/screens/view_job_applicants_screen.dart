import 'package:flutter/material.dart';
import 'package:legwork/core/Constants/helpers.dart';
import 'package:legwork/features/auth/domain/Entities/user_entities.dart';
import 'package:legwork/features/auth/presentation/Provider/my_auth_provider.dart';
import 'package:legwork/features/job_application/presentation/provider/job_application_provider.dart';
import 'package:legwork/features/job_application/presentation/widgets/applicant_card.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:lottie/lottie.dart';
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
  UserEntity dancerDetails = UserEntity(
    username: 'username',
    email: 'email',
    password: 'password',
    firstName: 'firstName',
    lastName: 'lastName',
    phoneNumber: 'phoneNumber',
    userType: 'userType',
    deviceToken: 'deviceToken',
  );

  bool isLoadingDancerDetails = true; // Track loading state for dancer details

  // Init state to fetch all job applications when the screen loads
  @override
  void initState() {
    super.initState();
    fetchJobApplicationsAndDancerDetails();
  }

  // FETCH JOB APPLICATIONS AND DANCER DETAILS
  Future<void> fetchJobApplicationsAndDancerDetails() async {
    final authProvider = Provider.of<MyAuthProvider>(context, listen: false);
    final jobApplicationProvider =
        Provider.of<JobApplicationProvider>(context, listen: false);

    // Fetch all job applications
    await jobApplicationProvider.getJobApplications(jobId: widget.jobId);

    // Fetch dancer details for each application
    final applications = jobApplicationProvider.allApplications;
    for (var application in applications) {
      // Get the dancer's details
      final result =
          await authProvider.getUserDetails(uid: application.dancerId);

      result.fold(
          // handle fail
          (fail) => debugPrint(
                'Error fetching dancer details for ${application.dancerId}: $fail',
              ),

          // handle success
          (dancerData) {
        setState(() {
          dancerDetails = dancerData;
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

    return Scaffold(
      backgroundColor: context.colorScheme.surface,

      // * APPBAR
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        elevation: 0,
        centerTitle: true,
        backgroundColor: context.colorScheme.surface,
        title: Text(
          "Job Applicants",
          style: context.headingXs?.copyWith(
            fontWeight: FontWeight.w400,
            color: context.colorScheme.onSurface,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: context.colorScheme.onSurface,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),

      // * BODY
      body: Consumer<JobApplicationProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(
              child: Lottie.asset(
                'assets/lottie/loadingList.json',
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
            );
          }

          if (provider.allApplications.isEmpty) {
            return _buildEmptyState();
          }

          return _buildApplicantsList(provider);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.person_off_outlined,
            size: 80,
            color: Color(0xFFBDBDBD),
          ),
          const SizedBox(height: 24),
          Text(
            "No applicants yet",
            style: context.text2Xl?.copyWith(
              color: context.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "When dancers apply for this job, they'll appear here.",
            textAlign: TextAlign.center,
            style: context.textSm?.copyWith(
              color: context.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicantsList(JobApplicationProvider provider) {
    return LiquidPullToRefresh(
      onRefresh: fetchJobApplicationsAndDancerDetails,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: provider.allApplications.length,
        itemBuilder: (context, index) {
          final jobApplication = provider.allApplications[index];

          return ApplicantCard(
            jobApplication: jobApplication,
            dancerEntity: dancerDetails,
          );
        },
      ),
    );
  }
}
