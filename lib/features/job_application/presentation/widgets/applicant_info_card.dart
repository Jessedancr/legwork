import 'package:flutter/material.dart';

import 'status_tag.dart';

class ApplicantInfoCard extends StatelessWidget {
  const ApplicantInfoCard({
    super.key,
    required this.colorScheme,
    required this.dancerProfileImage,
    required this.dancerUserName,
    required this.status,
  });

  final ColorScheme colorScheme;
  final String? dancerProfileImage;
  final String? dancerUserName;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Card(
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
    );
  }
}
