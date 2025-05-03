import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:legwork/features/auth/domain/Entities/user_entities.dart';
import 'package:legwork/features/home/presentation/widgets/job_preferences_card.dart';
import 'package:legwork/features/home/presentation/widgets/resume_detail_item.dart';

class ResumeSection extends StatelessWidget {
  final UserEntity user;

  const ResumeSection({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final checkUserPortfoliio = (user.isClient && user.hasHiringHistory) ||
        (user.isDancer && user.hasResume);

    final dancerWorkExp = user.asDancer?.resume?['workExperiences'];
    final clientHiringHistory =
        user.asClient?.hiringHistory?['hiringHistories'];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Descr icon + header text
            Row(
              children: [
                SvgPicture.asset(
                  'assets/svg/description_icon.svg',
                  color: colorScheme.secondary,
                ),
                const SizedBox(width: 8),
                Text(
                  user.isDancer ? 'Resume' : 'Hiring History',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),

            if (checkUserPortfoliio)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: user.isDancer
                    ? dancerWorkExp?.length
                    : clientHiringHistory.length,
                itemBuilder: (context, index) {
                  // * WORK EXPERIENCE/HIRING HISTORY CARD
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: colorScheme.outlineVariant,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Job title + date
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Job title
                              Text(
                                user.isDancer
                                    ? dancerWorkExp[index]['jobTitle']
                                            ?.toString() ??
                                        'N/A'
                                    : clientHiringHistory[index]['jobTitle']
                                            ?.toString() ??
                                        'N/A',
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              // Date
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  user.isDancer
                                      ? dancerWorkExp[index]['date']
                                              ?.toString() ??
                                          'N/A'
                                      : clientHiringHistory[index]['date']
                                              ?.toString() ??
                                          'N/A',
                                  style: textTheme.labelSmall?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: colorScheme.onPrimaryContainer,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Employer
                          ResumeDetailItem(
                            label: user.isDancer
                                ? 'Employer'
                                : 'Number of dancers hired',
                            value: user.isDancer
                                ? dancerWorkExp[index]['employer']
                                        ?.toString() ??
                                    'N/A'
                                : clientHiringHistory[index]['numOfDancers']
                                        ?.toString() ??
                                    'N/A',
                            svgIconPath: user.isDancer
                                ? 'assets/svg/briefcase.svg'
                                : 'assets/svg/hashtag_icon.svg',
                          ),
                          const SizedBox(height: 4),

                          // * IF LOGGED IN USER IS A CLIENT SHOW THIS
                          if (user.isClient)
                            ResumeDetailItem(
                              label: 'Payment Offered',
                              value: clientHiringHistory[index]
                                  ['paymentOffered'],
                              svgIconPath: 'assets/svg/naira_icon.svg',
                            ),

                          // Location
                          ResumeDetailItem(
                            label: 'location',
                            value: user.isDancer
                                ? dancerWorkExp[index]['location']
                                        ?.toString() ??
                                    'N/A'
                                : clientHiringHistory[index]['location']
                                        ?.toString() ??
                                    'N/A',
                            svgIconPath: 'assets/svg/location.svg',
                          ),
                          const SizedBox(height: 8),

                          // Job Description
                          Text(
                            'Description:',
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.isDancer
                                ? dancerWorkExp[index]['jobDescription']
                                        ?.toString() ??
                                    'N/A'
                                : clientHiringHistory[index]['jobDescription']
                                        ?.toString() ??
                                    'N/A',
                            style: textTheme.bodyMedium?.copyWith(
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.work_off,
                        size: 48,
                        color: colorScheme.onSurface.withOpacity(0.3),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No work experience added yet',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.7),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
