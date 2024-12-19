import 'package:auto_parts_online/common/components/default_buttons.dart';
import 'package:auto_parts_online/common/widgets/skeleton_loader.dart';
import 'package:auto_parts_online/features/search/bloc/search_page_state.dart';
import 'package:auto_parts_online/features/search/search_page_model.dart';
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
    final logger = getIt<ILogger>();
    final String homePageTitle = AppLocalizations.of(context)!.homePageTitle;
    final homePageBackgroundColor =
        Theme.of(context).brightness == Brightness.light
            ? AppColors.secondaryForegroundLight
            : AppColors.primaryForegroundLight;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final navigatorKey = getIt<GlobalKey<NavigatorState>>();
    // Access the already provided BLoC
    final searchPageBloc = context.read<SearchPageBloc>();

    // Ensure the event is dispatched outside the build phase
    if (searchPageBloc.state is SearchPageInactive) {
      logger.debug(
          "Current State: ${searchPageBloc.state}\nAdding EnterSearchPage event");
      searchPageBloc.add(EnterSearchPage());
    }
    return BlocBuilder<SearchPageBloc, SearchPageState>(
      builder: (context, state) {
        if (state is SearchPageInactive) {
          logger.debug("init SearchPage");
          return emptyLoadingScaffold(navigatorKey);
        } else if (state is SearchBarActiveWithoutTyping) {
          return searchBarActiveWithoutTypingScaffold(
              navigatorKey,
              homePageTitle,
              context,
              state,
              theme,
              logger,
              isDarkMode,
              homePageBackgroundColor);
        } else if (state is EmptySearchLoading) {
          logger.debug("Loading SearchPageView");
          return emptyLoadingScaffold(navigatorKey);
        } else if (state is SearchPageError) {
          logger.debug("Error SearchPage Building");
          return errorScaffold(navigatorKey, logger);
        } else if (state is FilledSearchLoading) {
          logger.debug("Loading FilledSearchPageView");
          return emptyLoadingScaffold(navigatorKey);
        } else if (state is SearchResultsLoaded) {
          return _buildResultsList(state.data, navigatorKey, context);
        }
        return Scaffold(
          appBar: HomePageAppBar(
              key: navigatorKey,
              isLoading: false,
              title: "Home Page",
              isSearchMode: true),
        );
      },
    );
  }

  Widget _buildResultsList(List<ProductCardDetails> products,
      GlobalKey<NavigatorState> navigatorKey, BuildContext context) {
    return Scaffold(
      appBar: HomePageAppBar(
        isLoading: false,
        title: "Home Page",
        isSearchMode: true,
        key: navigatorKey,
        onSearchFieldChanged: (query) => query.isEmpty
            ? context.read<SearchPageBloc>().add(EmptySearchField())
            : context.read<SearchPageBloc>().add(FilledSearchBarChanged(query)),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.7,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            elevation: 4,
            shadowColor: Colors.grey.shade200,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Product Image
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Image.network(
                      product.productImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.broken_image,
                          size: 64,
                          color: Colors.grey),
                    ),
                  ),
                ),

                // Product Details
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Name
                      Text(
                        product.productName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Product Price
                      Text(
                        "${product.productPrice.toStringAsFixed(2)} E£",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Stock Availability
                      Text(
                        product.stockAvailability,
                        style: TextStyle(
                          fontSize: 12,
                          color: product.stockAvailability.toLowerCase() ==
                                  "in stock"
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),

                // Add to Cart Button
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      // Add to cart logic
                    },
                    child: const Text("Add to Cart"),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            "No results found for your search.",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Clear filters logic
            },
            child: const Text("Clear Filters"),
          ),
          ElevatedButton(
            onPressed: () {
              // Browse categories logic
            },
            child: const Text("Browse Categories"),
          ),
        ],
      ),
    );
  }

  Scaffold searchBarActiveWithoutTypingScaffold(
      GlobalKey<NavigatorState> navigatorKey,
      String homePageTitle,
      BuildContext context,
      SearchBarActiveWithoutTyping state,
      ThemeData theme,
      ILogger logger,
      bool isDarkMode,
      Color homePageBackgroundColor) {
    return Scaffold(
      appBar: HomePageAppBar(
        key: navigatorKey,
        isSearchMode: true,
        isLoading: false,
        title: homePageTitle,
        onSearchFieldChanged: (query) {
          if (query.isNotEmpty) {
            context.read<SearchPageBloc>().add(FilledSearchBarChanged(query));
          } else {
            context.read<SearchPageBloc>().add(EmptySearchField());
          }
        },
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
                if (state.recentSearches.isEmpty)
                  Text(
                    AppLocalizations.of(context)!.recentSearchEmpty,
                    style: theme.textTheme.bodyMedium,
                  ),
                if (state.recentSearches.isNotEmpty)
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
                                      context
                                          .read<SearchPageBloc>()
                                          .add(DeleteRecentSearchEvent(search));
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
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          backgroundColor:
                              isDarkMode ? Colors.grey[800] : Colors.grey[200],
                        ),
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 16),
              ],

// Popular Searches Section
              if (state.searchTappedDetails.popularSearches.isNotEmpty) ...[
                Text(
                  "Popular Searches",
                  style: theme.textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.bold, letterSpacing: 0.7),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      state.searchTappedDetails.popularSearches.map((search) {
                    return Chip(
                      label: Text(
                        search,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      backgroundColor:
                          isDarkMode ? Colors.grey[800] : Colors.grey[200],
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
                            .sparePartsCategorySuggestions[index].partName),
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

  Scaffold emptyLoadingScaffold(GlobalKey<NavigatorState> navigatorKey) {
    return Scaffold(
        appBar: HomePageAppBar(
            key: navigatorKey,
            isLoading: false,
            title: "Home Page",
            isSearchMode: true),
        body: const SearchSkeletonLoader());
  }

  Scaffold errorScaffold(
      GlobalKey<NavigatorState> navigatorKey, ILogger logger) {
    return Scaffold(
      appBar: const HomePageAppBar(
          isLoading: true, title: "Home Page", isSearchMode: true),
      body: Column(
        children: [
          const Text("Error Just Happened, Try Reloading the Page"),
          const SizedBox(
            height: 12,
          ),
          PrimaryButton(text: "Reload Page", logger: logger),
        ],
      ),
    );
  }
}
