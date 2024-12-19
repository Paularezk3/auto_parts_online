import 'package:auto_parts_online/common/widgets/default_loading_widget.dart';
import 'package:auto_parts_online/features/search/bloc/search_page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/setup_dependencies.dart';
import '../../common/widgets/confirmation_dialog.dart';
import '../../common/widgets/default_appbar.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_logger.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'bloc/search_page_bloc.dart';
import 'bloc/search_page_event.dart';

class SearchPageView extends StatelessWidget {
  const SearchPageView({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<SearchPageBloc>().add(EnterSearchPage());
    final logger = getIt<ILogger>();
    final String homePageTitle = AppLocalizations.of(context)!.homePageTitle;
    final homePageBackgroundColor =
        Theme.of(context).brightness == Brightness.light
            ? AppColors.secondaryForegroundLight
            : AppColors.primaryForegroundLight;
    final theme = Theme.of(context);
    final onCartTap = () {};
    final isDarkMode = theme.brightness == Brightness.dark;
    final navigatorKey = getIt<GlobalKey<NavigatorState>>();

    return BlocBuilder<SearchPageBloc, SearchPageState>(
      builder: (context, state) {
        if (state is SearchPageInactive) {
          logger.debug("init SearchPage");
          return Scaffold(
            appBar: HomePageAppBar(
                key: navigatorKey,
                isLoading: false,
                title: "Home Page",
                onCartTap: () {},
                isSearchMode: true),
          );
        } else if (state is SearchBarTapped) {
          return Scaffold(
            appBar: HomePageAppBar(
              key: navigatorKey,
              isSearchMode: true,
              isLoading: false,
              title: homePageTitle,
              onCartTap: onCartTap,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
// Recent Searches Section (Chips with Long Press to Delete)
                    if (state.recentSearches.isNotEmpty) ...[
                      Text(
                        "Recent Searches",
                        style: theme.textTheme.headlineMedium!.copyWith(
                            fontWeight: FontWeight.bold, letterSpacing: 0.7),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: state.recentSearches.map((search) {
                          return GestureDetector(
                            onLongPress: () {
// Remove item on long press
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ConfirmationDialog(
                                        title: "Warning",
                                        message:
                                            "You are about to delete Recent Search",
                                        onConfirm: () {
                                          context.read<SearchPageBloc>().add(
                                              DeleteRecentSearchEvent(search));
                                          logger.info(
                                              "Deleted Recent Search: $search");
                                        });
                                  });

// Trigger UI refresh via BLoC or setState in a StatefulWidget
                            },
                            child: Chip(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 2),
                              label: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.history,
                                      size: 24,
                                      color: isDarkMode
                                          ? AppColors.accentDark
                                          : AppColors.accentLight),
                                  const SizedBox(width: 4),
                                  Text(
                                    search,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                              backgroundColor: isDarkMode
                                  ? Colors.grey[800]
                                  : Colors.grey[200],
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                    ],

// Popular Searches Section
                    if (state
                        .searchTappedDetails.popularSearches.isNotEmpty) ...[
                      Text(
                        "Popular Searches",
                        style: theme.textTheme.headlineMedium!.copyWith(
                            fontWeight: FontWeight.bold, letterSpacing: 0.7),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: state.searchTappedDetails.popularSearches
                            .map((search) {
                          return Chip(
                            label: Text(
                              search,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            backgroundColor: isDarkMode
                                ? Colors.grey[800]
                                : Colors.grey[200],
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                    ],

// Spare Parts Suggestions Section
                    if (state.sparePartsCategorySuggestions.isNotEmpty) ...[
                      Text(
                        "Spare Parts Suggestions",
                        style: theme.textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.sparePartsCategorySuggestions.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              title: Text(state
                                  .sparePartsCategorySuggestions[index]
                                  .partName),
                              trailing: const Icon(Icons.arrow_forward),
                              onTap: () {
                                logger.info(
                                  "Tapped on Spare Part Suggestion: ${state.sparePartsCategorySuggestions[index].partName}",
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
            backgroundColor: homePageBackgroundColor,
          );
        }
        return Scaffold(
          appBar: HomePageAppBar(
              key: navigatorKey,
              isLoading: false,
              title: "Home Page",
              onCartTap: () {},
              isSearchMode: true),
        );
      },
    );
  }
}
