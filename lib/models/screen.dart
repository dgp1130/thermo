import 'package:flutter/material.dart';

class Screen {
  final String title;
  final IconData icon;

  static final Screen temperature = new Screen("Temperature", Icons.rotate_right);
  static final Screen schedule = new Screen("Schedule", Icons.calendar_today);

  static List<Screen> get screens => [ temperature, schedule ];

  Screen(this.title, this.icon);
}