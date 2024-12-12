import 'package:flutter/material.dart';
import 'constants/app_colors.dart';

class AppThemes {
  // Light Theme
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primaryLight,
    scaffoldBackgroundColor: AppColors.secondaryForegroundLight,
    colorScheme: const ColorScheme.light(
      surface: AppColors.primaryForegroundLight,
      onSurface: AppColors.secondaryForegroundLight,
      primary: AppColors.primaryLight,
      onPrimary: AppColors.primaryForegroundLight,
      secondary: AppColors.secondaryLight,
      onSecondary: AppColors.secondaryForegroundLight,
      error: Color(0xffB3261E),
      onError: Color(0xffffffff),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.primaryForegroundLight),
      bodyMedium: TextStyle(color: AppColors.primaryForegroundLight),
      headlineLarge: TextStyle(color: AppColors.primaryForegroundLight),
    ),
  );

  // Dark Theme
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryDark,
    scaffoldBackgroundColor: AppColors.secondaryForegroundDark,
    colorScheme: const ColorScheme.dark(
      surface: AppColors.primaryForegroundDark,
      onSurface: AppColors.secondaryForegroundDark,
      primary: AppColors.primaryDark,
      onPrimary: AppColors.primaryForegroundDark,
      secondary: AppColors.secondaryDark,
      onSecondary: AppColors.secondaryForegroundDark,
      error: Color(0xffF2B8B5),
      onError: Color(0xff601410),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.primaryForegroundDark),
      bodyMedium: TextStyle(color: AppColors.primaryForegroundDark),
      headlineLarge: TextStyle(color: AppColors.primaryForegroundDark),
    ),
  );
}
