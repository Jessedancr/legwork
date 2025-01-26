import 'package:flutter/material.dart';
import 'package:legwork/Features/home/presentation/widgets/legwork_drawer_tile.dart';

class LegworkDrawer extends StatefulWidget {
  const LegworkDrawer({super.key});

  @override
  State<LegworkDrawer> createState() => _LegworkDrawerState();
}

class _LegworkDrawerState extends State<LegworkDrawer> {
  @override
  Widget build(BuildContext context) {
    //SCREEN SIZE
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // RETRUNED UI
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Person icon => Ideally this should be the profie picture of the user
          const Icon(
            Icons.person,
            size: 60,
          ),
          const SizedBox(height: 10),
          Divider(
            color: Theme.of(context).colorScheme.outline,
            thickness: 1.5,
          ),
          SizedBox(height: screenHeight * 0.05),

          /// DRAWER TILES
          // Alerts/notifications
          LegworkDrawerTile(
            leading: Icon(
              Icons.notifications,
              color: Theme.of(context).colorScheme.surface,
            ),
            title: Text(
              'Notifications',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
            onTap: () {},
          ),
          const SizedBox(height: 10),

          // Gig history
          LegworkDrawerTile(
            leading: Icon(
              Icons.history,
              color: Theme.of(context).colorScheme.surface,
            ),
            title: Text(
              'Gig history',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
            onTap: () {},
          ),
          const SizedBox(height: 10),

          // Earnings dashboard => A breakdown of how much the user has earned so far
          LegworkDrawerTile(
            leading: Icon(
              Icons.money,
              color: Theme.of(context).colorScheme.surface,
            ),
            title: Text(
              'Earnings',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
            onTap: () {},
          ),
          const SizedBox(height: 10),

          // Settings
          LegworkDrawerTile(
            leading: Icon(
              Icons.settings,
              color: Theme.of(context).colorScheme.surface,
            ),
            title: Text(
              'settings',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
            onTap: () {
              // pop drawer menu
              Navigator.of(context).pop();
              // navigate to settings page
              Navigator.of(context).pushNamed('/dancerSettingsScreen');
            },
          ),
        ],
      ),
    );
  }
}
