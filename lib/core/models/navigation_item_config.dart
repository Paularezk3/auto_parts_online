import 'package:flutter/widgets.dart';

class NavigationItemConfig {
  final Icon icon;
  final IconData activeIcon;
  final String label;
  final void Function(BuildContext) navigate;

  NavigationItemConfig({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.navigate,
  });
}
