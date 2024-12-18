// lib\features\home_page\bloc\home_page_bloc.dart
import 'package:auto_parts_online/core/utils/app_logger.dart';
import 'package:auto_parts_online/features/home/home_page_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/setup_dependencies.dart';
import '../mock_home_page_service.dart';
import 'home_page_event.dart';
import 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  final IMockHomePageService mockHomeService = getIt<IMockHomePageService>();
  final logger = getIt<ILogger>();

  HomePageBloc() : super(HomePageInitial()) {
    // Register the event handlers
    on<LoadHomePageDataEvent>(_onLoadHomePageData);
    on<SearchHomePageDataEvent>(_onSearchHomePageData);
    on<SearchHomePageTappedEvent>(_onSearchHomePageTapped);
    on<DeleteRecentSearchEvent>(_onDeleteRecentSearch);
  }

  Future<void> _onLoadHomePageData(
      LoadHomePageDataEvent event, Emitter<HomePageState> emit) async {
    logger.info("BLoC HomePage Loading");

    // Set the intent before emitting the loading state
    emit(HomePageLoading());

    try {
      final data = await mockHomeService.fetchHomePageData();

      // Check if the user is still waiting for home page data
      if (state is! HomePageLoading) {
        logger
            .warning("Skipped emitting HomePageLoaded as user intent changed.");
        return;
      }

      logger.info("BLoC HomePage Loaded");
      emit(HomePageLoaded(data));
    } catch (error) {
      logger.error("Failed to load data: $error");

      // Check if the user is still waiting for home page data
      if (state is! HomePageLoading) {
        logger
            .warning("Skipped emitting HomePageError as user intent changed.");
        return;
      }

      emit(HomePageError("Failed to load data"));
    }
  }

  Future<void> _onSearchHomePageTapped(
      SearchHomePageTappedEvent event, Emitter<HomePageState> emit) async {
    logger.info("SearchTapped");

    // Set the intent before emitting the loading state
    if (isStillInState(SearchBarTapped)) {
      emit(SearchLoading());
    }

    try {
      final data = await mockHomeService.fetchSearchTappedDetails();

      // Check if the user is still waiting for search results
      if (isStillInState(SearchLoading)) {
        logger.warning(
            "Skipped emitting SearchBarTapped as user intent changed.");
        return;
      }

      logger.info("BLoC Search Results Loaded");
      emit(data);
    } catch (error) {
      logger.error("Search Tapped failed: $error");

      emit(HomePageError("Failed to load Search Tapped Details"));
    }
  }

  Future<void> _onSearchHomePageData(
      SearchHomePageDataEvent event, Emitter<HomePageState> emit) async {
    logger.info("BLoC Searching HomePage Data for query: ${event.query}");

    emit(SearchLoading()); // Show a loading state while searching
    try {
      // Simulate fetching search results
      await Future.delayed(const Duration(seconds: 2));

      if (isStillInState(SearchLoading)) {
        logger.warning("Skipped emitting SearchData as user intent changed.");
        return;
      }

      final searchResults = SearchData(
          data: [HomePageItem(title: "title", subtitle: "subtitle")],
          noOfItemsInCart: 3);

      logger.info("BLoC Search Results Loaded");
      emit(SearchLoaded(searchResults));
    } catch (error) {
      logger.error("Search failed: $error");
      emit(HomePageError("Failed to load search results"));
    }
  }

  Future<void> _onDeleteRecentSearch(
      DeleteRecentSearchEvent event, Emitter<HomePageState> emit) async {
    final currentState = state;
    if (currentState is SearchBarTapped) {
      final updatedRecentSearches =
          List<String>.from(currentState.recentSearches)..remove(event.search);

      emit(SearchBarTapped(
        recentSearches: updatedRecentSearches,
        searchTappedDetails: currentState.searchTappedDetails,
        sparePartsCategorySuggestions:
            currentState.sparePartsCategorySuggestions,
      ));
    }
  }

  bool isStillInState(Type stateType) => state.runtimeType == stateType;
}
