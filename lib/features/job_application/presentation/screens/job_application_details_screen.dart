import 'package:dartz/dartz.dart' hide State;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:legwork/Features/auth/presentation/Widgets/auth_loading_indicator.dart';
import 'package:legwork/Features/chat/presentation/provider/chat_provider.dart';
import 'package:legwork/Features/chat/presentation/screens/chat_detail_screen.dart';
import 'package:legwork/Features/job_application/data/data_sources/job_application_remote_data_source.dart';
import 'package:legwork/Features/job_application/data/models/job_application_model.dart';
import 'package:legwork/Features/job_application/presentation/provider/job_application_provider.dart';
import 'package:legwork/Features/job_application/presentation/widgets/applicant_info_card.dart';
import 'package:legwork/Features/job_application/presentation/widgets/job_application_button.dart';
import 'package:legwork/core/widgets/legwork_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class JobApplicationDetailScreen extends StatefulWidget {
  const JobApplicationDetailScreen({super.key});

  @override
  State<JobApplicationDetailScreen> createState() =>
      _JobApplicationDetailScreenState();
}

class _JobApplicationDetailScreenState
    extends State<JobApplicationDetailScreen> {
  // * INSTANCE OF JOB APPLICATION DATA SOURCE
  final JobApplicationRemoteDataSource _dataSource =
      JobApplicationRemoteDataSource();

  // * INSTANCE OF FIREBASE MESSAGING
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  String? dancerUserName;
  String? dancerProfileImage;
  bool isLoading = true;
  bool _isChatLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchDancerDetails();
  }

  // Method to fetch dancer's details
  Future<void> _fetchDancerDetails() async {
    final JobApplicationModel app =
        ModalRoute.of(context)!.settings.arguments as JobApplicationModel;
    final provider =
        Provider.of<JobApplicationProvider>(context, listen: false);

    final result = await provider.getDancerDetails(dancerId: app.dancerId);
    if (!mounted) return;
    result.fold(
      (fail) {
        debugPrint('Failed to fetch dancer: $fail');
        setState(() {
          isLoading = false;
        });
      },
      (data) {
        setState(() {
          dancerUserName = data['username'] ?? 'Unknown';
          dancerProfileImage =
              data['profileImage']; // Assuming profile image URL is available
          isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final JobApplicationModel app =
        ModalRoute.of(context)!.settings.arguments as JobApplicationModel;

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final String dancerId = app.dancerId;
    final String proposal = app.proposal;
    final String status = app.applicationStatus;
    final String applicationId = app.applicationId;

    Color statusColor;
    IconData statusIcon;

    // Set color and icon based on application status
    switch (status.toLowerCase()) {
      case 'pending':
        statusColor = Colors.amber;
        statusIcon = Icons.hourglass_empty;
        break;
      case 'accepted':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'rejected':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.question_mark;
    }

    // CHAT WITH JOB APPLICANT(DANCER)
    void chatWithDancer() async {
      final theme = Theme.of(context);
      try {
        setState(() {
          _isChatLoading = true;
        });

        // Get the client and dancer IDs
        final clientId = FirebaseAuth.instance.currentUser!.uid;
        // final dancerId = applicantDetails.dancerId;

        // Create a conversation ID (or fetch existing)
        final result = await context.read<ChatProvider>().createConversation(
          participants: [clientId, dancerId],
        );

        result.fold(
            // Handle fail
            (error) {
          setState(() {
            _isChatLoading = false;
          });
          LegworkSnackbar(
            title: 'Oops',
            subTitle: error,
            imageColor: theme.colorScheme.onError,
            contentColor: theme.colorScheme.error,
          ).show(context);
        },

            // Handle success
            (conversation) {
          // Navigate to chat screen
          setState(() {
            _isChatLoading = false;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatDetailScreen(
                conversationId: conversation.id,
                otherParticipantId: dancerId,
              ),
            ),
          );
        });
      } catch (e) {
        // Handle any unexpected errors
        setState(() {
          _isChatLoading = false;
        });

        if (!mounted) return;
        LegworkSnackbar(
          title: 'Error',
          subTitle: 'An unexpected error occurred. Please try again.',
          imageColor: theme.colorScheme.onError,
          contentColor: theme.colorScheme.error,
        ).show(context);
      }
    }

    // ACCEPT JOB APPLICATION
    Future<void> onAcceptApplication(String applicationId) async {
      showLoadingIndicator(context);
      try {
        final result = await _dataSource.acceptApplication(applicationId);

        result.fold(
          // Handle fail
          (error) {
            Navigator.pop(context); // Close loading indicator
            LegworkSnackbar(
              title: 'Oops!',
              subTitle: 'Failed to accept application: $error',
              imageColor: Theme.of(context).colorScheme.onError,
              contentColor: Theme.of(context).colorScheme.error,
            ).show(context);
            debugPrint('Failed to accept application: $error');
            return Left(error);
          },

          // Handle success
          (_) async {
            Navigator.pop(context); // Close loading indicator

            // Show snackbar
            LegworkSnackbar(
              title: 'Success!',
              subTitle: "You've accepted this dancer's application",
              imageColor: colorScheme.onPrimary,
              contentColor: colorScheme.primary,
            ).show(context);

            setState(() {
              app.applicationStatus = 'Accepted';
            });

            Navigator.pop(context); // Return to previous screen
            return const Right(null);
          },
        );
      } catch (e) {
        Navigator.pop(context); // Close loading indicator
        debugPrint('An unknown error occurred accepting job application');
        return;
      }
    }

    // REJECT JOB APPLICATION
    Future<void> onRejectApplication(String applicationId) async {
      // Show a confirmation dialog first
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Confirm Rejection',
            style:
                textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          content:
              const Text('Are you sure you want to reject this application?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Reject'),
            ),
          ],
        ),
      );

      if (confirm != true) return;

      showLoadingIndicator(context);
      try {
        final result = await _dataSource.rejectApplication(applicationId);

        result.fold(
          // handle fail
          (error) {
            Navigator.pop(context); // Close loading indicator
            LegworkSnackbar(
              title: 'Oops!',
              subTitle: 'Failed to reject application: $error',
              imageColor: Theme.of(context).colorScheme.error,
              contentColor: Theme.of(context).colorScheme.onError,
            ).show(context);
            return Left(error);
          },

          // handle success
          (_) {
            Navigator.pop(context); // Close loading indicator
            LegworkSnackbar(
              title: 'Application Rejected',
              subTitle:
                  "You've rejected this application! That's so sad for the dancer",
              imageColor: colorScheme.onPrimary,
              contentColor: colorScheme.primary,
            ).show(context);

            // Update the UI with new status
            setState(() {
              app.applicationStatus = 'Rejected';
            });

            Navigator.pop(context); // Return to previous screen
            return const Right(null);
          },
        );
      } catch (e) {
        Navigator.pop(context); // Close loading indicator
        debugPrint('An unknown error occurred while rejecting application');
        return;
      }
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,

      // * APPBAR
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorScheme.surface,
        centerTitle: true,
        title: Text(
          isLoading ? 'Loading Applicant Details...' : 'Application Details',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      // * BODY
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //* APPLICANT CARD INFO
                  ApplicantInfoCard(
                    colorScheme: colorScheme,
                    dancerProfileImage: dancerProfileImage,
                    dancerUserName: dancerUserName,
                    status: status,
                  ),

                  const SizedBox(height: 24),

                  // * PROPOSAL SECTION
                  const Text(
                    "Proposal",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        proposal,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // * ACTION BUTTONS SECTION
                  status.toLowerCase() == 'pending'
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Divider(height: 32),
                            const Text(
                              "Take Action",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // * BUTTON TO CHAT WITH DANCER
                            JobApplicationButton(
                              isLoading: _isChatLoading,
                              colorScheme: colorScheme,
                              textTheme: textTheme,
                              onPressed: chatWithDancer,
                              backgroundColor: colorScheme.primaryContainer,
                              buttonText: 'Message Dancer',
                              buttonTextColor: colorScheme.onPrimaryContainer,
                              svgIconPath: '/assets/svg/chat_icon.svg',
                            ),
                            const SizedBox(height: 16),

                            Row(
                              children: [
                                // * ACCEPT BUTTON
                                Expanded(
                                  child: JobApplicationButton(
                                    isLoading: isLoading,
                                    colorScheme: colorScheme,
                                    textTheme: textTheme,
                                    onPressed: () =>
                                        onAcceptApplication(applicationId),
                                    backgroundColor: colorScheme.primary,
                                    buttonText: 'Accept',
                                    buttonTextColor: colorScheme.onPrimary,
                                    normalIcon: Icons.check,
                                    iconColor: colorScheme.onPrimary,
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // * REJECT BUTTON
                                Expanded(
                                  child: JobApplicationButton(
                                    isLoading: isLoading,
                                    colorScheme: colorScheme,
                                    textTheme: textTheme,
                                    onPressed: () =>
                                        onRejectApplication(applicationId),
                                    backgroundColor: colorScheme.error,
                                    buttonText: 'Reject',
                                    buttonTextColor: colorScheme.onError,
                                    normalIcon: Icons.close,
                                    iconColor: colorScheme.onError,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )

                      // * SHOW THIS GUY IF STATUS IS ACCEPTED OR REJECTED
                      : Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // * BUTTON TO CHAT WITH DANCER
                              JobApplicationButton(
                                isLoading: _isChatLoading,
                                colorScheme: colorScheme,
                                textTheme: textTheme,
                                onPressed: chatWithDancer,
                                backgroundColor: colorScheme.primaryContainer,
                                buttonText: 'Message Dancer',
                                buttonTextColor: colorScheme.onPrimaryContainer,
                                svgIconPath: '/assets/svg/chat_icon.svg',
                              ),
                              const SizedBox(height: 32),

                              // * STATUS CARD
                              Card(
                                color: statusColor.withOpacity(0.1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  child: Row(
                                    // mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(statusIcon, color: statusColor),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Application is $status",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: statusColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
    );
  }
}
