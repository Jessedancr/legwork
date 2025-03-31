// import 'package:dartz/dartz.dart' hide State;
// import 'package:flutter/material.dart';
// import 'package:legwork/Features/auth/presentation/Widgets/auth_loading_indicator.dart';
// import 'package:legwork/Features/job_application/data/data_sources/job_application_remote_data_source.dart';
// import 'package:legwork/Features/job_application/data/models/job_application_model.dart';
// import 'package:legwork/Features/job_application/presentation/provider/job_application_provider.dart';
// import 'package:legwork/core/widgets/legwork_snackbar.dart';
// import 'package:provider/provider.dart';

// class JobApplicationDetailScreen extends StatefulWidget {
//   const JobApplicationDetailScreen({super.key});

//   @override
//   State<JobApplicationDetailScreen> createState() =>
//       _JobApplicationDetailScreenState();
// }

// class _JobApplicationDetailScreenState
//     extends State<JobApplicationDetailScreen> {
//   // Instance of remote datasource (backend)
//   final JobApplicationRemoteDataSource _dataSource =
//       JobApplicationRemoteDataSource();

//   // Variable to store the dancer's username
//   String? dancerUserName;
//   bool isLoadin = true;

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   _fetchDancerDetails();
//   // }
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _fetchDancerDetails(); // Move the fetch logic here
//   }

//   Future<void> _fetchDancerDetails() async {
//     final JobApplicationModel app =
//         ModalRoute.of(context)!.settings.arguments as JobApplicationModel;
//     final provider =
//         Provider.of<JobApplicationProvider>(context, listen: false);

//     final result = await provider.getDancerDetails(dancerId: app.dancerId);
//     result.fold(
//       // Handle fail
//       (fail) {
//         debugPrint('Failed to fetch dancer: $fail');
//         setState(() {
//           isLoadin = false;
//         });
//       },

//       // Handle success
//       (data) {
//         setState(() {
//           debugPrint('Dancers details data: ${data.toString()}');
//           dancerUserName = data['username'] ?? 'Unknown';
//           isLoadin = false;
//         });
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final JobApplicationModel app =
//         ModalRoute.of(context)!.settings.arguments as JobApplicationModel;

//     final String dancerId = app.dancerId;
//     final String proposal = app.proposal;
//     final String status = app.applicationStatus;
//     final String applicationId = app.applicationId;
//     // final String email = app.email;

//     Future<void> onAcceptApplication(String applicationId) async {
//       showLoadingIndicator(context);
//       try {
//         final result = await _dataSource.acceptApplication(applicationId);

//         result.fold(
//           // Handle failure
//           (error) {
//             debugPrint('Error accepting application: $error');
//             LegworkSnackbar(
//               title: 'Oops!',
//               subTitle: 'Failed to accept application: $error',
//               imageColor: Theme.of(context).colorScheme.error,
//               contentColor: Theme.of(context).colorScheme.onError,
//             ).show(context);
//             return Left(error);
//           },

//           // Handle success
//           (_) {
//             Navigator.pop(context);
//             LegworkSnackbar(
//               title: 'Nice!',
//               subTitle: "You've accepted this job application",
//               imageColor: Theme.of(context).colorScheme.surface,
//               contentColor: Theme.of(context).colorScheme.primary,
//             ).show(context);
//             debugPrint('You have accepted this application');
//             return const Right(null);
//           },
//         );
//       } catch (e) {
//         debugPrint('An unknown error occured accpeting job application');
//         return;
//       }
//     }

//     Future<void> onRejectApplication(String applicationId) async {
//       showLoadingIndicator(context);
//       try {
//         final result = await _dataSource.rejectApplication(applicationId);

//         result.fold(
//           // handle fail
//           (error) {
//             debugPrint('Error rejecting application: $error');
//             LegworkSnackbar(
//               title: 'Oops!',
//               subTitle: 'Failed to reject application: $error',
//               imageColor: Theme.of(context).colorScheme.error,
//               contentColor: Theme.of(context).colorScheme.onError,
//             ).show(context);
//             return Left(error);
//           },

