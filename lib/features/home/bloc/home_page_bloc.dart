// lib\features\home_page\bloc\home_page_bloc.dart
import 'package:auto_parts_online/core/utils/app_logger.dart';
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
    on<ExitSearchModeEvent>((event, emit) => emit(HomePageInitial()));
  }

  Future<void> _onLoadHomePageData(
      LoadHomePageDataEvent event, Emitter<HomePageState> emit) async {
    logger.info("BLoC HomePage Loading", StackTrace.current);

    // Set the intent before emitting the loading state
    emit(HomePageLoading());

    try {
      final homePageData = await mockHomeService.fetchHomePageData();

      // Check if the user is still waiting for home page data
      if (state is! HomePageLoading) {
        logger.warning(
            "Skipped emitting HomePageLoaded as user intent changed.",
            StackTrace.current);
        return;
      }

      logger.info("BLoC HomePage Loaded", StackTrace.current);
      emit(HomePageLoaded(homePageData));
    } catch (error) {
      logger.error("Failed to load data: $error", StackTrace.current);

      // Check if the user is still waiting for home page data
      if (state is! HomePageLoading) {
        logger.warning("Skipped emitting HomePageError as user intent changed.",
            StackTrace.current);
        return;
      }

      emit(HomePageError("Failed to load data"));
    }
  }

  bool isStillInState(Type stateType) => state.runtimeType == stateType;
}
