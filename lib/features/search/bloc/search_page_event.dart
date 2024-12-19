abstract class SearchPageEvent {
  final String finalIntendedState = "";
}

class EnterSearchPage extends SearchPageEvent {}

class ExitSearchModeEvent extends SearchPageEvent {}

class EmptySearchField extends SearchPageEvent {}

class FilledSearchBarChanged extends SearchPageEvent {
  final String query;
  FilledSearchBarChanged(this.query);
}

class DeleteRecentSearchEvent extends SearchPageEvent {
  final String search;

  DeleteRecentSearchEvent(this.search);

  List<Object> get props => [search];
}
