import 'package:flutter/material.dart';

class MenuOption {
  final String title;
  final IconData icon;
  final String route;
  final Color? color;

  const MenuOption({
    required this.title,
    required this.icon,
    required this.route,
    this.color,
  });
}

