import 'package:flutter/material.dart';
import 'package:legwork/core/Constants/helpers.dart';
import 'package:legwork/features/auth/domain/Entities/user_entities.dart';
import 'package:legwork/features/auth/presentation/widgets/legwork_elevated_button.dart';
import 'package:legwork/features/job_application/presentation/provider/job_application_provider.dart';
import 'package:legwork/features/job_application/presentation/widgets/applicant_card.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';

class JobApplicantsList extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final UserEntity dancerDetails;
  final void Function()? onCloseJob;
  final bool isLoading;
  const JobApplicantsList({
    super.key,
    required this.onRefresh,
    required this.dancerDetails,
    required this.onCloseJob,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final jobProvider =
        Provider.of<JobApplicationProvider>(context, listen: false);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        LiquidPullToRefresh(
          onRefresh: onRefresh,
          color: context.colorScheme.primary,
          backgroundColor: context.colorScheme.surface,
          animSpeedFactor: 3.0,
          showChildOpacityTransition: false,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: jobProvider.allApplications.length,
            itemBuilder: (context, index) {
              final jobApplication = jobProvider.allApplications[index];

              return ApplicantCard(
                jobApplication: jobApplication,
                dancerEntity: dancerDetails,
              );
            },
          ),
        ),
        LegworkElevatedButton(
          onPressed: onCloseJob,
          buttonText: 'Close this job?',
          isLoading: isLoading,
        )
      ],
    );
  }
}
