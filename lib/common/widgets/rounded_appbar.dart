import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class RoundedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Gradient? backgroundGradient;
  final double elevation;

  const RoundedAppBar({
    super.key,
    required this.title,
    this.actions,
    this.backgroundColor,
    this.backgroundGradient,
    this.elevation = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: elevation,
      backgroundColor: backgroundColor,
      flexibleSpace: backgroundGradient != null
          ? Container(
              decoration: BoxDecoration(
                gradient: backgroundGradient,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
            )
          : null,
      title: Text(
        title,
        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: backgroundColor == null
                  ? AppColors.primaryForegroundLight
                  : AppColors.primaryForegroundDark,
            ),
      ),
      actions: actions,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}
