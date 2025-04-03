import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:legwork/Features/auth/presentation/Widgets/auth_loading_indicator.dart';
import 'package:legwork/Features/auth/presentation/Widgets/blur_effect.dart';
import 'package:legwork/Features/auth/presentation/Widgets/large_textfield.dart';
import 'package:legwork/Features/chat/presentation/provider/chat_provider.dart';
import 'package:legwork/Features/chat/presentation/screens/chat_detail_screen.dart';
import 'package:legwork/Features/job_application/domain/entities/job_application_entity.dart';
import 'package:legwork/Features/job_application/presentation/provider/job_application_provider.dart';
import 'package:legwork/Features/onboarding/presentation/widgets/onboard_button.dart';
import 'package:legwork/core/widgets/legwork_snackbar.dart';
import 'package:provider/provider.dart';

class ApplyForJobScreen extends StatefulWidget {
  final String jobId;
  final String clientId;
  final String jobDescr;

  final String clientImageUrl; // Added client image URL

  const ApplyForJobScreen({
    super.key,
    required this.jobId,
    required this.clientId,
    required this.jobDescr,
    required this.clientImageUrl,
  });

  @override
  State<ApplyForJobScreen> createState() => _ApplyForJobScreenState();
}

class _ApplyForJobScreenState extends State<ApplyForJobScreen> {
  final TextEditingController proposalController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // INIT STATE TO FETCH CLIENT DETAILS WHEN THE SCREEN LOADS
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<JobApplicationProvider>(context, listen: false)
          .getClientDetails(widget.clientId);
    });
  }

  // METHOD TO NAVIGATE TO CHAT
  void chatWithClient() {
    final theme = Theme.of(context);
    final clientId = widget.clientId;
    final dancerId = FirebaseAuth.instance.currentUser!.uid;

    // Create a conversation ID
    context.read<ChatProvider>().createConversation(
      participants: [dancerId, clientId],
    ).then((result) {
      result.fold(
          // handle fail
          (fail) => LegworkSnackbar(
                title: 'Error',
                subTitle: fail,
                imageColor: theme.colorScheme.onError,
                contentColor: theme.colorScheme.error,
              ).show(context),

          // handle success
          (conversation) {
        // Send an initial message
        context
            .read<ChatProvider>()
            .sendMessage(
              conversationId: conversation.id,
              senderId: dancerId,
              receiverId: clientId,
              content: "Hi, I'm interested in discussing this job opportunity.",
            )
            .then((_) {
          // Now navigate to chat detail screen
          Navigator.pushNamed(
            context,
            '/chatDetailScreen',
            arguments: {
              'conversationId': conversation.id,
              'otherParticipantId': clientId,
            },
          );
        });
      });
    });
  }

  void _navToClientProfile(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,

        // * App bar
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0.0,
          centerTitle: true,
          iconTheme: IconThemeData(color: theme.colorScheme.surface),
          title: Text(
            "Let's get you hired!",
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.surface,
              fontWeight: FontWeight.w600,
            ),
          ),
          toolbarHeight: 56.0,
        ),

        // * Body
        body: Consumer<JobApplicationProvider>(
          builder: (context, provider, child) {
            final clientName =
                provider.clientDetails?['firstName'] ?? 'Client name';
            final email = provider.clientDetails?['email'] ?? 'client emai';
            final phoneNum =
                provider.clientDetails?['phoneNumber'] ?? '123456789';
            final organisationName =
                provider.clientDetails?['organisationName'] ?? 'clientName';

            return Column(
              children: [
                //* Job Description Section
                Expanded(
                  flex: 1,
                  // * container holding the bg image
                  child: SingleChildScrollView(
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('images/depictions/img_depc2.jpg'),
                          filterQuality: FilterQuality.high,
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Center(
                        child: BlurEffect(
                          sigmaX: 5,
                          sigmaY: 5,
                          firstGradientColor: Colors.black.withOpacity(0.7),
                          secondGradientColor: Colors.black.withOpacity(0.5),
                          padding: const EdgeInsets.all(20),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight:
                                  MediaQuery.of(context).size.height * 0.1,
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.4,
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Job Description',
                                    style:
                                        theme.textTheme.headlineSmall?.copyWith(
                                      color: theme.colorScheme.surface,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    widget.jobDescr,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: theme.colorScheme.surface
                                          .withOpacity(0.9),
                                      height: 1.5,
                                      letterSpacing: 0,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                //* Application Form Section
                Expanded(
                  flex: 2,
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(30)),
                    child: Container(
                      color: theme.colorScheme.surface,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // * Avatar image goes here
                              GestureDetector(
                                onTap: () => _navToClientProfile(context),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 8),
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundImage: widget
                                              .clientImageUrl.isNotEmpty
                                          ? NetworkImage(widget.clientImageUrl)
                                          : const AssetImage(
                                              'images/depictions/img_depc1.jpg',
                                            ),
                                    ),
                                    const SizedBox(height: 8),

                                    // * Client name
                                    Text(
                                      organisationName ?? clientName,
                                      style:
                                          theme.textTheme.bodyLarge?.copyWith(
                                        color: theme.colorScheme.onSurface,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),

                              // * PROPOSAL
                              Text(
                                'Your Proposal',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),

                              Text(
                                'Explain why you\'re the best fit for this job',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.7),
                                ),
                              ),
                              const SizedBox(height: 24),

                              //* Proposal Text Field
                              Material(
                                elevation: 4,
                                borderRadius: BorderRadius.circular(16),
                                color: theme.colorScheme.primaryContainer,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  child: LargeTextField(
                                    hintText:
                                        'Describe your skills and experience...',
                                    obscureText: false,
                                    controller: proposalController,
                                    icon: SvgPicture.asset(
                                      'assets/svg/pen_circle.svg',
                                      fit: BoxFit.scaleDown,
                                      color: theme.colorScheme.surface,
                                    ),
                                    maxLength: 1000,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please write a proposal';
                                      }
                                      if (value.length < 50) {
                                        return 'Please write at least 50 characters';
                                      }
                                      return null;
                                    },
                                    iconContainercolor:
                                        theme.colorScheme.onPrimaryContainer,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Minimum 50 characters',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.5),
                                ),
                              ),
                              const SizedBox(height: 32),

                              //* Message Client Button
                              OutlinedButton.icon(
                                icon: Icon(
                                  Icons.message_outlined,
                                  color: theme.colorScheme.primary,
                                ),
                                label: Text(
                                  organisationName != null
                                      ? 'Message $organisationName'
                                      : 'Message $clientName',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  side: BorderSide(
                                      color: theme.colorScheme.primary),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                onPressed: chatWithClient,
                              ),
                              const SizedBox(height: 16),

                              //* Apply Button
                              OnboardButton(
                                buttonText: 'Submit Application',
                                onPressed: applyForJob,
                                buttonColor: theme.colorScheme.primary,
                                borderColor:
                                    theme.colorScheme.onPrimaryContainer,
                              ),
                              const SizedBox(height: 24),

                              //* Contact Information
                              _buildContactInfo(
                                icon: Icons.email_outlined,
                                text: email,
                                theme: theme,
                              ),
                              const SizedBox(height: 12),
                              _buildContactInfo(
                                icon: Icons.phone_outlined,
                                text: '+234 ${phoneNum.toString()}',
                                theme: theme,
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  //* CONTACT INFO
  Widget _buildContactInfo({
    required IconData icon,
    required String text,
    required ThemeData theme,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  ///* FUNCTION TO APPLY FOR JOB
  Future<void> applyForJob() async {
    if (!_formKey.currentState!.validate()) return;

    showLoadingIndicator(context);
    try {
      // fetch the currently logged in dancer's ID
      final dancerIdResult =
          await Provider.of<JobApplicationProvider>(context, listen: false)
              .getUserId();

      // Handle the Either result
      final dancerId = dancerIdResult.fold(
        (failure) {
          hideLoadingIndicator(context);
          debugPrint('Failed to fetch dancer ID: $failure');
          LegworkSnackbar(
            title: 'Error',
            subTitle: 'Failed to fetch your ID: $failure',
            imageColor: Theme.of(context).colorScheme.onError,
            contentColor: Theme.of(context).colorScheme.error,
          ).show(context);
          return null; // Return null to stop further execution
        },
        (id) => id,
      );

      if (dancerId == null) return; // Stop execution if dancerId is null

      // Dancer's application
      final application = JobApplicationEntity(
        jobId: widget.jobId,
        dancerId: dancerId,
        clientId: widget.clientId,
        applicationStatus: "pending",
        proposal: proposalController.text,
        appliedAt: DateTime.now(),
        applicationId: '',
      );

      final result =
          await Provider.of<JobApplicationProvider>(context, listen: false)
              .applyForJob(application);

      result.fold(
        // Handle fail
        (fail) {
          hideLoadingIndicator(context);
          debugPrint('failed to apply for job: $fail');
          LegworkSnackbar(
            title: 'Application failed!',
            subTitle: fail,
            imageColor: Theme.of(context).colorScheme.surface,
            contentColor: Theme.of(context).colorScheme.error,
          ).show(context);
        },

        // Handle success
        (applicationId) async {
          hideLoadingIndicator(context);
          debugPrint('Application Successful. Application ID: $applicationId');
          debugPrint('Application Successful');
          LegworkSnackbar(
            title: 'Application Successful',
            subTitle: 'You have successfully applied for this job',
            imageColor: Theme.of(context).colorScheme.surface,
            contentColor: Theme.of(context).colorScheme.primary,
          ).show(context);
          Navigator.pop(context);
        },
      );
    } catch (e) {
      hideLoadingIndicator(context);
      debugPrint('An unknown error occured while applying for job: $e');
      LegworkSnackbar(
        title: 'Application failed!',
        subTitle: 'An unknown error occured!: $e',
        imageColor: Theme.of(context).colorScheme.onError,
        contentColor: Theme.of(context).colorScheme.error,
      ).show(context);
    }
  }
}
