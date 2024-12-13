import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DefaultNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final List<NavigationItem> items;

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
          ? AppColors.secondaryForegroundDark
          : AppColors.secondaryForegroundLight,
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

class NavigationItem {
  final Widget icon;
  final IconData activeIcon;
  final String label;

  NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
