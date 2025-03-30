import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:legwork/Features/auth/presentation/Widgets/auth_loading_indicator.dart';
import 'package:legwork/Features/job_application/data/data_sources/job_application_remote_data_source.dart';
import 'package:legwork/Features/job_application/data/models/job_application_model.dart';
import 'package:legwork/core/widgets/legwork_snackbar.dart';

class JobApplicationDetailScreen extends StatefulWidget {
  const JobApplicationDetailScreen({super.key});

  @override
  State<JobApplicationDetailScreen> createState() =>
      _JobApplicationDetailScreenState();
}

class _JobApplicationDetailScreenState
    extends State<JobApplicationDetailScreen> {
  // Instance of remote datasource (backend)
  final JobApplicationRemoteDataSource _dataSource =
      JobApplicationRemoteDataSource();

  @override
  Widget build(BuildContext context) {
    final JobApplicationModel app =
        ModalRoute.of(context)!.settings.arguments as JobApplicationModel;

    final String dancerId = app.dancerId;
    final String proposal = app.proposal;
    final String status = app.applicationStatus;
    final String applicationId = app.applicationId;

    Future<void> onAcceptApplication(String applicationId) async {
      showLoadingIndicator(context);
      try {
        final result = await _dataSource.acceptApplication(applicationId);

        result.fold(
          // Handle failure
          (error) {
            debugPrint('Error accepting application: $error');
            LegworkSnackbar(
              title: 'Oops!',
              subTitle: 'Failed to accept application: $error',
              imageColor: Theme.of(context).colorScheme.error,
              contentColor: Theme.of(context).colorScheme.onError,
            ).show(context);
            return Left(error);
          },

          // Handle success
          (_) {
            Navigator.pop(context);
            LegworkSnackbar(
              title: 'Nice!',
              subTitle: "You've accepted this job application",
              imageColor: Theme.of(context).colorScheme.surface,
              contentColor: Theme.of(context).colorScheme.primary,
            ).show(context);
            debugPrint('You have accepted this application');
            return const Right(null);
          },
        );
      } catch (e) {
        debugPrint('An unknown error occured accpeting job application');
        return;
      }
    }

    Future<void> onRejectApplication(String applicationId) async {
      showLoadingIndicator(context);
      try {
        final result = await _dataSource.rejectApplication(applicationId);

        result.fold(
          // handle fail
          (error) {
            debugPrint('Error rejecting application: $error');
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
            Navigator.pop(context);
            LegworkSnackbar(
              title: 'Nice!',
              subTitle:
                  "You've rejected this job application. Too bad for the dancer",
              imageColor: Theme.of(context).colorScheme.surface,
              contentColor: Theme.of(context).colorScheme.primary,
            ).show(context);
            debugPrint('You have accepted this application');
            return const Right(null);
          },
        );
      } catch (e) {
        debugPrint('An unknown error occured while rejecting application');
        return;
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text('Application from $dancerId')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Proposal:", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(proposal),
            const SizedBox(height: 20),
            Text("Status: $status"),
            const SizedBox(height: 30),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => onAcceptApplication(applicationId),
                  child: const Text("Accept"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () => onRejectApplication(applicationId),
                  child: const Text("Reject"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
