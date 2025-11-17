import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:legwork/core/Constants/helpers.dart';
import 'package:legwork/features/auth/presentation/widgets/legwork_elevated_button.dart';

class NotifTile extends StatelessWidget {
  final String svgIconPath;
  final String notifTitle;
  final void Function()? onDeleteNotif;
  final void Function()? onButtonPressed;
  final String buttonText;
  final String notifBody;
  const NotifTile({
    super.key,
    required this.svgIconPath,
    required this.notifTitle,
    required this.onDeleteNotif,
    required this.onButtonPressed,
    required this.buttonText,
    required this.notifBody,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: context.colorScheme.onSurface.withOpacity(0.4),
          ),
        ),
      ),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // * NOTIFICATION ICON AND TITLE
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    svgIconPath,
                    color: context.colorScheme.onSurface,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    notifTitle,
                    style:
                        context.textXl?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              GestureDetector(
                onTap: onDeleteNotif,
                child: const Icon(Icons.close),
              )
            ],
          ),

          // * NOTIFICATION BODY
          Padding(
            padding: const EdgeInsets.only(left: 32.0),
            child: Text(
              notifBody,
              style: context.textSm,
            ),
          ),
          const SizedBox(height: 20),

          // * CTA BUTTON
          LegworkElevatedButton(
            onPressed: onButtonPressed,
            buttonText: buttonText,
            maximumSize: Size(screenWidth(context) * 0.4, 70),
          ),
        ],
      ),
    );
  }
}
