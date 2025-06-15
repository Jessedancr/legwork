import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:legwork/core/Constants/helpers.dart';
import 'package:legwork/features/auth/domain/Entities/user_entities.dart';

import 'legwork_list_tile.dart';

class ClientsDrawer extends StatefulWidget {
  const ClientsDrawer({super.key});

  @override
  State<ClientsDrawer> createState() => _ClientsDrawerState();
}

class _ClientsDrawerState extends State<ClientsDrawer> {
  UserEntity user = UserEntity(
    username: '',
    email: '',
    password: '',
    firstName: '',
    lastName: '',
    phoneNumber: '',
    userType: '',
    deviceToken: '',
  );

  @override
  Widget build(BuildContext context) {
    // RETRUNED UI
    return Drawer(
      backgroundColor: context.colorScheme.surface,
      width: screenWidth(context) * 0.6,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight(context) * 0.05),

            // Client's profile picture
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: context.colorScheme.primary,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: context.colorScheme.primary.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: context.colorScheme.primaryContainer,
                backgroundImage: (user.profilePicture != null &&
                        user.profilePicture!.isNotEmpty)
                    ? NetworkImage(user.profilePicture!)
                    : const AssetImage(defaultClientProfileImage)
                        as ImageProvider,
              ),
            ),
            const SizedBox(height: 10),
            Divider(
              color: Theme.of(context).colorScheme.outline,
              thickness: 1.5,
            ),
            SizedBox(height: screenHeight(context) * 0.05),

            /// DRAWER TILES
            // Alerts/notifications
            LegworkListTile(
              leading: SvgPicture.asset(
                'assets/svg/notfications.svg',
                fit: BoxFit.scaleDown,
                color: context.colorScheme.surface,
              ),
              title: Text(
                'Notifications',
                style: context.textLg?.copyWith(
                  color: context.colorScheme.surface,
                ),
              ),
              onTap: () {},
            ),
            const SizedBox(height: 10),

            // Settings
            LegworkListTile(
              leading: SvgPicture.asset(
                'assets/svg/settings.svg',
                fit: BoxFit.scaleDown,
                color: context.colorScheme.surface,
              ),
              title: Text(
                'settings',
                style: context.textLg?.copyWith(
                  color: context.colorScheme.surface,
                ),
              ),
              onTap: () {
                // pop drawer menu
                Navigator.of(context).pop();
                // navigate to settings page
                Navigator.of(context).pushNamed('/clientSettingsScreen');
              },
            ),
          ],
        ),
      ),
    );
  }
}
