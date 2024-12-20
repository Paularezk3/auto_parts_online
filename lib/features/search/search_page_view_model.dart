import '../../core/utils/app_logger.dart';
import '../../core/utils/hive_helper.dart';

class SearchPageViewModel {
  final HiveHelper hiveHelper;
  final ILogger logger;
  SearchPageViewModel({required this.hiveHelper, required this.logger});
  void onSearchSubmitted(String query) {
    logger.debug(
        "onSearchSubmitted invoked, will save $query", StackTrace.current);
    hiveHelper.addRecentSearch(query);
  }

  List<String> getRecentSearches() {
    List<String> recentSearches = hiveHelper.getRecentSearches();
    logger.debug(
        "getRecentSearches invoked, and here's the searches: ${recentSearches.iterator}",
        StackTrace.current);
    return recentSearches;
  }
}
