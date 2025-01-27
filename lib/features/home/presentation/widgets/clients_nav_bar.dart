import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class ClientsNavBar extends StatefulWidget {
  int selectedIndex;
  final List<Widget> screens;
  void Function(int)? onTabChange;
  ClientsNavBar({
    super.key,
    required this.screens,
    required this.selectedIndex,
    required this.onTabChange,
  });

  @override
  State<ClientsNavBar> createState() => _ClientsNavBarState();
}

class _ClientsNavBarState extends State<ClientsNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.onSurface,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 20,
        ),
        child: GNav(
          gap: 8,
          backgroundColor: Theme.of(context).colorScheme.onSurface,
          color: Theme.of(context).colorScheme.surface,
          activeColor: Theme.of(context).colorScheme.surface,
          tabBackgroundColor: Theme.of(context).colorScheme.primary,
          padding: const EdgeInsets.all(16),
          selectedIndex: widget.selectedIndex,
          onTabChange: (index) => widget.onTabChange!(index),
          tabs: const [
            GButton(
              icon: Icons.home,
              text: 'Home',
            ),
            GButton(
              icon: Icons.book,
              text: 'Jobs',
            ),
            GButton(
              icon: Icons.chat,
              text: 'Chats',
            ),
            GButton(
              icon: Icons.person,
              text: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
