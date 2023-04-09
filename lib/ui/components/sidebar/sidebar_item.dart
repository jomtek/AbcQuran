import 'package:flutter/material.dart';

class SidebarItem {
  final int id;
  final String title;
  final IconData icon;
  final bool isSelected;

  SidebarItem(this.id, this.title, this.icon, this.isSelected);
}