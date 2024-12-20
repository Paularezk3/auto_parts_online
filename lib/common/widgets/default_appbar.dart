// lib\common\widgets\default_appbar.dart

import 'package:auto_parts_online/app/routes/navigation_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import '../../app/routes/navigation_cubit.dart';
import '../../core/constants/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final isArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(title);
    final titleColor = Theme.of(context).brightness == Brightness.dark
        ? (isLoading ? AppColors.primaryGrey : AppColors.primaryDark)
        : (isLoading ? AppColors.primaryGrey : AppColors.primaryLight);

    // Determine animation parameters based on state
    final appBarHeight =
        isSearchMode ? 115.0 : 150.0; // Shrink height for search
    const Duration animationDuration = Duration(milliseconds: 500);
    const Curve curve = Curves.easeInOutCubic;
    SearchController? searchController;
    Logger().t(searchText, stackTrace: StackTrace.empty);
    if (searchText != null) {
      searchController = SearchController();
      searchController.text = searchText!;
    }

    return AnimatedContainer(
      duration: animationDuration,
      curve: curve,
      height: appBarHeight,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color.fromARGB(255, 29, 16, 0)
            : AppColors.primaryForegroundDark,
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
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? isLoading
                                          ? AppColors.secondaryDarkerGrey!
                                          : AppColors.primaryDark
                                      : isLoading
                                          ? AppColors.secondaryDarkerGrey!
                                          : AppColors.primaryLight,
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
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.primaryDark,
                      ),
                      onPressed: () {
                        context
                            .read<NavigationCubit>()
                            .navigateTo(NavigationHomePageState());
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
                          hintStyle: WidgetStateProperty.all<TextStyle>(
                            isArabic
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
                          ),
                          backgroundColor: WidgetStateProperty.all<Color>(
                            Theme.of(context).brightness == Brightness.dark
                                ? AppColors.secondaryForegroundLight
                                : AppColors.secondaryForegroundDark,
                          ),
                          leading: Icon(
                            Icons.search,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.primaryDark
                                    : AppColors.primaryLight,
                          ),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          padding: WidgetStateProperty.all<EdgeInsets>(
                            EdgeInsets.symmetric(
                              horizontal: isSearchMode ? 10 : 16.0,
                            ), // Adjust vertical padding
                          ),
                          constraints: const BoxConstraints(
                              maxHeight: 80, minHeight: 40),
                          onTap: onSearchBarTap,
                          keyboardType: TextInputType.text,
                        );
                      },
                      searchController: searchController,
                      suggestionsBuilder:
                          (BuildContext context, SearchController controller) {
                        final query = controller.text;
                        return List<Widget>.generate(
                          query.isEmpty ? 0 : 5, // Example suggestions count
                          (int index) => ListTile(
                            title: Text('$query suggestion $index'),
                            onTap: () {
                              controller.closeView(query);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
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
