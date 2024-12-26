import 'package:auto_parts_online/app/routes/navigation_cubit.dart';
import 'package:auto_parts_online/app/routes/navigation_state.dart';
import 'package:auto_parts_online/features/cart/app_level_cubit/cart_state.dart';
import 'package:auto_parts_online/features/home/bloc/home_page_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cart/app_level_cubit/cart_cubit.dart';
import '../cart/models/cart_model.dart';

class HomePageViewModel {
  final HomePageBloc bloc;
  NavigationCubit navigationCubit;
  HomePageViewModel({required this.navigationCubit, required this.bloc});

  void onCartTapped(BuildContext context) {
    context.read<NavigationCubit>().push(NavigationCartPageState());
  }

  void onProductTapped(int productId) {
    navigationCubit.push(NavigationProductDetailsPageState(productId));
  }

  void onAddToCart(int productId, int quantity, BuildContext context) {
    final cartCubit = context.read<CartCubit>();
    // This if condition is made for avoiding concurrent addToCart when Fetching Add To Cart Products
    if (cartCubit.state is! CartLoadingState) {
      cartCubit.addToCart(CartItem(
        quantity: quantity,
        productId: productId,
      ));
    }
  }
}
