import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:legwork/core/Constants/helpers.dart';

class NavBarIcons {
  static const String _fontFamily = 'LegworkNavBarIcons';

  static const IconData home = IconData(0xe801, fontFamily: _fontFamily);
  static const IconData briefcase = IconData(0xe800, fontFamily: _fontFamily);
  static const IconData chat = IconData(0xe802, fontFamily: _fontFamily);
  static const IconData user = IconData(0xe803, fontFamily: _fontFamily);
}

// ignore: must_be_immutable
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
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 12.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: Container(
          decoration: BoxDecoration(
            color: context.colorScheme.onSurface,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 5.0,
            ),
            child: GNav(
              tabMargin: const EdgeInsets.only(top: 10, bottom: 10),
              gap: 8,
              backgroundColor: context.colorScheme.onSurface,
              color: context.colorScheme.surface,
              activeColor: context.colorScheme.surface,
              tabBackgroundColor: context.colorScheme.secondary,
              rippleColor: context.colorScheme.primaryFixedDim,
              tabBackgroundGradient: LinearGradient(
                colors: [
                  context.colorScheme.primary,
                  context.colorScheme.onPrimaryContainer,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              textStyle: context.textMd?.copyWith(
                color: context.colorScheme.surface,
                fontWeight: FontWeight.w600,
              ),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              selectedIndex: widget.selectedIndex,
              onTabChange: (index) => widget.onTabChange!(index),
              tabs: const [
                GButton(
                  icon: NavBarIcons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: NavBarIcons.briefcase,
                  text: 'Applications',
                ),
                GButton(
                  icon: NavBarIcons.chat,
                  text: 'Chats',
                ),
                GButton(
                  icon: NavBarIcons.user,
                  text: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
