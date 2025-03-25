// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:legwork/Features/auth/presentation/Widgets/auth_loading_indicator.dart';
// import 'package:legwork/Features/auth/presentation/Widgets/blur_effect.dart';
// import 'package:legwork/Features/auth/presentation/Widgets/large_textfield.dart';
// import 'package:legwork/Features/job_application/domain/entities/job_application_entity.dart';
// import 'package:legwork/Features/job_application/presentation/provider/job_application_provider.dart';
// import 'package:legwork/Features/onboarding/presentation/widgets/onboard_button.dart';
// import 'package:legwork/core/widgets/legwork_snackbar.dart';
// import 'package:provider/provider.dart';

// class ApplyForJobScreen extends StatefulWidget {
//   final String jobId;
//   final String clientId;
//   final String jobDescr;

//   const ApplyForJobScreen({
//     super.key,
//     required this.jobId,
//     required this.clientId,
//     required this.jobDescr,
//   });

//   @override
//   State<ApplyForJobScreen> createState() => _ApplyForJobScreenState();
// }

// class _ApplyForJobScreenState extends State<ApplyForJobScreen> {
//   final TextEditingController proposalController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     debugPrint("Job ID: ${widget.jobId}");
//     debugPrint("Client ID: ${widget.clientId}");
//     debugPrint("Job Descr: ${widget.jobDescr}");

//     final jobApplicationProvider =
//         Provider.of<JobApplicationProvider>(context, listen: false);

//     Future<void> applyForJob() async {
//       if (!_formKey.currentState!.validate()) return;

//       showLoadingIndicator(context);
//       try {
//         final application = JobApplicationEntity(
//           jobId: widget.jobId,
//           dancerId: '',
//           clientId: widget.clientId,
//           applicationStatus: "pending",
//           proposal: proposalController.text,
//           appliedAt: DateTime.now(),
//           applicationId: '',
//         );

//         final result = await jobApplicationProvider.applyForJob(application);

//         result.fold(
//           (fail) {
//             hideLoadingIndicator(context);
//             _showSnackBar(
//               context: context,
//               title: 'Application Failed',
//               message: fail,
//               isError: true,
//             );
//           },
//           (success) {
//             hideLoadingIndicator(context);
//             _showSnackBar(
//               context: context,
//               title: 'Application Submitted',
//               message: 'Your application was sent successfully!',
//               isError: false,
//             );
//             Navigator.pop(context); // Close screen after successful submission
//           },
//         );
//       } catch (e) {
//         hideLoadingIndicator(context);
//         _showSnackBar(
//           context: context,
//           title: 'Error',
//           message: 'An unexpected error occurred. Please try again.',
//           isError: true,
//         );
//       }
//     }

//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.black,
//         extendBodyBehindAppBar: true,

//         //* App bar
//         appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           elevation: 0.0,
//           centerTitle: true,
//           iconTheme: IconThemeData(color: theme.colorScheme.surface),
//           title: Text(
//             "Let's get you hired!",
//             style: theme.textTheme.titleLarge?.copyWith(
//               fontFamily: 'RobotoSlab',
//               color: theme.colorScheme.surface,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           toolbarHeight: 56.0,
//         ),

//         // * Body
//         body: Column(
//           children: [
//             //* Job Description Section
//             Expanded(
//               flex: 1,
//               child: Container(
//                 decoration: const BoxDecoration(
//                   image: DecorationImage(
//                     image: AssetImage('images/depictions/img_depc2.jpg'),
//                     filterQuality: FilterQuality.high,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 child: Center(
//                   child: BlurEffect(
//                     sigmaX: 5,
//                     sigmaY: 5,
//                     firstGradientColor: Colors.black.withOpacity(0.7),
//                     secondGradientColor: Colors.black.withOpacity(0.5),
//                     padding: const EdgeInsets.all(20),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           'Job Description',
//                           style: theme.textTheme.headlineSmall?.copyWith(
//                             fontFamily: 'RobotoSlab',
//                             color: theme.colorScheme.surface,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         Text(
//                           widget.jobDescr,
//                           style: theme.textTheme.bodyLarge?.copyWith(
//                             fontFamily: 'RobotoSlab',
//                             color: theme.colorScheme.surface.withOpacity(0.9),
//                             height: 1.5,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//             //* Application Form Section
//             Expanded(
//               flex: 2,
//               child: ClipRRect(
//                 borderRadius:
//                     const BorderRadius.vertical(top: Radius.circular(30)),
//                 child: Container(
//                   color: theme.colorScheme.surface,
//                   padding: const EdgeInsets.symmetric(horizontal: 24),
//                   child: SingleChildScrollView(
//                     child: Form(
//                       key: _formKey,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           const SizedBox(height: 24),
//                           Text(
//                             'Your Proposal',
//                             style: theme.textTheme.titleMedium?.copyWith(
//                               fontFamily: 'RobotoSlab',
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             'Explain why you\'re the best fit for this job',
//                             style: theme.textTheme.bodyMedium?.copyWith(
//                               fontFamily: 'RobotoSlab',
//                               color:
//                                   theme.colorScheme.onSurface.withOpacity(0.7),
//                             ),
//                           ),
//                           const SizedBox(height: 24),

