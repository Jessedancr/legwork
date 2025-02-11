import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class DancersNavBar extends StatefulWidget {
  int selectedIndex;
  final List<Widget> screens;
  void Function(int)? onTabChange;
  DancersNavBar({
    super.key,
    required this.screens,
    required this.selectedIndex,
    required this.onTabChange,
  });

  @override
  State<DancersNavBar> createState() => _DancersNavBarState();
}

class _DancersNavBarState extends State<DancersNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.onSurface,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 10,
        ),
        child: GNav(
          gap: 8,
          backgroundColor: Theme.of(context).colorScheme.onSurface,
          color: Theme.of(context).colorScheme.surface,
          activeColor: Theme.of(context).colorScheme.surface,
          tabBackgroundColor: Theme.of(context).colorScheme.secondary,
          rippleColor: Theme.of(context).colorScheme.primaryFixedDim,
          tabBackgroundGradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.onPrimaryContainer,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          textStyle: GoogleFonts.robotoSlab(
            color: Theme.of(context).colorScheme.surface,
            fontWeight: FontWeight.w600,
          ),
          padding: const EdgeInsets.all(16),
          selectedIndex: widget.selectedIndex,
          onTabChange: (index) => widget.onTabChange!(index),
          tabs: const [
            GButton(
              icon: Icons.home_outlined,
              text: 'Home',
            ),
            GButton(
              icon: Icons.book_outlined,
              text: 'Job Apps',
            ),
            GButton(
              icon: Icons.chat_bubble_outline_rounded,
              text: 'Chats',
            ),
            GButton(
              icon: Icons.person_2_outlined,
              text: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
