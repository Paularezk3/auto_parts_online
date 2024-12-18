import '../home_page_model.dart';

abstract class HomePageState {}

class HomePageInitial extends HomePageState {}

class HomePageLoading extends HomePageState {}

class HomePageLoaded extends HomePageState {
  final HomePageData data;
  HomePageLoaded(this.data);
}

class HomePageError extends HomePageState {
  final String message;
  HomePageError(this.message);
}

class SearchLoading extends HomePageState {}

class SearchLoaded extends HomePageState {
  final SearchData data;
  SearchLoaded(this.data);
}

class SearchBarTapped extends HomePageState {
  final List<String> recentSearches;
  final List<SparePartsCategory> sparePartsCategorySuggestions;
  final SearchTappedDetails searchTappedDetails;
  SearchBarTapped(
      {required this.recentSearches,
      required this.searchTappedDetails,
      required this.sparePartsCategorySuggestions});
}

class SearchMode extends HomePageState {}
