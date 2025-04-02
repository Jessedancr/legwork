import 'package:flutter/material.dart';

import 'status_tag.dart';

class ApplicantCard extends StatelessWidget {
  final dynamic app; // Your application model type
  final Map<String, dynamic> dancer;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const ApplicantCard({
    super.key,
    required this.app,
    required this.dancer,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    // Inside ApplicantCard's build method:
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final dancerImage = dancer['profileImage'];
    final dancerUserName = dancer['username'] ?? 'Loading...';
    final dancerEmail = dancer['email'] ?? 'example@gmail.com';
    final dancerPhoneNum = dancer['phoneNumber'] ?? '1234567890';
    final applicationStatus = app.applicationStatus;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/job_application_detail',
            arguments: app,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
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
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // * PROFILE PICTURE
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: colorScheme.surfaceContainer,
                      backgroundImage: dancerImage != null
                          ? NetworkImage(dancerImage)
                          : const AssetImage(
                              'images/depictions/dancer_dummy_default_profile_picture.jpg',
                            ) as ImageProvider,
                    ),
                    const SizedBox(width: 12),

                    // * STATUS TAG AND USERNAME
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dancerUserName,
                          style: textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 2),
                        StatusTag(
                          status: applicationStatus,
                        ),
                      ],
                    ),

                    // * ARROW ICON
                    // const Icon(
                    //   Icons.arrow_forward_ios,
                    //   size: 16,
                    //   color: Color(0xFFBDBDBD),
                    // ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  "Proposal",
                  style: textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  app.proposal.length > 20
                      ? "${app.proposal.substring(0, 20)}..."
                      : app.proposal,
                  style: textTheme.bodyMedium?.copyWith(),
                ),
                const SizedBox(height: 8),

                // * CONTACT DETAILS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'email: $dancerEmail',
                      style: textTheme.labelSmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        fontSize: 8,
                      ),
                    ),
                    Text(
                      'Phone number: +234 $dancerPhoneNum',
                      style: textTheme.labelSmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        fontSize: 8,
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
