import 'package:flutter/material.dart';
import 'package:legwork/features/home/presentation/screens/dancer_screens/dancer_home_screen.dart';
import 'package:legwork/features/home/presentation/screens/dancer_screens/job_applications_screen.dart';
import 'package:legwork/features/chat/presentation/screens/dancer_messages_screen.dart';
import 'package:legwork/features/home/presentation/screens/dancer_screens/dancer_profile_screen.dart';
import 'package:legwork/features/home/presentation/widgets/dancers_nav_bar.dart';

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
    const DancerMessagesScreen(),
    DancerProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    // RETURNED WIDGET
    return SafeArea(
      child: Scaffold(
        body: IndexedStack(
          index: selectedIndex,
          children: screens,
        ),
        bottomNavigationBar: DancersNavBar(
          screens: screens,
          selectedIndex: selectedIndex,
          onTabChange: (index) => navigateBottomBar(index),
        ),
      ),
    );
  }
}
