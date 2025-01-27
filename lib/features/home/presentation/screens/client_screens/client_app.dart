import 'package:flutter/material.dart';
import 'package:legwork/Features/home/presentation/screens/client_screens/client_home_screen.dart';
import 'package:legwork/Features/home/presentation/screens/client_screens/posted_jobs_screen.dart';
import 'package:legwork/Features/home/presentation/widgets/clients_drawer.dart';
import 'package:legwork/Features/home/presentation/widgets/clients_nav_bar.dart';
import 'package:legwork/Features/home/presentation/widgets/dancers_nav_bar.dart';
import 'package:legwork/Features/home/presentation/widgets/dancers_drawer.dart';

import 'client_messages_screen.dart';
import 'client_profile_screen.dart';

class ClientApp extends StatefulWidget {
  const ClientApp({super.key});

  @override
  State<ClientApp> createState() => _ClientAppState();
}

class _ClientAppState extends State<ClientApp> {
  int selectedIndex = 0; // To track the index of the nav bar

  // METHOD TO NAVIGATE NAV BAR
  void navigateBottomBar(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  // LIST OF SCREENS TO BE SHOW BY NAV BAR
  final List<Widget> screens = [
    const ClientHomeScreen(),
    const PostedJobsScreen(),
    const ClientMessagesScreen(),
    const ClientProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    // RETURNED WIDGET
    return SafeArea(
      child: Scaffold(
        body: screens[selectedIndex],
        appBar: AppBar(),
        drawer: ClientsDrawer(),
        bottomNavigationBar: ClientsNavBar(
          screens: screens,
          selectedIndex: selectedIndex,
          onTabChange: (index) => navigateBottomBar(index),
        ),
      ),
    );
  }
}
