import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:legwork/features/job_application/presentation/widgets/legwork_outline_button.dart';

class LegworkJobContainer extends StatelessWidget {
  final void Function()? onJobTap;
  final String jobTitle;
  final String pay;
  final String jobDescr;
  final String amtOfDancers;
  final String jobDuration;
  final String jobLocation;
  final String jobType;
  final DateTime createdAt;

  const LegworkJobContainer({
    super.key,
    required this.onJobTap,
    required this.jobTitle,
    required this.pay,
    required this.jobDescr,
    required this.amtOfDancers,
    required this.jobDuration,
    required this.jobLocation,
    required this.jobType,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    // Format the created date
    String formattedDate = DateFormat('MMM dd, yyyy • h:mma').format(createdAt);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // * HEADER SECTION WITH GRADIENT BACKGROUND
            InkWell(
              onTap: onJobTap,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primary.withOpacity(0.7),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date posted + Job type
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Posted date with icon
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/svg/calendar.svg',
                              color: colorScheme.onPrimary.withOpacity(0.9),
                              height: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              formattedDate,
                              style: TextStyle(
                                fontSize: 10,
                                color: colorScheme.onPrimary.withOpacity(0.9),
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),

                        // Job type tag
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.onPrimary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            jobType,
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Job title
                    Text(
                      jobTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimary,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Pay + location section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Pay with icon
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/svg/naira_icon.svg',
                              color: colorScheme.onPrimary.withOpacity(0.8),
                              height: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              pay,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: colorScheme.onPrimary,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),

                        // Location with icon
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SvgPicture.asset(
                              'assets/svg/location.svg',
                              color: colorScheme.onPrimary.withOpacity(0.8),
                              height: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              jobLocation,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: colorScheme.onPrimary,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // * CONTENCT SECTION
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Job description
                  Text(
                    jobDescr,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Job details grid
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/svg/user.svg',
                              color: colorScheme.onSurface,
                              height: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '$amtOfDancers dancers needed',
                              style: TextStyle(
                                fontSize: 14,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 16,
                              color: colorScheme.onSurface,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              jobDuration,
                              style: TextStyle(
                                fontSize: 14,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),

                  // View Details button
                  SizedBox(
                    width: double.infinity,
                    child: LegworkOutlineButton(
                      onPressed: onJobTap,
                      icon: SvgPicture.asset(
                        'assets/svg/briefcase.svg',
                        color: colorScheme.onSurface,
                        height: 20,
                      ),
                      buttonText: 'View Details',
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
