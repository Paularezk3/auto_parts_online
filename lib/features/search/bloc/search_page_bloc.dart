import 'package:auto_parts_online/app/setup_dependencies.dart';
import 'package:auto_parts_online/features/search/bloc/search_page_event.dart';
import 'package:auto_parts_online/features/search/bloc/search_page_state.dart';
import 'package:auto_parts_online/features/search/mock_search_page_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/app_logger.dart';

class SearchPageBloc extends Bloc<SearchPageEvent, SearchPageState> {
  ILogger logger = getIt<ILogger>();
  IMockSearchPageService searchPageService = getIt<IMockSearchPageService>();

  SearchPageBloc() : super(SearchPageInactive()) {
    on<EnterSearchPage>(_onEnterSearchPage);
    on<EmptySearchField>(_onEmptySearchField);
    on<DeleteRecentSearchEvent>(_onDeleteRecentSearch);
    on<FilledSearchBarChanged>(_filledSearchBarChanged);
  }

  Future<void> _filledSearchBarChanged(
      FilledSearchBarChanged event, Emitter<SearchPageState> emit) async {
    logger.debug("FilledSearchBarChanged Method Invoked");
    emit(FilledSearchLoading());

    try {
      final details = await searchPageService.fetchSearchResultDetails();
      if (!isStillInState(FilledSearchLoading)) {
        logger.warning(
            "SearchResultsLoaded state was about to emit, Current: $state");
        return;
      }
      emit(SearchResultsLoaded(data: details));
    } catch (e) {
      logger.error("SearchResultsLoaded failed: $e");
      emit(SearchPageError("Failed Load Search Results Details"));
    }
  }

  Future<void> _onEnterSearchPage(
      EnterSearchPage event, Emitter<SearchPageState> emit) async {
    logger.debug("EnterSearchPage method invoked, current state: $state");
    emit(EmptySearchLoading());

    try {
      final details = await searchPageService.fetchSearchEmptyFieldDetails();
      if (!isStillInState(EmptySearchLoading)) {
        logger.warning(
            "SearchBarActiveWithoutTyping state was about to emit, Current: $state");
        return;
      }
      emit(SearchBarActiveWithoutTyping(
        recentSearches: details.recentSearches,
        searchTappedDetails: details.searchTappedDetails,
        sparePartsCategorySuggestions: details.sparePartsCategorySuggestions,
      ));
    } catch (error) {
      logger.error("Search Tapped failed: $error");
      emit(SearchPageError("Failed to load Search Tapped Details"));
    }
  }

  Future<void> _onEmptySearchField(
      EmptySearchField event, Emitter<SearchPageState> emit) async {
    logger.info("Empty Search Field");
    emit(EmptySearchLoading());

    try {
      final details = await searchPageService.fetchSearchEmptyFieldDetails();
      if (!isStillInState(EmptySearchLoading)) {
        logger.warning(
            "SearchBarActiveWithoutTyping state was about to emit, Current: $state");
        return;
      }
      emit(SearchBarActiveWithoutTyping(
        recentSearches: details.recentSearches,
        searchTappedDetails: details.searchTappedDetails,
        sparePartsCategorySuggestions: details.sparePartsCategorySuggestions,
      ));
    } catch (e) {
      logger.error("Empty Search Field Failed: $e");
      emit(SearchPageError("Failed to Empty Search Field"));
    }
  }

  Future<void> _onDeleteRecentSearch(
      DeleteRecentSearchEvent event, Emitter<SearchPageState> emit) async {
    final currentState = state;
    if (currentState is SearchBarActiveWithoutTyping) {
      final updatedRecentSearches =
          List<String>.from(currentState.recentSearches)..remove(event.search);

      emit(SearchBarActiveWithoutTyping(
        recentSearches: updatedRecentSearches,
        searchTappedDetails: currentState.searchTappedDetails,
        sparePartsCategorySuggestions:
            currentState.sparePartsCategorySuggestions,
      ));
    }
  }

  bool isStillInState(Type stateType) => state.runtimeType == stateType;
}
