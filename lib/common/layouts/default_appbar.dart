// lib\common\widgets\default_appbar.dart

import 'package:auto_parts_online/app/routes/navigation_state.dart';
import 'package:auto_parts_online/common/widgets/skeleton_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/routes/navigation_cubit.dart';
import '../../core/constants/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

mixin AppBarStyle {
  static bool isArabic(String title) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(title);
  }

  static bool isDarkMode({required context}) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Color titleColor({required context, required isLoading}) {
    return isDarkMode(context: context)
        ? (isLoading ? AppColors.primaryGrey : AppColors.primaryDark)
        : (isLoading ? AppColors.primaryGrey : AppColors.primaryLight);
  }

  static TextStyle titleTextStyle(
      {required title, required context, required isLoading}) {
    return isArabic(title)
        ? GoogleFonts.cairo(
            textStyle: TextStyle(
              color: titleColor(context: context, isLoading: isLoading),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          )
        : GoogleFonts.inter(
            textStyle: TextStyle(
            color: titleColor(context: context, isLoading: isLoading),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ));
  }

  static Color cartIconColor({required context, required isLoading}) {
    return isDarkMode(context: context)
        ? isLoading
            ? AppColors.secondaryDarkerGrey!
            : AppColors.primaryDark
        : isLoading
            ? AppColors.secondaryDarkerGrey!
            : AppColors.primaryLight;
  }

  static Color searchIconColor({required context, required isLoading}) {
    return isLoading
        ? AppColors.primaryGrey
        : isDarkMode(context: context)
            ? AppColors.primaryDark
            : AppColors.primaryLight;
  }

  static WidgetStateProperty<TextStyle?>? searchHintTextStyle(
      {required context, required hintText}) {
    return WidgetStateProperty.all<TextStyle>(
      isArabic(hintText)
          ? GoogleFonts.cairo(
              textStyle: TextStyle(
                color: isDarkMode(context: context)
                    ? Colors.black54
                    : Colors.white,
                fontSize: 16,
              ),
            )
          : GoogleFonts.inter(
              textStyle: TextStyle(
                color: isDarkMode(context: context)
                    ? Colors.black54
                    : Colors.white,
                fontSize: 16,
              ),
            ),
    );
  }

  static Color appbarColor({required context}) {
    return isDarkMode(context: context)
        ? const Color.fromARGB(255, 29, 16, 0)
        : AppColors.primaryForegroundDark;
  }

  static Decoration? appbarContainerDecoration(
      {required context, bool withShadow = true}) {
    return BoxDecoration(
      color: appbarColor(context: context),
      boxShadow: withShadow
          ? [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                offset: const Offset(0, 1),
                blurRadius: 2,
              ),
            ]
          : null,
    );
  }
}

class HomePageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isLoading;
  final int noOfItemsInCart;
  final void Function()? onCartTap;
  final void Function()? onSearchBarTap;
  final bool isSearchMode;
  final void Function(String)? onSearchFieldChanged;
  final ValueChanged<String>? onSearchSubmitted;
  final String? searchText;

  const HomePageAppBar({
    required this.isLoading,
    required this.title,
    this.noOfItemsInCart = 0,
    this.onCartTap,
    this.onSearchBarTap,
    required this.isSearchMode,
    this.onSearchFieldChanged,
    this.onSearchSubmitted,
    this.searchText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Determine animation parameters based on state
    final appBarHeight =
        isSearchMode ? 115.0 : 150.0; // Shrink height for search
    const Duration animationDuration = Duration(milliseconds: 500);
    const Curve curve = Curves.easeInOutCubic;
    SearchController? searchController;
    if (searchText != null) {
      searchController = SearchController();
      searchController.text = searchText!;
    }
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor:
          AppBarStyle.appbarColor(context: context), // Set the status bar color
      statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark
          ? Brightness.light
          : Brightness.dark, // Adjust icon brightness
    ));

    return SafeArea(
      bottom: false,
      child: AnimatedContainer(
        duration: animationDuration,
        curve: curve,
        height: appBarHeight,
        decoration: AppBarStyle.appbarContainerDecoration(context: context),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: animationDuration,
              height: isSearchMode ? 0 : 33,
              curve: curve,
              child: AnimatedOpacity(
                duration: animationDuration,
                opacity: isSearchMode ? 0 : 1,
                curve: isSearchMode ? Curves.easeOutExpo : Curves.easeInExpo,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title
                    Text(title,
                        style: AppBarStyle.titleTextStyle(
                            title: title,
                            context: context,
                            isLoading: isLoading)),
                    // Cart Icon
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
                                color: AppBarStyle.cartIconColor(
                                    context: context, isLoading: isLoading),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.shopping_cart,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
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
                    ),
                  ],
                ),
              ),
            ),
            // Search Anchor with SearchBar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AnimatedContainer(
                  duration: animationDuration,
                  width: isSearchMode ? 45 : 0,
                  curve: curve,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: AppBarStyle.searchIconColor(
                          context: context, isLoading: isLoading),
                    ),
                    onPressed: () {
                      context
                          .read<NavigationCubit>()
                          .navigateTo(NavigationHomePageState());
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: SearchAnchor(
                    builder:
                        (BuildContext context, SearchController controller) {
                      return SearchBar(
                        controller: controller,
                        hintText: AppLocalizations.of(context)!.searchHint,
                        onChanged: onSearchFieldChanged,
                        onSubmitted: onSearchSubmitted,
                        hintStyle: AppBarStyle.searchHintTextStyle(
                            context: context,
                            hintText: AppLocalizations.of(context)!.searchHint),
                        backgroundColor: WidgetStateProperty.all<Color>(
                          Theme.of(context).brightness == Brightness.dark
                              ? AppColors.secondaryForegroundLight
                              : AppColors.secondaryForegroundDark,
                        ),
                        leading: Icon(
                          Icons.search,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.primaryDark
                              : AppColors.primaryLight,
                        ),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        padding: WidgetStateProperty.all<EdgeInsets>(
                          EdgeInsets.symmetric(
                            horizontal: isSearchMode ? 10 : 16.0,
                          ), // Adjust vertical padding
                        ),
                        constraints:
                            const BoxConstraints(maxHeight: 80, minHeight: 40),
                        onTap: onSearchBarTap,
                        keyboardType: TextInputType.text,
                      );
                    },
                    searchController: searchController,
                    suggestionsBuilder:
                        (BuildContext context, SearchController controller) {
                      return List<Widget>.generate(
                        0, // Example suggestions count
                        (int index) => const ListTile(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize {
    return Size.fromHeight(isSearchMode ? 90.0 : 120.0);
  }
}

class OtherPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final void Function()? onBackTap;
  final bool isLoading;
  final bool isTitleLoading;
  final bool? withShadow;

  const OtherPageAppBar({
    this.withShadow,
    required this.title,
    this.showBackButton = false,
    this.onBackTap,
    required this.isLoading,
    this.isTitleLoading = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor:
          AppBarStyle.appbarColor(context: context), // Set the status bar color
      statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark
          ? Brightness.light
          : Brightness.dark, // Adjust icon brightness
    ));

    return SafeArea(
      bottom: false,
      child: Container(
        decoration: AppBarStyle.appbarContainerDecoration(
            context: context, withShadow: withShadow ?? true),
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            if (showBackButton) ...[
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
              const SizedBox(width: 16),
            ],
            Expanded(
              child: isTitleLoading
                  ? const ShimmerBox(width: 20, height: 20)
                  : Text(
                      title,
                      textAlign: TextAlign.center,
                      style: AppBarStyle.titleTextStyle(
                          title: title, context: context, isLoading: isLoading),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
