import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'package:legwork/Features/auth/presentation/Provider/my_auth_provider.dart';
import 'package:legwork/Features/auth/presentation/Widgets/auth_button.dart';
import 'package:legwork/Features/auth/presentation/Widgets/auth_loading_indicator.dart';
import 'package:legwork/Features/home/presentation/screens/dancer_screens/dancer_home_screen.dart';
import 'package:legwork/Features/home/presentation/screens/dancer_screens/job_applications_screen.dart';
import 'package:legwork/Features/home/presentation/screens/dancer_screens/dancer_messages.dart';
import 'package:legwork/Features/home/presentation/screens/dancer_screens/dancer_profile.dart';
import 'package:legwork/Features/home/presentation/widgets/dancers_nav_bar.dart';
import 'package:legwork/Features/home/presentation/widgets/legwork_drawer.dart';

import 'package:provider/provider.dart';

import 'dancer_settings_screen.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int selectedIndex = 0; // To track the index of the nav bar

  // METHOD TO NAVIGATE NAV BAR
  void navigateBottomBar(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  // LIST OF SCREENS TO BE SHOW BY NAV BAR
  final List<Widget> screens = [
    const DancerHomeScreen(),
    const JobApplicationsScreen(),
    const DancerMessages(),
    const DancerProfile()
  ];

  @override
  Widget build(BuildContext context) {
    // RETURNED WIDGET
    return SafeArea(
      child: Scaffold(
        body: screens[selectedIndex],
        appBar: AppBar(),
        drawer: LegworkDrawer(),
        bottomNavigationBar: DancersNavBar(
          screens: screens,
          selectedIndex: selectedIndex,
          onTabChange: (index) => navigateBottomBar(index),
        ),
      ),
    );
  }
}
