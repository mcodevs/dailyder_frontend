import 'package:flutter/material.dart';

class AppNavigationItem {
  const AppNavigationItem({
    required this.title,
    required this.location,
    required this.icon,
    this.adminOnly = false,
  });

  final String title;
  final String location;
  final IconData icon;
  final bool adminOnly;
}
