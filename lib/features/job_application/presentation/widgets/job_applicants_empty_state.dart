import 'package:flutter/material.dart';
import 'package:legwork/core/Constants/helpers.dart';
import 'package:legwork/features/auth/presentation/widgets/legwork_elevated_button.dart';

class JobApplicantsEmptyState extends StatelessWidget {
  final void Function()? onPressed;
  final bool isLoading;
  final bool jobStatus;
  const JobApplicantsEmptyState({
    super.key,
    required this.onPressed,
    required this.isLoading,
    required this.jobStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            Column(
              children: [
                const Icon(
                  Icons.person_off_outlined,
                  size: 80,
                  color: Color(0xFFBDBDBD),
                ),
                const SizedBox(height: 24),
                Text(
                  "No applicants yet",
                  style: context.text2Xl?.copyWith(
                    color: context.colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "When dancers apply for this job, they'll appear here.",
              textAlign: TextAlign.center,
              style: context.textSm?.copyWith(
                color: context.colorScheme.onSurface,
              ),
            ),
            const Spacer(),
            if (jobStatus)
              LegworkElevatedButton(
                onPressed: onPressed,
                buttonText: 'Close this job?',
                isLoading: isLoading,
              ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
