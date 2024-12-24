import 'package:auto_parts_online/app/routes/navigation_cubit.dart';
import 'package:auto_parts_online/app/routes/navigation_state.dart';
import 'package:auto_parts_online/features/home/bloc/home_page_bloc.dart';

class HomePageViewModel {
  final HomePageBloc bloc;
  NavigationCubit navigationCubit;
  HomePageViewModel({required this.navigationCubit, required this.bloc});

  onCartTapped() {}

  void onProductTapped(int productId) {
    navigationCubit.push(NavigationProductDetailsPageState(productId));
  }
}
