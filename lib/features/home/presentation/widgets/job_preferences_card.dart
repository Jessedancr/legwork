import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:legwork/features/auth/domain/Entities/user_entities.dart';

// UITILITY CLASS ON USER ENTITY
extension UserEntityUtils on UserEntity {
  // This returns true is user is dancer
  bool get isDancer => this is DancerEntity;

  // Returns true if user is client
  bool get isClient => this is ClientEntity;

  // This returns user as DancerEntity if user is a dancer
  DancerEntity? get asDancer => isDancer ? this as DancerEntity : null;

  // This returns user as ClientEntity if user is a client
  ClientEntity? get asClient => isClient ? this as ClientEntity : null;

  // Returns true if the user is a dancer, if dance styles is a list and if it is not empty
  bool get hasDanceStyles =>
      asDancer?.jobPrefs!['danceStyles'] is List &&
      (asDancer?.jobPrefs!['danceStyles'] as List).isNotEmpty;

  // Returns true if user is a dancer, if job types is a list and if it is not empty
  bool get hasJobTypes =>
      asDancer?.jobPrefs!['jobTypes'] is List &&
      (asDancer?.jobPrefs!['jobTypes'] as List).isNotEmpty;

  // Returns true if user is a dancer, if job locations is a list and if it is not empty
  bool get hasJobLocations =>
      asDancer?.jobPrefs!['jobLocations'] is List &&
      (asDancer?.jobPrefs!['jobLocations'] as List).isNotEmpty;

  // Returns true if the user is dancer, if resume is a Map and if it is not empty
  bool get hasResume =>
      asDancer?.resume is Map && (asDancer?.resume as Map).isNotEmpty;

/**
 * DO SAME FOR CLIENT
 */

// Returns true if the user is a client, if dance style prefs is a list and if it is not empty
  bool get hasDanceStylePrefs =>
      asClient?.danceStylePrefs is List &&
      (asClient?.danceStylePrefs as List).isNotEmpty;

  // Returns true if user is a client, if job offerings is a list and if it is not empty
  bool get hasJobOfferings =>
      asClient?.jobOfferings is List &&
      (asClient?.jobOfferings as List).isNotEmpty;

  // This return true if user is a client, if hiriing history is map and if it is not empty
  bool get hasHiringHistory =>
      asClient?.hiringHistory is Map &&
      (asClient?.hiringHistory as Map).isNotEmpty;
}

class JobPreferencesCard extends StatelessWidget {
  final UserEntity user;
  const JobPreferencesCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // * RETURNED WIDGET
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon + section descr text
            Row(
              children: [
                SvgPicture.asset(
                  'assets/svg/info.svg',
                ),
                const SizedBox(width: 8),
                Text(
                  'Job Preferences',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),

            // Dance Styles
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              childrenPadding: const EdgeInsets.only(bottom: 16),
              title: Row(
                children: [
                  SvgPicture.asset(
                    'assets/svg/disco_ball.svg',
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Dance Styles',
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              children: [
                if (user.hasDanceStyles || user.hasDanceStylePrefs)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        (user.asDancer?.jobPrefs?['danceStyles'] as List? ??
                                user.asClient?.danceStylePrefs ??
                                [])
                            .map(
                              (style) => Chip(
                                backgroundColor: colorScheme.primaryContainer,
                                label: Text(
                                  style.toString(),
                                  style: textTheme.labelSmall?.copyWith(
                                    color: colorScheme.onPrimaryContainer,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  )
                else
                  Text(
                    'No dance styles specified',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.7),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),

            // Job Types
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              childrenPadding: const EdgeInsets.only(bottom: 16),
              title: Row(
                children: [
                  SvgPicture.asset(
                    'assets/svg/briefcase.svg',
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Job Types',
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              children: [
                if (user.hasJobTypes || user.hasJobOfferings)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (user.asDancer?.jobPrefs?['jobTypes'] as List? ??
                            user.asClient?.jobOfferings ??
                            [])
                        .map((type) => Chip(
                              backgroundColor: colorScheme.secondaryContainer,
                              label: Text(
                                type.toString(),
                                style: textTheme.labelSmall?.copyWith(
                                  color: colorScheme.onPrimaryContainer,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ))
                        .toList(),
                  )
                else
                  Text(
                    'No job types specified',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.7),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),

            // Job Locations
            if (user == user.asDancer)
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                childrenPadding: const EdgeInsets.only(bottom: 8),
                title: Row(
                  children: [
                    SvgPicture.asset('assets/svg/location.svg'),
                    const SizedBox(width: 8),
                    Text(
                      'Preferred Job Locations',
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                children: [
                  if (user.hasJobLocations)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: (user.asDancer!.jobPrefs!['jobLocations']
                              as List)
                          .map((location) => Chip(
                                backgroundColor: colorScheme.tertiaryContainer,
                                label: Text(
                                  location.toString(),
                                  style: textTheme.labelSmall?.copyWith(
                                    color: colorScheme.onTertiaryContainer,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ))
                          .toList(),
                    )
                  else
                    Text(
                      'No job locations specified',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.7),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
