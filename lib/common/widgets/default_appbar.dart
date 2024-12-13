import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isLoading;
  final int noOfItemsInCart;
  final void Function()? onCartTap;
  const HomePageAppBar(
      {required this.isLoading,
      required this.title,
      this.noOfItemsInCart = 0,
      required this.onCartTap,
      super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(title);
    final titleColor = Theme.of(context).brightness == Brightness.dark
        ? (isLoading ? AppColors.primaryGrey : AppColors.primaryDark)
        : (isLoading ? AppColors.primaryGrey : AppColors.primaryLight);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.secondaryForegroundDark
            : AppColors.secondaryForegroundLight,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Home Page Text
                  Text(
                    title,
                    style: isArabic
                        ? GoogleFonts.cairo(
                            textStyle: TextStyle(
                              color: titleColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : GoogleFonts.inter(
                            textStyle: TextStyle(
                              color: titleColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  //Cart Icon
                  GestureDetector(
                    onTap: onCartTap,
                    child: Stack(
                      children: [
                        Container(
                          height: 32,
                          width: 32,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? isLoading
                                      ? AppColors.secondaryDarkerGrey!
                                      : AppColors.primaryDark
                                  : isLoading
                                      ? AppColors.secondaryDarkerGrey!
                                      : AppColors.primaryLight, // Border color
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.shopping_cart,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? isLoading
                                        ? AppColors.primaryGrey
                                        : AppColors.primaryDark
                                    : isLoading
                                        ? AppColors.primaryGrey
                                        : AppColors.primaryLight,
                            size: 20,
                          ),
                        ),
                        if (noOfItemsInCart > 0)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4.0),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              child: Center(
                                child: Text(
                                  '$noOfItemsInCart',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 12),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.secondaryForegroundLight
                      : AppColors
                          .secondaryForegroundDark, // Search bar background color
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Icon(
                        Icons.search,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.primaryDark
                            : AppColors.primaryLight, // Search icon color
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        style: isArabic
                            ? GoogleFonts.cairo(
                                textStyle: TextStyle(
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.white
                                      : Colors.black54,
                                  fontSize: 16,
                                ),
                              )
                            : GoogleFonts.inter(
                                textStyle: TextStyle(
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.white
                                      : Colors.black54,
                                  fontSize: 16,
                                ),
                              ),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: AppLocalizations.of(context)!.searchHint,
                            hintStyle: isArabic
                                ? GoogleFonts.cairo(
                                    textStyle: TextStyle(
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.white
                                        : Colors.black54, // Placeholder color
                                    fontSize: 16,
                                  ))
                                : GoogleFonts.inter(
                                    textStyle: TextStyle(
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.white
                                        : Colors.black54, // Placeholder color
                                    fontSize: 16,
                                  ))),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(110);
}

class OtherPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final bool showSearchBar;
  final void Function()? onBackTap;
  final void Function()? onSearchTap;

  const OtherPageAppBar({
    required this.title,
    this.showBackButton = false,
    this.showSearchBar = false,
    this.onBackTap,
    this.onSearchTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(title);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.secondaryForegroundDark
            : AppColors.secondaryForegroundLight,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              if (showBackButton)
                GestureDetector(
                  onTap: onBackTap,
                  child: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.primaryDark
                        : AppColors.primaryLight,
                    size: 24,
                  ),
                ),
              if (showBackButton) const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: isArabic
                      ? GoogleFonts.cairo(
                          textStyle: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.primaryDark
                                    : AppColors.primaryLight,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : GoogleFonts.inter(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  textAlign: showSearchBar ? TextAlign.start : TextAlign.center,
                ),
              ),
              if (showSearchBar)
                GestureDetector(
                  onTap: onSearchTap,
                  child: Icon(
                    Icons.search,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.primaryDark
                        : AppColors.primaryLight,
                    size: 24,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