//           // handle success
//           (_) {
//             Navigator.pop(context);
//             LegworkSnackbar(
//               title: 'Nice!',
//               subTitle:
//                   "You've rejected this job application. Too bad for the dancer",
//               imageColor: Theme.of(context).colorScheme.surface,
//               contentColor: Theme.of(context).colorScheme.primary,
//             ).show(context);
//             debugPrint('You have accepted this application');
//             return const Right(null);
//           },
//         );
//       } catch (e) {
//         debugPrint('An unknown error occured while rejecting application');
//         return;
//       }
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(isLoadin
//             ? 'Loading...'
//             : 'Application from ${dancerUserName ?? 'Unknown'}'),
//       ),
//       body: Consumer<JobApplicationProvider>(
//         builder: (context, provider, child) {
//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("Proposal:",
//                     style: Theme.of(context).textTheme.titleMedium),
//                 const SizedBox(height: 8),
//                 Text(proposal),
//                 const SizedBox(height: 20),
//                 Text("Status: $status"),
//                 const SizedBox(height: 30),
//                 Row(
//                   children: [
//                     ElevatedButton(
//                       onPressed: () => onAcceptApplication(applicationId),
//                       child: const Text("Accept"),
//                     ),
//                     const SizedBox(width: 10),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                       ),
//                       onPressed: () => onRejectApplication(applicationId),
//                       child: const Text("Reject"),
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:legwork/Features/auth/presentation/Widgets/auth_loading_indicator.dart';
import 'package:legwork/Features/job_application/data/data_sources/job_application_remote_data_source.dart';
import 'package:legwork/Features/job_application/data/models/job_application_model.dart';
import 'package:legwork/Features/job_application/presentation/provider/job_application_provider.dart';
import 'package:legwork/Features/job_application/presentation/widgets/status_tag.dart';
import 'package:legwork/core/widgets/legwork_snackbar.dart';
import 'package:provider/provider.dart';

class JobApplicationDetailScreen extends StatefulWidget {
  const JobApplicationDetailScreen({super.key});

  @override
  State<JobApplicationDetailScreen> createState() =>
      _JobApplicationDetailScreenState();
}

class _JobApplicationDetailScreenState
    extends State<JobApplicationDetailScreen> {
  final JobApplicationRemoteDataSource _dataSource =
      JobApplicationRemoteDataSource();

  String? dancerUserName;
  String? dancerProfileImage;
  bool isLoading = true;

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
    result.fold(
      (fail) {
        debugPrint('Failed to fetch dancer: $fail');
        setState(() {
          isLoading = false;
        });
      },
      (data) {
        setState(() {
          debugPrint('Dancers details data: ${data.toString()}');
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

    Future<void> onAcceptApplication(String applicationId) async {
      showLoadingIndicator(context);
      try {
        final result = await _dataSource.acceptApplication(applicationId);

        result.fold(
          (error) {
            Navigator.pop(context); // Close loading indicator
            LegworkSnackbar(
              title: 'Oops!',
              subTitle: 'Failed to accept application: $error',
              imageColor: Theme.of(context).colorScheme.error,
              contentColor: Theme.of(context).colorScheme.onError,
            ).show(context);
            return Left(error);
          },
          (_) {
            Navigator.pop(context); // Close loading indicator
            LegworkSnackbar(
              title: 'Success!',
              subTitle: "You've accepted this dancer's application",
              imageColor: colorScheme.onPrimary,
              contentColor: colorScheme.primary,
            ).show(context);

            // Update the UI with new status
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
                  Card(
                    color: colorScheme.surfaceContainer,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          //* Profile image or placeholder
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.grey[200],
                            backgroundImage: dancerProfileImage != null
                                ? NetworkImage(dancerProfileImage!)
                                : const AssetImage(
                                    'images/depictions/dancer_dummy_default_profile_picture.jpg',
                                  ),
                            // child: dancerProfileImage == null
                            //     ? const Icon(
                            //         Icons.person,
                            //         size: 32,
                            //         color: Colors.grey,
                            //       )
                            //     : null,
                          ),
                          const SizedBox(width: 16),

                          // * username and status tag
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dancerUserName ?? 'Unknown Dancer',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              StatusTag(status: status),
                            ],
                          ),
                        ],
                      ),
                    ),
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
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    icon: const Icon(Icons.check),
                                    label: const Text("Accept"),
                                    onPressed: () =>
                                        onAcceptApplication(applicationId),
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.green,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    icon: const Icon(Icons.close),
                                    label: const Text("Reject"),
                                    onPressed: () =>
                                        onRejectApplication(applicationId),
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.red,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Center(
                          child: Card(
                            color: statusColor.withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
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
                        ),
                ],
              ),
            ),
    );
  }
}
