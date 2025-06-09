import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:legwork/core/Constants/helpers.dart';
import 'package:legwork/core/widgets/legwork_text_button.dart';
import 'package:legwork/features/auth/presentation/Provider/my_auth_provider.dart';
import 'package:legwork/features/auth/presentation/Widgets/auth_loading_indicator.dart';
import 'package:legwork/features/auth/presentation/widgets/legwork_elevated_button.dart';
import 'package:legwork/features/chat/domain/entites/conversation_entity.dart';
import 'package:legwork/features/chat/presentation/provider/chat_provider.dart';
import 'package:legwork/features/chat/presentation/screens/chat_detail_screen.dart';
import 'package:legwork/features/job_application/data/models/job_application_model.dart';
import 'package:legwork/features/job_application/presentation/provider/job_application_provider.dart';
import 'package:legwork/features/job_application/presentation/widgets/applicant_info_card.dart';
import 'package:legwork/core/widgets/legwork_snackbar.dart';
import 'package:legwork/features/job_application/presentation/widgets/legwork_outline_button.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class JobApplicationDetailScreen extends StatefulWidget {
  const JobApplicationDetailScreen({super.key});

  @override
  State<JobApplicationDetailScreen> createState() =>
      _JobApplicationDetailScreenState();
}

class _JobApplicationDetailScreenState
    extends State<JobApplicationDetailScreen> {
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

    final provider = Provider.of<MyAuthProvider>(context, listen: false);

    final result = await provider.getUserDetails(uid: app.dancerId);
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
          dancerUserName = data.username;
          dancerProfileImage = data.profilePicture;
          isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get the arguments passed to this screen from the previou screen
    final JobApplicationModel application =
        ModalRoute.of(context)!.settings.arguments as JobApplicationModel;

    // Job provider
    final jobAppProvider =
        Provider.of<JobApplicationProvider>(context, listen: false);

    // Auth provider
    final authProvider = Provider.of<MyAuthProvider>(context, listen: false);
    final clientId = authProvider.getUserId();

    String? clientEmail;

    final String dancerId = application.dancerId;
    final String proposal = application.proposal;
    final String status = application.applicationStatus;
    final String applicationId = application.applicationId;

    Future<String> fetchClientDetails() async {
      final result = await authProvider.getUserDetails(uid: clientId);
      result.fold(
        (fail) => Left(fail),
        (userEntity) {
          clientEmail = userEntity.email;
          return Right(clientEmail);
        },
      );
      return clientEmail!;
    }

    Color statusColor;
    IconData statusIcon;

    // Set color and icon based on application status
    if (status.toLowerCase() == 'accepted') {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
    } else if (status.toLowerCase() == 'rejected') {
      statusColor = Colors.red;
      statusIcon = Icons.cancel;
    } else {
      statusColor = Colors.grey;
      statusIcon = Icons.question_mark;
    }

    // CHAT WITH JOB APPLICANT(DANCER)
    void chatWithDancer() async {
      try {
        ConversationEntity convoEntity = ConversationEntity(
          convoId: '',
          participants: [dancerId, clientId],
          lastMessageTime: DateTime.now(),
          lastMessage: '',
          lastMessageSenderId: '',
          hasUnreadMessages: true,
        );
        setState(() {
          _isChatLoading = true;
        });

        // Create a conversation ID (or fetch existing)
        final result = await context
            .read<ChatProvider>()
            .createConversation(convoEntity: convoEntity);

        result.fold(
            // Handle fail
            (error) {
          setState(() {
            _isChatLoading = false;
          });
          LegworkSnackbar(
            title: 'Omo!',
            subTitle: error,
            imageColor: context.colorScheme.onError,
            contentColor: context.colorScheme.error,
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
                conversationId: conversation.convoId,
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
          title: 'Omo!',
          subTitle: 'An unexpected error occurred. Please try again.',
          imageColor: context.colorScheme.onError,
          contentColor: context.colorScheme.error,
        ).show(context);
      }
    }

    // ACCEPT JOB APPLICATION
    Future<void> onAcceptApplication({required String applicationId}) async {
      showLoadingIndicator(context);
      try {
        final resultt = await jobAppProvider.acceptApplication(
          applicationId: applicationId,
        );

        resultt.fold(
          // Handle fail
          (error) {
            Navigator.pop(context); // Close loading indicator
            LegworkSnackbar(
              title: 'Omo!',
              subTitle: 'Failed to accept application',
              imageColor: context.colorScheme.onError,
              contentColor: context.colorScheme.error,
            ).show(context);
            debugPrint('Failed to accept application: $error');
            return Left(error);
          },

          // Handle success
          (_) async {
            Navigator.pop(context); // Close loading indicator

            // Show snackbar
            LegworkSnackbar(
              title: 'Sharp guy!',
              subTitle: "Application accepted",
              imageColor: context.colorScheme.onPrimary,
              contentColor: context.colorScheme.primary,
            ).show(context);

            setState(() {
              application.applicationStatus = 'Accepted';
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
    Future<void> onRejectApplication({required String applicationId}) async {
      // Show a confirmation dialog first
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Confirm Rejection',
            style: context.headingXs?.copyWith(fontWeight: FontWeight.bold),
          ),
          content:
              const Text('Are you sure you want to reject this application?'),
          actions: [
            LegworkTextButton(
              foregroundColor: context.colorScheme.primary,
              onPressed: () => Navigator.pop(context, false),
              buttonText: 'Cancel',
            ),
            LegworkTextButton(
              buttonText: 'Reject',
              foregroundColor: context.colorScheme.error,
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        ),
      );

      if (confirm != true) return;

      showLoadingIndicator(context);
      try {
        final result = await jobAppProvider.rejectApplication(
          applicationId: applicationId,
        );

        result.fold(
          // handle fail
          (error) {
            Navigator.pop(context); // Close loading indicator
            LegworkSnackbar(
              title: 'Omo!',
              subTitle: 'Failed to reject application',
              imageColor: context.colorScheme.onError,
              contentColor: context.colorScheme.error,
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
              imageColor: context.colorScheme.onPrimary,
              contentColor: context.colorScheme.primary,
            ).show(context);

            // Update the UI with new status
            setState(() {
              application.applicationStatus = 'Rejected';
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
      backgroundColor: context.colorScheme.surface,

      floatingActionButton: status.toLowerCase() == 'accepted'
          ? FloatingActionButton(
              onPressed: () async {
                final email = await fetchClientDetails();
                Navigator.of(context).pushNamed('/paymentScreen', arguments: {
                  'dancerId': dancerId,
                  'clientId': clientId,
                  'amount': 100.0,
                  'email': email,
                });
              },
              child: const Icon(Icons.payment),
            )
          : null,

      // * APPBAR
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.colorScheme.surface,
        centerTitle: true,
        title: Text(
          isLoading ? 'Loading Applicant Details...' : 'Application Details',
          style: context.heading2Xs?.copyWith(
            fontWeight: FontWeight.w500,
            color: context.colorScheme.onSurface,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      // * BODY
      body: isLoading
          ? Center(
              child: Lottie.asset(
                'assets/lottie/loading.json',
                height: 100,
                fit: BoxFit.contain,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //* APPLICANT CARD INFO
                  ApplicantInfoCard(
                    colorScheme: context.colorScheme,
                    dancerProfileImage: dancerProfileImage,
                    dancerUserName: dancerUserName,
                    status: status,
                  ),

                  const SizedBox(height: 24),

                  // * PROPOSAL SECTION
                  Text(
                    "Proposal",
                    style: context.text2Xl?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: context.colorScheme.onSurface,
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
                        style: context.textXl?.copyWith(
                          color: context.colorScheme.onSurface,
                          fontWeight: FontWeight.w400,
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
                            Text(
                              "Take Action",
                              style: context.text2Xl?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: context.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // * BUTTON TO CHAT WITH DANCER
                            LegworkOutlineButton(
                              isLoading: _isChatLoading,
                              onPressed: chatWithDancer,
                              icon: SvgPicture.asset(
                                'assets/svg/chat_icon.svg',
                                color: context.colorScheme.primary,
                              ),
                              buttonText: 'Message dancer',
                            ),
                            const SizedBox(height: 16),

                            Row(
                              children: [
                                // * ACCEPT BUTTON
                                Expanded(
                                  child: LegworkElevatedButton(
                                    onPressed: () => onAcceptApplication(
                                        applicationId: applicationId),
                                    buttonText: 'Accept',
                                    backgroundColor:
                                        context.colorScheme.primary,
                                    icon: Icon(
                                      Icons.check,
                                      color: context.colorScheme.onPrimary,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // * REJECT BUTTON
                                Expanded(
                                  child: LegworkElevatedButton(
                                    onPressed: () => onRejectApplication(
                                        applicationId: applicationId),
                                    buttonText: 'Reject',
                                    backgroundColor: context.colorScheme.error,
                                    icon: Icon(
                                      Icons.close,
                                      color: context.colorScheme.onError,
                                    ),
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
                              LegworkOutlineButton(
                                isLoading: _isChatLoading,
                                onPressed: chatWithDancer,
                                icon: SvgPicture.asset(
                                  'assets/svg/chat_icon.svg',
                                ),
                                buttonText: 'Message dancer',
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(statusIcon, color: statusColor),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Application is $status",
                                        style: context.textMd?.copyWith(
                                          color: statusColor,
                                          fontWeight: FontWeight.w500,
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
