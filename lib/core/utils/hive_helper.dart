import 'package:hive_flutter/hive_flutter.dart';

import 'app_logger.dart';

class HiveHelper {
  static const String _boxName = 'recentSearchBox';
  late Box<List<String>> _box;
  final ILogger _logger;

  HiveHelper(this._logger);

  // Initialize Hive box
  void init() {
    _box = Hive.box<List<String>>(_boxName);
    _logger.trace('HiveHelper initialized', null);
  }

  Future<void> addRecentSearch(String newRecent) async {
    try {
      final recents = getRecentSearches();
      if (!recents.contains(newRecent)) {
        recents.add(newRecent);
        await _box.put('recentSearch', recents);
      } else {
        // Reordering to place the newRecent at the end
        recents.remove(newRecent);
        recents.add(newRecent);
        await _box.put('recentSearch', recents);
      }
    } catch (e) {
      _logger.error('Failed to add recent search $e', StackTrace.current);
    }
  }

  List<String> getRecentSearches() {
    return _box.get('recentSearch', defaultValue: <String>[])!;
  }

  Future<void> deleteRecentSearch(String searchToDelete) async {
    try {
      final recents = getRecentSearches();
      recents.remove(searchToDelete);
      await _box.put('recentSearch', recents);
      _logger.trace('Deleted recent search: $searchToDelete', null);
    } catch (e) {
      _logger.error('Failed to delete recent search: $e', StackTrace.current);
    }
  }

  Future<void> clearRecentSearches() async {
    try {
      await _box.put('recentSearch', []);
      _logger.trace('Cleared all recent searches', null);
    } catch (e) {
      _logger.error('Failed to clear recent searches: $e', StackTrace.current);
    }
  }
}
