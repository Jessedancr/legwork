import 'package:flutter/material.dart';

// Screen Size
double screenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double screenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

// Defining extensions for text themes
extension LegworkTextStyles on BuildContext {
  TextStyle? get heading2Xl => Theme.of(this).textTheme.displayLarge;
  TextStyle? get headingXl => Theme.of(this).textTheme.displayMedium;
  TextStyle? get headingLg => Theme.of(this).textTheme.displaySmall;
  TextStyle? get headingMd => Theme.of(this).textTheme.headlineLarge;
  TextStyle? get headingSm => Theme.of(this).textTheme.headlineMedium;
  TextStyle? get headingXs => Theme.of(this).textTheme.headlineSmall;
  TextStyle? get heading2Xs => Theme.of(this).textTheme.titleMedium;

  TextStyle? get text2Xl => Theme.of(this).textTheme.bodyLarge;
  TextStyle? get textXl => Theme.of(this).textTheme.bodyMedium;
  TextStyle? get textLg => Theme.of(this).textTheme.bodySmall;
  TextStyle? get textMd => Theme.of(this).textTheme.labelLarge;
  TextStyle? get textSm => Theme.of(this).textTheme.labelMedium;
  TextStyle? get textXs => Theme.of(this).textTheme.labelSmall;
  TextStyle? get text2Xs =>
      Theme.of(this).textTheme.labelSmall?.copyWith(fontSize: 8);
}

// Extension to get the color scheme of the app
extension LegworkColorScheme on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}

// Extension to get the current theme of the app
extension LegworkTheme on BuildContext {
  ThemeData get theme => Theme.of(this);
}

const defaultDancerProfileImage =
    'images/depictions/dancer_dummy_default_profile_picture.jpg';

const defaultClientProfileImage = 'images/depictions/img_depc1.jpg';
