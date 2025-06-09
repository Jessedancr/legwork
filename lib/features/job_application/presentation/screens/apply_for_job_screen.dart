import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:legwork/core/Constants/helpers.dart';
import 'package:legwork/features/auth/presentation/Provider/my_auth_provider.dart';
import 'package:legwork/features/auth/presentation/Widgets/auth_loading_indicator.dart';
import 'package:legwork/features/auth/presentation/Widgets/blur_effect.dart';
import 'package:legwork/features/auth/presentation/Widgets/large_textfield.dart';
import 'package:legwork/features/auth/presentation/Widgets/legwork_elevated_button.dart';
import 'package:legwork/features/chat/domain/entites/conversation_entity.dart';
import 'package:legwork/features/chat/presentation/provider/chat_provider.dart';
import 'package:legwork/features/home/domain/entities/job_entity.dart';
import 'package:legwork/features/job_application/domain/entities/job_application_entity.dart';
import 'package:legwork/features/job_application/presentation/provider/job_application_provider.dart';
import 'package:legwork/features/job_application/presentation/widgets/legwork_outline_button.dart';
import 'package:legwork/core/widgets/legwork_snackbar.dart';
import 'package:provider/provider.dart';

class ApplyForJobScreen extends StatefulWidget {
  final JobEntity jobEntity;

  const ApplyForJobScreen({
    super.key,
    required this.jobEntity,
  });

  @override
  State<ApplyForJobScreen> createState() => _ApplyForJobScreenState();
}

class _ApplyForJobScreenState extends State<ApplyForJobScreen> {
  final TextEditingController proposalController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isChatLoading = false;

