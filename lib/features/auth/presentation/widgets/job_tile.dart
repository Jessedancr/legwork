import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JobTile extends StatelessWidget {
  final String job;
  final bool checkedValue;
  final void Function(bool?)? onChanged;
  const JobTile({
    super.key,
    required this.job,
    required this.checkedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    //SCREEN SIZE
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // RETURNED WIDGET
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
          borderRadius: BorderRadius.circular(30),
        ),
        width: double.infinity,
        height: screenHeight * 0.07,
        child: Row(
          children: [
            Checkbox(
              value: checkedValue,
              onChanged: onChanged,
              fillColor:
                  WidgetStatePropertyAll(Theme.of(context).colorScheme.surface),
              activeColor: Theme.of(context).colorScheme.primary,
              checkColor: Colors.black,
              shape: const CircleBorder(),
            ),
            Text(
              job,
              style: GoogleFonts.robotoSlab(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
