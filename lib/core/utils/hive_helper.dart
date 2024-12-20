import 'package:auto_parts_online/app/setup_dependencies.dart';
import 'package:auto_parts_online/core/utils/app_logger.dart';
import 'package:hive/hive.dart';

class HiveHelper {
  static const String _boxName = 'recentSearchBox'; // Define the box name
  late Box<List<String>> _box; // Correct type for the box
  ILogger logger = getIt<ILogger>();

  // Initialize the box (call this once during app initialization)
  void init() {
    _box = Hive.box<List<String>>(_boxName); // Open the box as List<String>
  }

  // Add a recent search
  Future<void> addRecentSearch(String newRecent) async {
    // Fetch the current list of recent searches or use an empty list if not set
    List<String> recents = _box.get("recentSearch", defaultValue: <String>[])!;
    if (!recents.contains(newRecent)) {
      // Avoid duplicates
      recents.add(newRecent);
      await _box.put("recentSearch", recents);
    } else {
      await _box.put("recentSearch", [newRecent]);
    }
  }

  // Get recent searches
  List<String> getRecentSearches() {
    // Return the stored list or an empty list if the key doesn't exist

    return _box.get("recentSearch", defaultValue: <String>[])!;
  }

  // Delete a specific recent search or update the whole list
  Future<void> deleteRecentSearch(
      {List<String>? recents, String? deletedRecent}) async {
    if (recents != null) {
      // Replace the whole list
      await _box.put("recentSearch", recents);
    } else if (deletedRecent != null) {
      // Remove a specific recent search
      List<String> currentRecents = getRecentSearches();
      currentRecents.remove(deletedRecent);
      await _box.put("recentSearch", currentRecents);
      logger.warning("init _box : ${getRecentSearches()}", StackTrace.current);
    }
  }
}
