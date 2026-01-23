import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:legwork/core/Constants/helpers.dart';
import 'package:legwork/core/widgets/legwork_snackbar.dart';
import 'package:legwork/features/auth/domain/Entities/user_entities.dart';
import 'package:legwork/features/home/presentation/provider/job_provider.dart';
import 'package:legwork/features/job_application/presentation/provider/job_application_provider.dart';
import 'package:legwork/features/job_application/presentation/widgets/job_applicants_empty_state.dart';
import 'package:legwork/features/job_application/presentation/widgets/job_applicants_list.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class ViewJobApplicantsScreen extends StatefulWidget {
  final String jobId;
  final String clientId;
  final bool status;

  const ViewJobApplicantsScreen({
    super.key,
    required this.jobId,
    required this.clientId,
    required this.status,
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
    userId: '',
  );

  bool isLoadingDancerDetails = true; // Track loading state for dancer details
  bool _isLoading = false; // For closing the job

  // Init state to fetch all job applications when the screen loads
  @override
  void initState() {
    super.initState();
    fetchJobApplicationsAndDancerDetails();
  }

  // FETCH JOB APPLICATIONS AND DANCER DETAILS
  Future<void> fetchJobApplicationsAndDancerDetails() async {
    final jobApplicationProvider =
        Provider.of<JobApplicationProvider>(context, listen: false);

    // Fetch all job applications
    await jobApplicationProvider.getJobApplications(jobId: widget.jobId);

    // Fetch dancer details for each application
    final applications = jobApplicationProvider.allApplications;
    for (var application in applications) {
      // Get the dancer's details
      final result = await jobApplicationProvider.getUserDetails(
        uid: application.dancerId,
      );

      result.fold(
          // handle fail
          (fail) => debugPrint(
                'Error fetching dancer details for ${application.dancerId}: $fail',
              ),

          // handle success
          (dancerData) {
        setState(() {
          dancerDetails = dancerData;
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
    final jobProvider = Provider.of<JobProvider>(context, listen: false);

    // * Update job stats
    void updateJobStatus() async {
      setState(() {
        _isLoading = true;
      });

      final res = await jobProvider.updateJobStatus(
        jobId: widget.jobId,
        status: false,
      );

      setState(() {
        _isLoading = false;
      });

      res.fold((fail) {
        return Left(fail);
      }, (data) {
        final String message = data['message'];
        LegworkSnackbar(
          title: 'Nice!',
          subTitle: message,
          imageColor: context.colorScheme.onPrimary,
          contentColor: context.colorScheme.primary,
        ).show(context);
      });
    }

    Future<dynamic> closeJobDialogBox() {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SizedBox(
              height: 159,
              width: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Are you sure you want to close this job?\nTHIS CAN NOT BE UNDONE',
                    style: context.heading2Xs?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.error,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // * Yes
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            updateJobStatus();
                          },
                          child: Text(
                            'Yes',
                            style: context.text2Xl?.copyWith(
                              color: context.colorScheme.error,
                            ),
                          )),

                      // * No
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          'No',
                          style: context.text2Xl?.copyWith(
                            color: context.colorScheme.primary,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
      );
    }

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
          style: context.heading2Xs?.copyWith(
            fontWeight: FontWeight.bold,
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
            return JobApplicantsEmptyState(
              jobStatus: widget.status,
              isLoading: _isLoading,
              onPressed: closeJobDialogBox,
            );
          }

          // * JOB APPLICANTS LIST
          return JobApplicantsList(
            onRefresh: fetchJobApplicationsAndDancerDetails,
            dancerDetails: dancerDetails,
            onCloseJob: closeJobDialogBox,
            isLoading: _isLoading,
            jobStatus: widget.status,
          );
        },
      ),
    );
  }
}
