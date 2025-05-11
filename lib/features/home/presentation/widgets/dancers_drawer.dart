import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:legwork/features/home/presentation/widgets/legwork_list_tile.dart';

class DancersDrawer extends StatefulWidget {
  const DancersDrawer({super.key});

  @override
  State<DancersDrawer> createState() => _DancersDrawerState();
}

class _DancersDrawerState extends State<DancersDrawer> {
  @override
  Widget build(BuildContext context) {
    //SCREEN SIZE
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // RETRUNED UI
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      width: screenWidth * 0.6,
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
            SizedBox(height: screenHeight * 0.05),
            // Person icon => Ideally this should be the profie picture of the user
            SvgPicture.asset(
              'assets/svg/user.svg',
              height: screenHeight * 0.07,
            ),
            const SizedBox(height: 10),
            Divider(
              color: Theme.of(context).colorScheme.outline,
              thickness: 1.5,
            ),
            SizedBox(height: screenHeight * 0.05),

            /// DRAWER TILES
            // Alerts/notifications
            LegworkListTile(
              leading: SvgPicture.asset(
                'assets/svg/notfications.svg',
                fit: BoxFit.scaleDown,
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
            SizedBox(height: screenHeight * 0.05),

            // Gig history
            LegworkListTile(
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
            SizedBox(height: screenHeight * 0.05),

            // Earnings dashboard => A breakdown of how much the user has earned so far
            LegworkListTile(
              leading: SvgPicture.asset(
                'assets/svg/usd-circle.svg',
                fit: BoxFit.scaleDown,
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
            SizedBox(height: screenHeight * 0.05),

            // Settings
            LegworkListTile(
              leading: SvgPicture.asset(
                'assets/svg/settings.svg',
                fit: BoxFit.scaleDown,
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
      ),
    );
  }
}
