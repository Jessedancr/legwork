import 'package:flutter/material.dart';
import 'package:legwork/core/Constants/helpers.dart';

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
      color: context.colorScheme.surfaceContainer,
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
              backgroundColor: context.colorScheme.surface,
              child: ClipOval(
                child:
                    dancerProfileImage != null && dancerProfileImage!.isNotEmpty
                        ? Image.network(
                            dancerProfileImage!,
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
            const SizedBox(width: 16),

            // * username and status tag
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dancerUserName ?? 'Unknown Dancer',
                  style: context.textMd?.copyWith(
                    fontWeight: FontWeight.w500,
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