//                           //* Proposal Text Field
//                           Material(
//                             elevation: 4,
//                             borderRadius: BorderRadius.circular(16),
//                             color: theme.colorScheme.primaryContainer,
//                             child: Padding(
//                               padding: const EdgeInsets.all(16),
//                               child: LargeTextField(
//                                 hintText:
//                                     'Describe your skills and experience...',
//                                 obscureText: false,
//                                 controller: proposalController,
//                                 icon: SvgPicture.asset(
//                                   'assets/svg/pen_circle.svg',
//                                   fit: BoxFit.scaleDown,
//                                   color: theme.colorScheme.surface,
//                                 ),
//                                 maxLength: 1000,
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'Please write a proposal';
//                                   }
//                                   if (value.length < 50) {
//                                     return 'Please write at least 50 characters';
//                                   }
//                                   return null;
//                                 },
//                                 iconContainercolor:
//                                     theme.colorScheme.onPrimaryContainer,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             'Minimum 50 characters',
//                             style: theme.textTheme.bodySmall?.copyWith(
//                               fontFamily: 'RobotoSlab',
//                               color:
//                                   theme.colorScheme.onSurface.withOpacity(0.5),
//                             ),
//                           ),
//                           const SizedBox(height: 32),

//                           //* Apply Button
//                           OnboardButton(
//                             buttonText: 'Submit Application',
//                             onPressed: applyForJob,
//                             buttonColor: theme.colorScheme.primary,
//                             borderColor: theme.colorScheme.onPrimaryContainer,
//                           ),
//                           const SizedBox(height: 24),

//                           //* Contact Information
//                           _buildContactInfo(
//                             icon: Icons.email_outlined,
//                             text: 'email@example.com',
//                             theme: theme,
//                           ),
//                           const SizedBox(height: 12),
//                           _buildContactInfo(
//                             icon: Icons.phone_outlined,
//                             text: '+1 (555) 123-4567',
//                             theme: theme,
//                           ),
//                           const SizedBox(height: 24),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   //* CONTACT INFO
//   Widget _buildContactInfo({
//     required IconData icon,
//     required String text,
//     required ThemeData theme,
//   }) {
//     return Row(
//       children: [
//         Icon(
//           icon,
//           size: 16,
//           color: theme.colorScheme.onSurface.withOpacity(0.6),
//         ),
//         const SizedBox(width: 8),
//         Text(
//           text,
//           style: theme.textTheme.bodySmall?.copyWith(
//             fontFamily: 'RobotoSlab',
//             color: theme.colorScheme.onSurface.withOpacity(0.6),
//           ),
//         ),
//       ],
//     );
//   }

//   //* SHOW SNACKBAR
//   void _showSnackBar({
//     required BuildContext context,
//     required String title,
//     required String message,
//     required bool isError,
//   }) {
//     final theme = Theme.of(context);

//     LegworkSnackbar(
//       title: title,
//       subTitle: message,
//       imageColor: isError ? theme.colorScheme.error : theme.colorScheme.primary,
//       contentColor:
//           isError ? theme.colorScheme.onError : theme.colorScheme.onPrimary,
//     ).show(context);
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:legwork/Features/auth/presentation/Widgets/auth_loading_indicator.dart';
import 'package:legwork/Features/auth/presentation/Widgets/blur_effect.dart';
import 'package:legwork/Features/auth/presentation/Widgets/large_textfield.dart';
import 'package:legwork/Features/job_application/domain/entities/job_application_entity.dart';
import 'package:legwork/Features/job_application/presentation/provider/job_application_provider.dart';
import 'package:legwork/Features/onboarding/presentation/widgets/onboard_button.dart';
import 'package:legwork/core/widgets/legwork_snackbar.dart';
import 'package:provider/provider.dart';

class ApplyForJobScreen extends StatefulWidget {
  final String jobId;
  final String clientId;
  final String jobDescr;
  final String clientName; // Added client name
  final String clientImageUrl; // Added client image URL

  const ApplyForJobScreen({
    super.key,
    required this.jobId,
    required this.clientId,
    required this.jobDescr,
    required this.clientName,
    required this.clientImageUrl,
  });

