import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:legwork/features/auth/domain/Entities/user_entities.dart';

class BioCard extends StatelessWidget {
  final UserEntity user;
  const BioCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final hasBio = user.bio != null && user.bio!.isNotEmpty;

    return Card(
      color: colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User icon + 'bio' text
            Row(
              children: [
                SvgPicture.asset(
                  'assets/svg/user.svg',
                ),
                const SizedBox(width: 8),
                Text(
                  'Bio',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Text(
              hasBio ? user.bio! : 'N/A',
              style: textTheme.bodyMedium?.copyWith(
                height: 1.5,
                color: hasBio
                    ? colorScheme.onSurface
                    : colorScheme.onSurface.withOpacity(0.5),
                fontStyle: hasBio ? FontStyle.normal : FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
