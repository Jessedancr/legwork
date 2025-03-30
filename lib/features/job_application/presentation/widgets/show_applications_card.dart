import 'package:flutter/material.dart';
import 'package:legwork/Features/home/domain/entities/job_entity.dart';
import 'package:legwork/Features/job_application/domain/entities/job_application_entity.dart';

class ShowApplicationsCard extends StatelessWidget {
  final JobEntity job;
  final String formattedCreatedAt;
  final JobApplicationEntity application;
  final Color statusTagBorderColor;
  final Color iconColor;
  final Color statusTextColor;
  final IconData icon;

  // Constructor
  const ShowApplicationsCard({
    super.key,
    required this.job,
    required this.formattedCreatedAt,
    required this.application,
    required this.statusTagBorderColor,
    required this.iconColor,
    required this.statusTextColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Colors.grey[100],
      child: ListTile(
        title: Text(
          job.jobTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Applied on: $formattedCreatedAt',
              style: const TextStyle(
                fontWeight: FontWeight.w200,
                fontSize: 14,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  // color: Colors.teal,
                  border: Border.all(
                    color: statusTagBorderColor,
                    // width: 2.0,
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    icon,
                    size: 14,
                    color: iconColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    application.applicationStatus,
                    style: TextStyle(
                      color: statusTextColor,
                      fontWeight: FontWeight.w200,
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
