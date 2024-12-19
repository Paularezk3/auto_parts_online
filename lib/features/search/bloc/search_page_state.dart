import '../search_page_model.dart';

class SearchPageState {}

class SearchPageInactive extends SearchPageState {}

class EmptySearchLoading extends SearchPageState {}

class FilledSearchLoading extends SearchPageState {}

class SearchBarActiveWithoutTyping extends SearchPageState {
  final List<String> recentSearches;
  final List<SparePartsCategory> sparePartsCategorySuggestions;
  final SearchTappedDetails searchTappedDetails;
  SearchBarActiveWithoutTyping(
      {required this.recentSearches,
      required this.searchTappedDetails,
      required this.sparePartsCategorySuggestions});
}

class SearchPageError extends SearchPageState {
  final String message;
  SearchPageError(this.message);
}

class SearchResultsLoaded extends SearchPageState {
  final List<ProductCardDetails> data;
  SearchResultsLoaded({required this.data});
}
