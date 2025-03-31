import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

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
    // Formatted createdAt
    String formattedCreatedAt =
        DateFormat('dd-MM-yyyy | hh:mma').format(createdAt);

    // Returned widget
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Job Details Column (Expanded to avoid overflow)
              Expanded(
                child: Ink(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: onJobTap,
                    splashColor: Theme.of(context).colorScheme.onPrimary,
                    splashFactory: InkRipple.splashFactory,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Time job was posted
                        Text(
                          'Posted: $formattedCreatedAt',
                          style: GoogleFonts.robotoCondensed(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.w300,
                          ),
                        ),

                        // Title of job (Ellipsis applied)
                        Text(
                          jobTitle,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          style: GoogleFonts.robotoSlab(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 18,
                            letterSpacing: 0.5,
                          ),
                        ),

                        // Job payment
                        Text(
                          'Pay: $pay',
                          style: GoogleFonts.robotoSlab(
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 16,
                            letterSpacing: 0.6,
                          ),
                        ),

                        // Job location
                        Text(
                          'Location: $jobLocation',
                          style: TextStyle(
                            fontFamily: 'RobotoSlab',
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 16,
                            letterSpacing: 0.6,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Job description (Truncated if needed)
          Text(
            jobDescr,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.robotoSlab(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 10),

          // Job details (Dancers needed & duration)
          Text(
            'Dancers needed: $amtOfDancers',
            style: GoogleFonts.robotoSlab(
              fontSize: 12,
              fontWeight: FontWeight.w300,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          Text(
            'Job duration: $jobDuration',
            style: GoogleFonts.robotoSlab(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 20),

          // Job type (Wrapped inside a Flexible container)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              jobType,
              style: GoogleFonts.robotoSlab(
                fontSize: 12,
                fontWeight: FontWeight.w300,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
            ),
          ),

          const SizedBox(height: 10),
          const Divider(indent: 20.0, endIndent: 20.0),
        ],
      ),
    );
  }
}
