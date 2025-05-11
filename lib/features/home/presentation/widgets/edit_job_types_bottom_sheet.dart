import 'package:flutter/material.dart';
import 'package:legwork/features/home/presentation/screens/dancer_screens/edit_profile_screen.dart';
import 'package:legwork/features/home/presentation/widgets/legwork_filled_icon_button.dart';

class EditJobTypesBottomSheet extends StatefulWidget {
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final List<String> availableJobTypes;
  final List selectedJobTypes;
  final EditProfileScreen widget;

  // Constructor
  const EditJobTypesBottomSheet({
    super.key,
    required this.colorScheme,
    required this.textTheme,
    required this.availableJobTypes,
    required this.selectedJobTypes,
    required this.widget,
  });

  @override
  State<EditJobTypesBottomSheet> createState() =>
      _EditJobTypesBottomSheetState();
}

class _EditJobTypesBottomSheetState extends State<EditJobTypesBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: widget.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Job Types',
              style: widget.textTheme.titleMedium?.copyWith(
                color: widget.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // JOB TYPES CHIPS
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.availableJobTypes.map((type) {
                final isSelectedd = widget.selectedJobTypes.contains(type);

                return FilterChip(
                  label: Text(type),
                  selected: isSelectedd,
                  selectedColor: widget.colorScheme.primaryContainer,
                  checkmarkColor: widget.colorScheme.primary,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        widget.selectedJobTypes.add(type);
                      } else {
                        widget.selectedJobTypes.remove(type);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // CLose button
                LegworkFilledIconButton(
                  colorScheme: widget.colorScheme,
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                  backgroundColor: widget.colorScheme.error,
                ),
                // Check button
                LegworkFilledIconButton(
                  colorScheme: widget.colorScheme,
                  icon: const Icon(Icons.check),
                  onPressed: () {
                    widget.widget.dancerDetails!.jobPrefs?['jobTypes'] =
                        widget.selectedJobTypes;
                    Navigator.of(context).pop();
                  },
                  backgroundColor: widget.colorScheme.primary,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
