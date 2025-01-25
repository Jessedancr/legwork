import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'blur_effect.dart';

class HiringHistoryTile extends StatelessWidget {
  final String jobTitle;
  final String location;
  final String date;
  final String numOfDancersHired;
  final String paymentOffered;
  final String jobDescr;

  const HiringHistoryTile({
    super.key,
    required this.date,
    required this.jobDescr,
    required this.jobTitle,
    required this.location,
    required this.numOfDancersHired,
    required this.paymentOffered,
  });

  @override
  Widget build(BuildContext context) {
    // SCREEN SIZE
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // RETURNED WIDGET
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(35),
          border: Border.all(
            color: Theme.of(context).colorScheme.onSurface,
            width: 2.0,
          ),
          image: const DecorationImage(
            image: AssetImage(
              'images/logos/dance_icon_purple_cropped.png',
            ),
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
          ),
        ),
        child: BlurEffect(
          height: screenHeight * 0.25,
          width: screenWidth,
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.robotoSlab(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontSize: 16,
                    ),
                    children: [
                      // Job title
                      const TextSpan(
                        text: 'Job Title: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: ' $jobTitle \n'),
                      const TextSpan(text: ''),

                      // Location
                      const TextSpan(
                        text: 'Location: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: ' $location \n'),
                      const TextSpan(text: ''),

                      // Date
                      const TextSpan(
                        text: 'Date: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: ' $date \n'),
                      const TextSpan(text: ''),

                      // Number of dancers hired
                      const TextSpan(
                        text: 'Number of dancers hired: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: ' $numOfDancersHired \n'),
                      const TextSpan(text: ''),

                      // Payment offered
                      const TextSpan(
                        text: 'Payment offered: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: ' $paymentOffered \n'),
                      const TextSpan(text: ''),

                      // Job Description
                      const TextSpan(
                        text: 'Job Description: ',
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
    );
  }
}
