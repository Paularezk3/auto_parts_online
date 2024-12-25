import 'package:auto_parts_online/core/models/navigation_item_config.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class DefaultNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final List<NavigationItemConfig> items;

  const DefaultNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    assert(
        items.length >= 2, 'DefaultNavigationBar requires at least two items.');

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor =
        isDarkMode ? AppColors.primaryDark : AppColors.primaryLight;

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: isDarkMode
          ? AppColors.primaryForegroundLight
          : AppColors.primaryForegroundDark,
      selectedItemColor: primaryColor,
      unselectedItemColor: AppColors.primaryGrey,
      selectedLabelStyle: _textStyle(context),
      unselectedLabelStyle: _textStyle(context),
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      items: items
          .map(
            (item) => BottomNavigationBarItem(
              icon: item.icon,
              activeIcon: Icon(item.activeIcon, color: primaryColor),
              label: item.label,
            ),
          )
          .toList(),
    );
  }

  TextStyle _textStyle(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return TextStyle(
      fontFamily: isArabic ? 'Cairo' : 'Inter',
      fontSize: 12,
      fontWeight: FontWeight.w600,
    );
  }
}
