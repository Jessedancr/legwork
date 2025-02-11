import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:legwork/Features/auth/presentation/Widgets/blur_effect.dart';

class WorkExperienceTile extends StatelessWidget {
  final String jobTitle;
  final String employer;
  final String location;
  final String jobDescr;
  final String date;
  const WorkExperienceTile({
    super.key,
    required this.jobTitle,
    required this.employer,
    required this.jobDescr,
    required this.location,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    // SCREEN SIZE
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // RETURNED WIDGET
    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35),
            border: Border.all(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              width: 3.0,
            ),
            image: const DecorationImage(
              image: AssetImage(
                'images/logos/nobg_dance_icon.png',
              ),
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
            ),
          ),
          child: BlurEffect(
            sigmaX: 3.5,
            sigmaY: 3.5,
            firstGradientColor: Colors.black.withOpacity(0.9),
            secondGradientColor: Colors.black.withOpacity(0.7),
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            height: null,
            width: screenWidth,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.robotoSlab(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 16,
                        letterSpacing: 1.5,
                      ),
                      children: [
                        // Job title
                        const TextSpan(
                          text: '- Job Title: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: ' $jobTitle \n'),
                        const TextSpan(text: ''),

                        // Employer
                        const TextSpan(
                          text: '- Employer: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: ' $employer \n'),
                        const TextSpan(text: ''),

                        // Location
                        const TextSpan(
                          text: '- Location: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: ' $location \n'),
                        const TextSpan(text: ''),

                        // Date
                        const TextSpan(
                          text: '- Date: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: ' $date \n'),
                        const TextSpan(text: ''),

                        // Job Description
                        const TextSpan(
                          text: '- Job Description: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: ' $jobDescr \n'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
