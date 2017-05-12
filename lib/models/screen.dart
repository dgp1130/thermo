import "package:flutter/material.dart";

/// Model representing a single Screen to show within the app which can be
/// selected between using the bottom navigation bar.
class Screen {
  final String title;
  final IconData icon;

  static const Screen temperature = const Screen("Temperature", Icons.rotate_right);
  static const Screen schedule = const Screen("Schedule", Icons.calendar_today);

  static List<Screen> get screens => const <Screen>[ temperature, schedule ];

  const Screen(this.title, this.icon);
}