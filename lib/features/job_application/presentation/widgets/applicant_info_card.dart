import 'package:flutter/material.dart';
import 'package:legwork/core/Constants/helpers.dart';
import 'package:legwork/features/auth/domain/Entities/user_entities.dart';
import 'package:legwork/features/home/presentation/widgets/user_circle_avatar.dart';

import 'status_tag.dart';

class ApplicantInfoCard extends StatelessWidget {
  final String status;
  final UserEntity dancerDetails;
  const ApplicantInfoCard({
    super.key,
    required this.status,
    required this.dancerDetails,
  });

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
            UserCircleAvatar(
              user: dancerDetails,
              defaultProfileImagePath: defaultDancerProfileImage,
              radius: 30,
            ),
            const SizedBox(width: 16),

            // * username and status tag
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dancerDetails.username,
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
