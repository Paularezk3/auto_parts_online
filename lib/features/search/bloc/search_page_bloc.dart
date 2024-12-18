import 'package:auto_parts_online/app/setup_dependencies.dart';
import 'package:auto_parts_online/features/search/bloc/search_page_event.dart';
import 'package:auto_parts_online/features/search/bloc/search_page_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/app_logger.dart';
import '../search_page_model.dart';

class SearchPageBloc extends Bloc<SearchPageEvent, SearchPageState> {
  ILogger logger = getIt<ILogger>();
  SearchPageBloc() : super(SearchPageInactive()) {
    on<EnterSearchPage>(_onEnterSearchPage);

    on<DeleteRecentSearchEvent>(_onDeleteRecentSearch);
  }

  _onEnterSearchPage(EnterSearchPage e, Emitter<SearchPageState> emit) async {
    logger.info("SearchTapped");
    emit(SearchLoading());

    try {
      final details = await fetchSearchTappedDetails();
      emit(SearchBarTapped(
        recentSearches: details.recentSearches,
        searchTappedDetails: details.searchTappedDetails,
        sparePartsCategorySuggestions: details.sparePartsCategorySuggestions,
      ));
    } catch (error) {
      logger.error("Search Tapped failed: $error");
      emit(SearchPageError("Failed to load Search Tapped Details"));
    }
  }

  Future<void> _onDeleteRecentSearch(
      DeleteRecentSearchEvent event, Emitter<SearchPageState> emit) async {
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

  Stream<SearchPageState> mapEventToState(SearchPageEvent event) async* {
    if (event is EnterSearchPage) {
      yield SearchPageActive();
    } else if (event is ExitSearchModeEvent) {
      yield SearchPageInactive();
    }
  }

  Future<SearchBarTapped> fetchSearchTappedDetails() async {
    await Future.delayed(const Duration(seconds: 1));
    return SearchBarTapped(
      recentSearches: List.generate(
          4,
          (index) => index % 3 == 0
              ? "This long Recent Search $index"
              : "Recent Search $index"),
      searchTappedDetails: SearchTappedDetails(
        popularSearches: List.generate(
            6,
            (i) => i % 3 == 0
                ? "This is long Popular Searches $i"
                : "Popular adsdasddsa$i"),
      ),
      sparePartsCategorySuggestions:
          List.generate(7, (i) => SparePartsCategory("Part Suggestion $i")),
    );
  }

  Future<SearchData> searchHomePageData(String query) async {
    await Future.delayed(const Duration(seconds: 2));
    return SearchData(data: []);
  }

  bool isStillInState(Type stateType) => state.runtimeType == stateType;
}
