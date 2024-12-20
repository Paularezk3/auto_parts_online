import '../home_page_model.dart';

abstract class HomePageState {}

class HomePageInitial extends HomePageState {}

class HomePageLoading extends HomePageState {}

class HomePageLoaded extends HomePageState {
  final HomePageData homePageData;
  HomePageLoaded(this.homePageData);
}

class HomePageError extends HomePageState {
  final String message;
  HomePageError(this.message);
}
