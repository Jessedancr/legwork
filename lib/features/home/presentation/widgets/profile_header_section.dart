import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:legwork/features/auth/domain/Entities/user_entities.dart';

class ProfileHeaderSection extends StatelessWidget {
  final UserEntity user;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final void Function()? onTap;
  final String defaultProfileImagePath;
  const ProfileHeaderSection({
    super.key,
    required this.user,
    required this.colorScheme,
    required this.textTheme,
    required this.onTap,
    required this.defaultProfileImagePath,
  });

  @override
  Widget build(BuildContext context) {
    final resume = (user is DancerEntity)
        ? (user as DancerEntity).resume
        : (user is ClientEntity)
            ? (user as ClientEntity).hiringHistory
            : null;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Profile Picture
              Hero(
                tag: 'profile_picture',
                child: GestureDetector(
                  onTap: onTap,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colorScheme.primary,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: colorScheme.primaryContainer,
                      backgroundImage: (user.profilePicture != null &&
                              user.profilePicture!.isNotEmpty)
                          ? NetworkImage(user.profilePicture!)
                          : AssetImage(
                              defaultProfileImagePath,
                            ) as ImageProvider,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Name + username + Professional title
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text(
                      '${user.firstName} ${user.lastName}',
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),

                    // Username
                    Text(
                      '@${user.username}',
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    // Professional title
                    Text(
                      resume!['professionalTitle'] ?? 'No professional title',
                      style: textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w300,
                        color: colorScheme.onPrimaryContainer,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.clip,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Contact info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Email icon + Email
              Row(
                children: [
                  // Email icon
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SvgPicture.asset(
                      'assets/svg/mail.svg',
                      color: colorScheme.onSecondaryContainer,
                      height: 12,
                    ),
                  ),
                  const SizedBox(width: 5),
                  // Actual email
                  Text(
                    user.email,
                    style: textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w200,
                      fontSize: 10.0,
                    ),
                  ),
                ],
              ),

              // Organisation name (for clients)
              if (user is ClientEntity)
                Row(
                  children: [
                    // Icon
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SvgPicture.asset(
                        'assets/svg/briefcase.svg',
                        color: colorScheme.onSecondaryContainer,
                        height: 12,
                      ),
                    ),
                    const SizedBox(width: 5),

                    // Actual organisation name
                    Text(
                      (user as ClientEntity).organisationName ?? '',
                      style: textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w200,
                        fontSize: 10.0,
                      ),
                    ),
                  ],
                ),

              // Phone icon + phone
              Row(
                children: [
                  // Email icon
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SvgPicture.asset(
                      'assets/svg/address_book.svg',
                      color: colorScheme.onSecondaryContainer,
                      height: 12,
                    ),
                  ),
                  const SizedBox(width: 5),
                  // Actual email
                  Text(
                    user.phoneNumber.toString(),
                    style: textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w200,
                      fontSize: 10.0,
                    ),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
