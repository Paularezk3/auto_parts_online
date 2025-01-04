import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants/app_colors.dart';

class AppThemes {
  // Light Theme
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primaryLight,
    scaffoldBackgroundColor: AppColors.secondaryForegroundLight,
    colorScheme: const ColorScheme.light(
      surface: AppColors.primaryForegroundDark,
      onSurface: AppColors.secondaryForegroundLight,
      primary: AppColors.primaryLight,
      onPrimary: AppColors.primaryForegroundLight,
      secondary: AppColors.secondaryLight,
      onSecondary: AppColors.secondaryForegroundLight,
      error: Color(0xffB3261E),
      onError: Color(0xffffffff),
    ),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: NoPageTransition(),
        TargetPlatform.iOS: NoPageTransition(),
      },
    ),
    textTheme: TextTheme(
      bodyLarge: GoogleFonts.montserrat(color: AppColors.primaryTextLight),
      bodyMedium: GoogleFonts.montserrat(color: AppColors.primaryTextLight),
      headlineLarge: GoogleFonts.inter(color: AppColors.primaryTextLight),
      headlineMedium: GoogleFonts.inter(color: AppColors.primaryTextLight),
      headlineSmall: GoogleFonts.inter(color: AppColors.primaryTextLight),
      titleLarge: GoogleFonts.roboto(color: AppColors.primaryTextLight),
      titleMedium: GoogleFonts.roboto(color: AppColors.primaryTextLight),
    ),
  );

  // Dark Theme
  // static final darkTheme = ThemeData(
  //   brightness: Brightness.dark,
  //   primaryColor: AppColors.primaryDark,
  //   scaffoldBackgroundColor: AppColors.secondaryForegroundDark,
  //   colorScheme: const ColorScheme.dark(
  //     surface: AppColors.primaryForegroundDark,
  //     onSurface: AppColors.secondaryForegroundDark,
  //     primary: AppColors.primaryDark,
  //     onPrimary: AppColors.primaryForegroundDark,
  //     secondary: AppColors.secondaryDark,
  //     onSecondary: AppColors.secondaryForegroundDark,
  //     error: Color(0xffF2B8B5),
  //     onError: Color(0xff601410),
  //   ),
  //   textTheme: TextTheme(
  //     bodyLarge: GoogleFonts.montserrat(color: AppColors.primaryTextDark),
  //     bodyMedium: GoogleFonts.montserrat(
  //       color: AppColors.primaryTextDark,
  //     ),
  //     headlineLarge: GoogleFonts.inter(color: AppColors.primaryTextDark),
  //     headlineMedium: GoogleFonts.inter(color: AppColors.primaryTextDark),
  //   ),
  // );
}

class NoPageTransition extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return child;
  }
}

class SlidePageTransition extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }
}
