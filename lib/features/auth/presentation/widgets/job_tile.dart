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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
          borderRadius: BorderRadius.circular(30),
        ),
        width: double.infinity,
        height: 50,
        child: Row(
          children: [
            Checkbox(
              value: checkedValue,
              onChanged: onChanged,
              fillColor: WidgetStatePropertyAll(Colors.grey[400]),
              // activeColor: Theme.of(context).colorScheme.secondary,
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
