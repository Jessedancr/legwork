import 'package:flutter/material.dart';
import 'package:legwork/Features/home/presentation/screens/dancer_screens/dancer_home_screen.dart';
import 'package:legwork/Features/home/presentation/screens/dancer_screens/job_applications_screen.dart';
import 'package:legwork/Features/home/presentation/screens/dancer_screens/dancer_messages.dart';
import 'package:legwork/Features/home/presentation/screens/dancer_screens/dancer_profile.dart';
import 'package:legwork/Features/home/presentation/widgets/dancers_nav_bar.dart';
import 'package:legwork/Features/home/presentation/widgets/dancers_drawer.dart';

class DancerApp extends StatefulWidget {
  const DancerApp({super.key});

  @override
  State<DancerApp> createState() => _DancerAppState();
}

class _DancerAppState extends State<DancerApp> {
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
        drawer: DancersDrawer(),
        bottomNavigationBar: DancersNavBar(
          screens: screens,
          selectedIndex: selectedIndex,
          onTabChange: (index) => navigateBottomBar(index),
        ),
      ),
    );
  }
}
