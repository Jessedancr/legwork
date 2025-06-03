import 'package:flutter/material.dart';
import 'package:legwork/core/Constants/helpers.dart';
import 'package:legwork/features/auth/domain/Entities/user_entities.dart';
import 'package:legwork/features/job_application/domain/entities/job_application_entity.dart';

import 'status_tag.dart';

class ApplicantCard extends StatelessWidget {
  final JobApplicationEntity jobApplication;
  final UserEntity dancerEntity;

  const ApplicantCard({
    super.key,
    required this.jobApplication,
    required this.dancerEntity,
  });

  @override
  Widget build(BuildContext context) {
    final dancerImage = dancerEntity.profilePicture;
    final dancerUserName = dancerEntity.username;
    final dancerEmail = dancerEntity.email;
    final dancerPhoneNum = dancerEntity.phoneNumber;
    final applicationStatus = jobApplication.applicationStatus;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/job_application_detail',
            arguments: jobApplication,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: context.colorScheme.onSurface.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // * PROFILE PICTURE
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: context.colorScheme.surfaceContainer,
                          child: ClipOval(
                            child:
                                dancerImage != null && dancerImage!.isNotEmpty
                                    ? Image.network(
                                        dancerImage!,
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        'images/depictions/dancer_dummy_default_profile_picture.jpg',
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // * STATUS TAG AND USERNAME
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dancerUserName,
                              style: context.textMd?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            StatusTag(
                              status: applicationStatus,
                            ),
                          ],
                        ),
                      ],
                    ),

                    // * ARROW ICON
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Color(0xFFBDBDBD),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  "Proposal",
                  style: context.textMd?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  jobApplication.proposal.length > 20
                      ? "${jobApplication.proposal.substring(0, 20)}..."
                      : jobApplication.proposal,
                  style: context.textXl?.copyWith(),
                ),
                const SizedBox(height: 8),

                // * CONTACT DETAILS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'email: $dancerEmail',
                      style: context.text2Xs?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Text(
                      'Phone number: +234 $dancerPhoneNum',
                      style: context.text2Xs?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