  @override
  State<ApplyForJobScreen> createState() => _ApplyForJobScreenState();
}

class _ApplyForJobScreenState extends State<ApplyForJobScreen> {
  final TextEditingController proposalController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // METHOD TO NAVIGATE TO CHAT
  void _navigateToClientChat(BuildContext context) {
    // TODO: Implement navigation to chat screen with client
    // Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(clientId: widget.clientId)));

    // Temporary snackbar to show the functionality
    LegworkSnackbar(
      title: 'Message ${widget.clientName}',
      subTitle: 'You will be redirected to the chat screen',
      imageColor: Theme.of(context).colorScheme.surface,
      contentColor: Theme.of(context).colorScheme.onPrimary,
    ).show(context);
  }

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
              fontFamily: 'RobotoSlab',
              color: theme.colorScheme.surface,
              fontWeight: FontWeight.w600,
            ),
          ),
          toolbarHeight: 56.0,
        ),

        // * Body
        body: Column(
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
                          minHeight: MediaQuery.of(context).size.height * 0.1,
                          maxHeight: MediaQuery.of(context).size.height * 0.4,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Job Description',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontFamily: 'RobotoSlab',
                                  color: theme.colorScheme.surface,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                widget.jobDescr,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontFamily: 'RobotoCondensed',
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
                            onTap: () => _navigateToClientChat(context),
                            child: Column(
                              children: [
                                const SizedBox(height: 8),
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage:
                                      widget.clientImageUrl.isNotEmpty
                                          ? NetworkImage(widget.clientImageUrl)
                                          : const AssetImage(
                                              'assets/images/default_avatar.png',
                                            ) as ImageProvider,
                                  child: widget.clientImageUrl.isEmpty
                                      ? Icon(
                                          Icons.person,
                                          size: 30,
                                          color: theme.colorScheme.surface,
                                        )
                                      : null,
                                ),
                                const SizedBox(height: 8),

                                // * Client name
                                Text(
                                  widget.clientName,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontFamily: 'RobotoSlab',
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
                              fontFamily: 'RobotoSlab',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Explain why you\'re the best fit for this job',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontFamily: 'RobotoSlab',
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.7),
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
                              fontFamily: 'RobotoSlab',
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.5),
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
                              'Message ${widget.clientName}',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side:
                                  BorderSide(color: theme.colorScheme.primary),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () => _navigateToClientChat(context),
                          ),
                          const SizedBox(height: 16),

                          //* Apply Button
                          OnboardButton(
                            buttonText: 'Submit Application',
                            onPressed: applyForJob,
                            buttonColor: theme.colorScheme.primary,
                            borderColor: theme.colorScheme.onPrimaryContainer,
                          ),
                          const SizedBox(height: 24),

                          //* Contact Information
                          _buildContactInfo(
                            icon: Icons.email_outlined,
                            text: 'email@example.com',
                            theme: theme,
                          ),
                          const SizedBox(height: 12),
                          _buildContactInfo(
                            icon: Icons.phone_outlined,
                            text: '+1 (555) 123-4567',
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
            fontFamily: 'RobotoSlab',
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  //* SHOW SNACKBAR
  void _showSnackBar({
    required BuildContext context,
    required String title,
    required String message,
    required bool isError,
  }) {
    final theme = Theme.of(context);

    LegworkSnackbar(
      title: title,
      subTitle: message,
      imageColor: isError ? theme.colorScheme.error : theme.colorScheme.surface,
      contentColor:
          isError ? theme.colorScheme.onError : theme.colorScheme.onSurface,
    ).show(context);
  }

  Future<void> applyForJob() async {
    if (!_formKey.currentState!.validate()) return;

    showLoadingIndicator(context);
    try {
      final application = JobApplicationEntity(
        jobId: widget.jobId,
        dancerId: '',
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
          // _showSnackBar(
          //   context: context,
          //   title: 'Application Failed',
          //   message: fail,
          //   isError: true,
          // );
          debugPrint('failed to apply for job: $fail');
          LegworkSnackbar(
            title: 'Application failed!',
            subTitle: fail,
            imageColor: Theme.of(context).colorScheme.surface,
            contentColor: Theme.of(context).colorScheme.error,
          );
        },

        // Handle success
        (success) {
          hideLoadingIndicator(context);
          _showSnackBar(
            context: context,
            title: 'Application Submitted',
            message: 'Your application was sent successfully!',
            isError: false,
          );
          Navigator.pop(context);
        },
      );
    } catch (e) {
      hideLoadingIndicator(context);
      _showSnackBar(
        context: context,
        title: 'Error',
        message: 'An unexpected error occurred. Please try again.',
        isError: true,
      );
    }
  }
}
