// lib/features/cart/bloc/cart_page_state.dart
import 'package:auto_parts_online/features/cart/models/cart_page_model.dart';

abstract class CartPageState {}

class CartPageInitial extends CartPageState {}

class CartPageLoading extends CartPageState {}

class CartPageLoaded extends CartPageState {
  final CartPageModel? cartPageData;

  CartPageLoaded({required this.cartPageData});
}

class CartPageEmpty extends CartPageState {}

class CartPageError extends CartPageState {
  final String message;

  CartPageError({required this.message});
}

class CartPageEditLoading extends CartPageState {
  final CartPageModel? cartPageData;
  CartPageEditLoading({required this.cartPageData});
}

class CartPageLeft extends CartPageState {}
