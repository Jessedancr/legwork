import 'package:flutter/material.dart';
import 'package:legwork/core/Constants/helpers.dart';
import 'package:legwork/features/home/domain/entities/job_entity.dart';
import 'package:legwork/features/job_application/domain/entities/job_application_entity.dart';
import 'package:legwork/features/job_application/presentation/widgets/status_tag.dart';

/**
 * THIS WIDGET IS USED TO SHOW ALL THE DANCER'S APPLICATIONS
 * WHETHER PENDING, ACCEPTED OR REJECTED
 * 
 */

class ShowApplicationsCard extends StatelessWidget {
  final JobEntity job;
  final String formattedCreatedAt;
  final JobApplicationEntity application;

  // Constructor
  const ShowApplicationsCard({
    super.key,
    required this.job,
    required this.formattedCreatedAt,
    required this.application,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: context.colorScheme.surfaceContainer,
      child: ListTile(
        title: Text(
          job.jobTitle,
          style: context.text2Xl?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Applied on: $formattedCreatedAt',
              style: context.textXs?.copyWith(
                fontWeight: FontWeight.w300,
              ),
            ),
            StatusTag(
              status: application.applicationStatus,
            ),
          ],
        ),
      ),
    );
  }
}
