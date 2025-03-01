import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:legwork/Features/auth/presentation/Widgets/legwork_elevated_button.dart';

class LegworkJobContainer extends StatelessWidget {
  final void Function()? onJobTap;
  final void Function()? onIconTap;
  final String jobTitle;
  final String pay;
  final String jobDescr;
  final String amtOfDancers;
  final String jobDuration;
  final String jobLocation;

  const LegworkJobContainer({
    super.key,
    required this.onJobTap,
    required this.onIconTap,
    required this.jobTitle,
    required this.pay,
    required this.jobDescr,
    required this.amtOfDancers,
    required this.jobDuration,
    required this.jobLocation,
  });

  @override
  Widget build(BuildContext context) {
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
                    splashFactory: InkSplash.splashFactory,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Time job was posted
                        Text(
                          'Posted yesterday',
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

              // Apply button (Fixed width)
              const SizedBox(width: 10),
              IconButton.filledTonal(
                color: Theme.of(context).colorScheme.primary,
                onPressed: onIconTap,
                icon: SvgPicture.asset(
                  'assets/svg/info.svg',
                  fit: BoxFit.scaleDown,
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
              'Music video feature',
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
