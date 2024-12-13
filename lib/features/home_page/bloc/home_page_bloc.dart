// lib\features\home_page\bloc\home_page_bloc.dart

import 'dart:math';

import 'package:auto_parts_online/core/utils/app_logger.dart';
import 'package:auto_parts_online/features/home_page/home_page_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_page_event.dart';
import 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  HomePageBloc() : super(HomePageInitial()) {
    // Register the event handler directly
    on<LoadHomePageData>(_onLoadHomePageData);
  }

  Future<void> _onLoadHomePageData(
      LoadHomePageData event, Emitter<HomePageState> emit) async {
    emit(HomePageLoading());
    try {
      final random = Random();
      int randomNumber =
          random.nextInt(3) + 2; // Generates a random number between 2 and 4
      // Simulate fetching data
      await Future.delayed(const Duration(seconds: 3))
          .timeout(Duration(seconds: randomNumber));
      final data = HomePageModel(
          title: "Elite Spare Parts",
          description: "Find the best spare parts for your needs",
          items: [
            HomePageItem(title: "Engine Oil", subtitle: "Best quality oils"),
            HomePageItem(title: "Brake Pads", subtitle: "Reliable brake pads"),
          ],
          noOfItemsInCart: 3);
      emit(HomePageLoaded(data));
    } catch (error) {
      AppLogger.error("Failed to load data: $error");
      emit(HomePageError("Failed to load data"));
    }
  }
}
