// lib\app\routes\navigation_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';

import 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(NavigationHomePageState());

  void goToHomePage() => emit(NavigationHomePageState());
  void goToProductPage() => emit(NavigationProductPageState());
}
