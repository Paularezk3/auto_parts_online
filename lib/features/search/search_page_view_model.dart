import 'package:auto_parts_online/core/cubits/recent_search_cubit.dart';

import '../../core/utils/app_logger.dart';

class SearchPageViewModel {
  final RecentSearchCubit recentSearchCubit;
  final ILogger logger;
  SearchPageViewModel({required this.recentSearchCubit, required this.logger});

  void onSearchSubmitted(String query) {
    logger.trace("onSearchSubmitted invoked, will save $query", null);
    recentSearchCubit.addRecentSearch(query);
  }

  void getRecentSearches() {
    logger.trace("getRecentSearches invoked", StackTrace.current);
  }
}
