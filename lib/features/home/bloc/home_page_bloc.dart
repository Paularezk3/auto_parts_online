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
    // on<SearchHomePageDataEvent>(_onSearchHomePageData);
    // on<SearchHomePageTappedEvent>(_onSearchHomePageTapped);
    on<ExitSearchModeEvent>((event, emit) => emit(HomePageInitial()));
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

  bool isStillInState(Type stateType) => state.runtimeType == stateType;
}
