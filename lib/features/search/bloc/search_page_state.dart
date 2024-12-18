import '../search_page_model.dart';

class SearchPageState {}

class SearchPageInactive extends SearchPageState {}

class SearchPageActive extends SearchPageState {}

class SearchLoading extends SearchPageState {}

class SearchLoaded extends SearchPageState {
  final SearchData data;
  SearchLoaded(this.data);
}

class SearchBarTapped extends SearchPageState {
  final List<String> recentSearches;
  final List<SparePartsCategory> sparePartsCategorySuggestions;
  final SearchTappedDetails searchTappedDetails;
  SearchBarTapped(
      {required this.recentSearches,
      required this.searchTappedDetails,
      required this.sparePartsCategorySuggestions});
}

class SearchMode extends SearchPageState {}

class SearchPageError extends SearchPageState {
  final String message;
  SearchPageError(this.message);
}
