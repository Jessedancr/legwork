import 'package:flutter/material.dart';
import 'package:legwork/features/chat/presentation/screens/client_messages_screen.dart';
import 'package:legwork/features/home/presentation/screens/client_screens/client_home_screen.dart';
import 'package:legwork/features/home/presentation/widgets/clients_nav_bar.dart';

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

  // LIST OF SCREENS TO BE SHOWN BY NAV BAR
  final List<Widget> screens = [
    ClientHomeScreen(),
    const ClientMessagesScreen(),
    ClientProfileScreen()
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
        bottomNavigationBar: ClientsNavBar(
          screens: screens,
          selectedIndex: selectedIndex,
          onTabChange: (index) => navigateBottomBar(index),
        ),
      ),
    );
  }
}
