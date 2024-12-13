import '../home_page_model.dart';

abstract class HomePageState {}

class HomePageInitial extends HomePageState {}

class HomePageLoading extends HomePageState {}

class HomePageLoaded extends HomePageState {
  final HomePageModel data;
  HomePageLoaded(this.data);
}

class HomePageError extends HomePageState {
  final String message;
  HomePageError(this.message);
}
