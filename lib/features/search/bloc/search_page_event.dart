class SearchPageEvent {}

class EnterSearchPage extends SearchPageEvent {}

class ExitSearchModeEvent extends SearchPageEvent {}

class DeleteRecentSearchEvent extends SearchPageEvent {
  final String search;

  DeleteRecentSearchEvent(this.search);

  List<Object> get props => [search];
}
