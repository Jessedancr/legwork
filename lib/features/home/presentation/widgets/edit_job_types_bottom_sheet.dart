import 'package:flutter/material.dart';
import 'package:legwork/core/Constants/helpers.dart';
import 'package:legwork/features/home/presentation/widgets/legwork_filled_icon_button.dart';

class EditJobTypesBottomSheet extends StatefulWidget {
  final List<String> availableJobTypes;
  final List selectedJobTypes;
  final dynamic editProfileScreen;
  final void Function()? onPressed;

  // Constructor
  const EditJobTypesBottomSheet({
    super.key,
    required this.availableJobTypes,
    required this.selectedJobTypes,
    required this.editProfileScreen,
    required this.onPressed,
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
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Job Types',
              style: context.textMd?.copyWith(
                color: context.colorScheme.primary,
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
                  selectedColor: context.colorScheme.primaryContainer,
                  checkmarkColor: context.colorScheme.primary,
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
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                  backgroundColor: context.colorScheme.error,
                ),
                // Check button
                LegworkFilledIconButton(
                  icon: const Icon(Icons.check),
                  onPressed: widget.onPressed,
                  backgroundColor: context.colorScheme.primary,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
