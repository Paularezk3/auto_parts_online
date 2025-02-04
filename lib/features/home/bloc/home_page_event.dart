// lib\features\home\bloc\home_page_event.dart

abstract class HomePageEvent {}

class LoadHomePageDataEvent extends HomePageEvent {}

class SearchHomePageDataEvent extends HomePageEvent {
  final String query;
  SearchHomePageDataEvent(this.query);

  List<Object> get props => [query];
}

class SearchHomePageTappedEvent extends HomePageEvent {}

class EnterSearchModeEvent extends HomePageEvent {}

class ExitSearchModeEvent extends HomePageEvent {}