  // INIT STATE TO FETCH CLIENT DETAILS WHEN THE SCREEN LOADS
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<JobApplicationProvider>(context, listen: false)
          .getClientDetails(clientId: widget.jobEntity.clientId);
    });
  }

  // METHOD TO NAVIGATE TO CHAT
  void chatWithClient() async {
    final authProvider = Provider.of<MyAuthProvider>(context, listen: false);

    final dancerId = authProvider.getUserId();
    final clientId = widget.jobEntity.clientId;

    try {
      ConversationEntity convoEntity = ConversationEntity(
        convoId: 'convoId',
        participants: [dancerId, clientId],
        lastMessageTime: DateTime.now(),
        lastMessage: 'lastMessage',
        lastMessageSenderId: 'lastMessageSenderId',
        hasUnreadMessages: true,
      );

      setState(() {
        _isChatLoading = true;
      });

      // Create a conversation ID
      final result = await context.read<ChatProvider>().createConversation(
            convoEntity: convoEntity,
          );

      result.fold(
          // handle fail
          (fail) {
        setState(() {
          _isChatLoading = false;
        });
        LegworkSnackbar(
          title: 'Omo!',
          subTitle: fail,
          imageColor: context.colorScheme.onError,
          contentColor: context.colorScheme.error,
        ).show(context);
      },

          // handle success
          (conversation) async {
        // Reset loading state
        setState(() {
          _isChatLoading = false;
        });

        // Navigate to chat screen
        if (!mounted) return;
        Navigator.pushNamed(
          context,
          '/chatDetailScreen',
          arguments: {
            'conversationId': conversation.convoId,
            'otherParticipantId': clientId,
          },
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
        imageColor: context.colorScheme.onError,
        contentColor: context.colorScheme.error,
      ).show(context);
    }
  }

  ///* FUNCTION TO APPLY FOR JOB
  Future<void> applyForJob() async {
    if (!_formKey.currentState!.validate()) return;

    showLoadingIndicator(context);
    try {
      // Dancer's application
      final application = JobApplicationEntity(
        jobId: widget.jobEntity.jobId,
        dancerId: '',
        clientId: widget.jobEntity.clientId,
        applicationStatus: "pending",
        proposal: proposalController.text,
        appliedAt: DateTime.now(),
        applicationId: '',
      );

      final result =
          await Provider.of<JobApplicationProvider>(context, listen: false)
              .applyForJob(application: application);

      result.fold(
        // Handle fail
        (fail) {
          hideLoadingIndicator(context);
          debugPrint('failed to apply for job: $fail');
          LegworkSnackbar(
            title: 'Application failed!',
            subTitle: fail,
            imageColor: context.colorScheme.surface,
            contentColor: context.colorScheme.error,
          ).show(context);
        },

        // Handle success
        (applicationId) async {
          hideLoadingIndicator(context);
          debugPrint('Application Successful');
          LegworkSnackbar(
            title: 'Sharp guy!',
            subTitle: 'job application successful',
            imageColor: context.colorScheme.surface,
            contentColor: context.colorScheme.primary,
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
        imageColor: context.colorScheme.onError,
        contentColor: context.colorScheme.error,
      ).show(context);
    }
  }

  void _navToClientProfile(BuildContext context) {
    // Navigator.of(context).pushNamed(
    //   '/clientProfileScreen',
    //   arguments: widget.jobEntity,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,

        // * App bar
        appBar: AppBar(
          backgroundColor: Colors.black,
          scrolledUnderElevation: 0.0,
          elevation: 0.0,
          centerTitle: true,
          iconTheme: IconThemeData(color: context.colorScheme.surface),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: context.colorScheme.surface,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "Let's get you hired!",
            style: context.heading2Xs?.copyWith(
              color: context.colorScheme.surface,
              fontWeight: FontWeight.w500,
            ),
          ),
          toolbarHeight: 56.0,
        ),

        // * Body
        body: Consumer<JobApplicationProvider>(
          builder: (context, provider, child) {
            final clientName =
                provider.clientDetails?['firstName'] ?? 'Client name';
            final email = provider.clientDetails?['email'] ?? 'client email';
            final phoneNum =
                provider.clientDetails?['phoneNumber'] ?? '123456789';
            final organisationName =
                provider.clientDetails?['organisationName'] ?? 'clientName';

            final clientProfilePicture =
                provider.clientDetails?['profilePicture'];

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
                              minHeight: screenHeight(context) * 0.1,
                              maxHeight: screenHeight(context) * 0.4,
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Job Description',
                                      style: context.text2Xl?.copyWith(
                                        color: context.colorScheme.surface,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      widget.jobEntity.jobDescr,
                                      style: context.textXl?.copyWith(
                                        color: context.colorScheme.surface,
                                        height: 1.5,
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
                ),

                //* Application Form Section
                Expanded(
                  flex: 2,
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(30)),
                    child: Container(
                      color: context.colorScheme.surface,
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
                                        child: ClipOval(
                                          child: clientProfilePicture != null &&
                                                  clientProfilePicture!
                                                      .isNotEmpty
                                              ? Image.network(
                                                  clientProfilePicture!,
                                                  width: 60,
                                                  height: 60,
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.asset(
                                                  'images/depictions/img_depc1.jpg',
                                                  width: 60,
                                                  height: 60,
                                                  fit: BoxFit.cover,
                                                ),
                                        )),
                                    const SizedBox(height: 8),

                                    // * Client name
                                    Text(
                                      organisationName ?? clientName,
                                      style: context.textLg?.copyWith(
                                        color: context.colorScheme.onSurface,
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
                                style: context.text2Xl?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),

                              Text(
                                'Explain why you\'re the best fit for this job',
                                style: context.textXl?.copyWith(
                                  color: context.colorScheme.onSurface,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              const SizedBox(height: 24),

                              //* Proposal Text Field
                              Card(
                                elevation: 2.0,
                                color: context.colorScheme.primaryContainer,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 25,
                                  ),
                                  child: LargeTextField(
                                    labelText: 'Describe your skills...',
                                    obscureText: false,
                                    controller: proposalController,
                                    icon: SvgPicture.asset(
                                      'assets/svg/pen_circle.svg',
                                      fit: BoxFit.scaleDown,
                                      color: context.colorScheme.surface,
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
                                        context.colorScheme.onPrimaryContainer,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Minimum 50 characters',
                                style: context.textLg?.copyWith(
                                  color: context.colorScheme.onSurface
                                      .withOpacity(0.5),
                                ),
                              ),
                              const SizedBox(height: 32),

                              //* Message Client Button
                              LegworkOutlineButton(
                                onPressed: chatWithClient,
                                icon: SvgPicture.asset(
                                  'assets/svg/chat_icon.svg',
                                  fit: BoxFit.scaleDown,
                                  color: context.colorScheme.primary,
                                ),
                                isLoading: _isChatLoading,
                                buttonText: organisationName != null
                                    ? 'Message $organisationName'
                                    : 'Message $clientName',
                              ),
                              const SizedBox(height: 16),

                              //* Apply Button
                              LegworkElevatedButton(
                                onPressed: applyForJob,
                                buttonText: 'Submit Application',
                              ),
                              const SizedBox(height: 24),

                              //* Contact Information
                              _buildContactInfo(
                                icon: Icons.email_outlined,
                                text: email,
                              ),
                              const SizedBox(height: 12),
                              _buildContactInfo(
                                icon: Icons.phone_outlined,
                                text: phoneNum,
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
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: context.colorScheme.onSurface.withOpacity(0.6),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: context.textLg?.copyWith(
            color: context.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}
