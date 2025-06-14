import 'package:flutter/material.dart';
import 'package:legwork/core/Constants/helpers.dart';
import 'package:legwork/features/auth/presentation/Widgets/legwork_snackbar_content.dart';

class LegworkSnackbar extends StatelessWidget {
  final String title;
  final String subTitle;
  final Color contentColor;
  final Color imageColor;

  const LegworkSnackbar({
    super.key,
    required this.title,
    required this.subTitle,
    required this.imageColor,
    required this.contentColor,
  });

  void show(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 5),
        content: LegWorkSnackBarContent(
          screenHeight: screenHeight(context),
          context: context,
          screenWidth: screenWidth(context),
          title: title,
          subTitle: subTitle,
          contentColor: contentColor,
          imageColor: imageColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
