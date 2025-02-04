import 'package:flutter_bloc/flutter_bloc.dart';

import '../utils/hive_helper.dart';

class RecentSearchCubit extends Cubit<List<String>> {
  final HiveHelper _hiveHelper;

  RecentSearchCubit(this._hiveHelper) : super([]) {
    loadRecentSearches();
  }

  void loadRecentSearches() {
    final searches = _hiveHelper.getRecentSearches();
    emit(searches);
  }

  Future<void> addRecentSearch(String search) async {
    await _hiveHelper.addRecentSearch(search);
    loadRecentSearches();
  }

  Future<void> deleteRecentSearch(String search) async {
    await _hiveHelper.deleteRecentSearch(search);
    loadRecentSearches();
  }

  Future<void> clearRecentSearches() async {
    await _hiveHelper.clearRecentSearches();
    emit([]);
  }
}
