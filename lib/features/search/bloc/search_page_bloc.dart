import 'package:auto_parts_online/app/setup_dependencies.dart';
import 'package:auto_parts_online/features/search/bloc/search_page_event.dart';
import 'package:auto_parts_online/features/search/bloc/search_page_state.dart';
import 'package:auto_parts_online/features/search/mock_search_page_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/cubits/recent_search_cubit.dart';
import '../../../core/utils/app_logger.dart';

class SearchPageBloc extends Bloc<SearchPageEvent, SearchPageState> {
  ILogger logger = getIt<ILogger>();
  IMockSearchPageService searchPageService = getIt<IMockSearchPageService>();

  SearchPageBloc() : super(SearchPageInactive()) {
    on<EnterSearchPage>(_onEnterSearchPage);
    on<EmptySearchField>(_onEmptySearchField);
    on<DeleteRecentSearchEvent>(_onDeleteRecentSearch);
    on<FilledSearchBarChanged>(_filledSearchBarChanged);
    on<RecentSearchChosed>(_recentSearchChosed);
  }
  final recentSearchCubit = getIt<RecentSearchCubit>();

  String? _currentQueryToken;

  Future<void> _filledSearchBarChanged(
      FilledSearchBarChanged event, Emitter<SearchPageState> emit) async {
    final queryToken = DateTime.now().toIso8601String();
    _currentQueryToken = queryToken;
    logger.trace("FilledSearchBarChanged Method Invoked", StackTrace.current);
    emit(FilledSearchLoading());

    try {
      final details = await searchPageService.fetchSearchResultDetails();
      if (!isStillInState(FilledSearchLoading) &&
          _currentQueryToken != queryToken) {
        logger.warning(
            "SearchResultsLoaded state was about to emit, Current: $state",
            StackTrace.current);
        return;
      }
      emit(SearchResultsLoaded(data: details));
    } catch (e) {
      logger.error("SearchResultsLoaded failed: $e", StackTrace.current);
      emit(SearchPageError("Failed Load Search Results Details"));
    }
  }

  Future<void> _recentSearchChosed(
      RecentSearchChosed event, Emitter<SearchPageState> emit) async {
    final queryToken = DateTime.now().toIso8601String();
    _currentQueryToken = queryToken;
    logger.trace("recentSearchChosed Method Invoked", StackTrace.current);
    emit(FilledSearchLoading(query: event.query));

    try {
      final details = await searchPageService.fetchSearchResultDetails();

      if (!isStillInState(FilledSearchLoading) &&
          _currentQueryToken != queryToken) {
        logger.warning(
            "SearchResultsLoaded state was about to emit, Current: $state",
            StackTrace.current);
        return;
      }
      emit(SearchResultsLoaded(data: details, searchBarText: event.query));
    } catch (e) {
      logger.error("SearchResultsLoaded failed: $e", StackTrace.current);
      emit(SearchPageError("Failed Load Search Results Details"));
    }
  }

  Future<void> _onEnterSearchPage(
      EnterSearchPage event, Emitter<SearchPageState> emit) async {
    final queryToken = DateTime.now().toIso8601String();
    _currentQueryToken = queryToken;
    logger.trace("EnterSearchPage method invoked, current state: $state",
        StackTrace.current);
    emit(EmptySearchLoading());

    try {
      final details = await searchPageService
          .fetchSearchEmptyFieldDetails(recentSearchCubit);
      if (!isStillInState(EmptySearchLoading) &&
          _currentQueryToken != queryToken) {
        logger.warning(
            "SearchBarActiveWithoutTyping state was about to emit, Current: $state",
            StackTrace.current);
        return;
      }
      emit(SearchBarActiveWithoutTyping(
        searchTappedDetails: details.searchTappedDetails,
        sparePartsCategorySuggestions: details.sparePartsCategorySuggestions,
      ));
    } catch (error) {
      logger.error("OnEnterSearchPage failed: $error", StackTrace.current);
      emit(SearchPageError("Failed to load Search Tapped Details"));
    }
  }

  Future<void> _onEmptySearchField(
      EmptySearchField event, Emitter<SearchPageState> emit) async {
    final queryToken = DateTime.now().toIso8601String();
    _currentQueryToken = queryToken;

    logger.trace("Empty Search Field", StackTrace.current);
    emit(EmptySearchLoading());

    try {
      final details = await searchPageService
          .fetchSearchEmptyFieldDetails(recentSearchCubit);
      if (!isStillInState(EmptySearchLoading) &&
          _currentQueryToken != queryToken) {
        logger.warning(
            "SearchBarActiveWithoutTyping state was about to emit, Current: $state",
            StackTrace.current);
        return;
      }
      emit(SearchBarActiveWithoutTyping(
        searchTappedDetails: details.searchTappedDetails,
        sparePartsCategorySuggestions: details.sparePartsCategorySuggestions,
      ));
    } catch (e) {
      logger.error("Empty Search Field Failed: $e", StackTrace.current);
      emit(SearchPageError("Failed to Empty Search Field"));
    }
  }

  Future<void> _onDeleteRecentSearch(
      DeleteRecentSearchEvent event, Emitter<SearchPageState> emit) async {
    final currentState = state;
    if (currentState is SearchBarActiveWithoutTyping) {
      await recentSearchCubit.deleteRecentSearch(event.search);

      emit(SearchBarActiveWithoutTyping(
        searchTappedDetails: currentState.searchTappedDetails,
        sparePartsCategorySuggestions:
            currentState.sparePartsCategorySuggestions,
      ));
    }
  }

  bool isStillInState(Type stateType) => state.runtimeType == stateType;
}
