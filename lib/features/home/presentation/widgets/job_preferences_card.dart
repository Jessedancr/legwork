import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:legwork/core/Constants/helpers.dart';
import 'package:legwork/features/auth/domain/Entities/user_entities.dart';

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
                  color: context.colorScheme.onSurface,
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
                    color: context.colorScheme.onSurface,
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
                    color: context.colorScheme.onSurface,
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
                    SvgPicture.asset(
                      'assets/svg/location.svg',
                      color: context.colorScheme.onSurface,
                    ),
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
