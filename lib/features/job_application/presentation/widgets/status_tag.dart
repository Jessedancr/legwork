import 'package:flutter/material.dart';

class StatusTag extends StatelessWidget {
  final String status;

  const StatusTag({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chipData = _getTagData(status, theme);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: chipData.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: chipData.borderColor,
          // width: 2.0,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            chipData.icon,
            size: 14,
            color: chipData.iconColor,
          ),
          const SizedBox(width: 8),
          Text(
            chipData.label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: chipData.textColor,
            ),
          ),
        ],
      ),
    );
  }

  _TagData _getTagData(String status, ThemeData theme) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return _TagData(
          backgroundColor: const Color(0xFFE6F4EA),
          textColor: const Color(0xFF34A853),
          iconColor: const Color(0xFF34A853),
          borderColor: const Color(0xFF34A853),
          icon: Icons.check_circle,
          label: "Accepted",
        );
      case 'rejected':
        return _TagData(
          backgroundColor: const Color(0xFFFCE8E6),
          textColor: const Color(0xFFEA4335),
          iconColor: const Color(0xFFEA4335),
          borderColor: const Color(0xFFEA4335),
          icon: Icons.cancel,
          label: "Rejected",
        );
      case 'pending':
      default:
        return _TagData(
          backgroundColor: const Color(0xFFFEF7E0),
          textColor: const Color(0xFFFBBC04),
          iconColor: const Color(0xFFFBBC04),
          borderColor: const Color(0xFFFBBC04),
          icon: Icons.access_time,
          label: "Pending",
        );
    }
  }
}

// Tag data class containing all data of the status tag
class _TagData {
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final IconData icon;
  final String label;
  final Color borderColor;

  _TagData({
    required this.backgroundColor,
    required this.textColor,
    required this.iconColor,
    required this.icon,
    required this.label,
    required this.borderColor,
  });
}
