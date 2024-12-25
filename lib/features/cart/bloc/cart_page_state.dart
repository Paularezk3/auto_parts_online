// lib/features/cart/bloc/cart_page_state.dart
import '../models/cart_model.dart';

abstract class CartPageState {}

class CartPageInitial extends CartPageState {}

class CartPageLoading extends CartPageState {}

class CartPageLoaded extends CartPageState {
  final List<CartItem> items;
  final double totalPrice;

  CartPageLoaded({required this.items, required this.totalPrice});
}

class CartPageError extends CartPageState {
  final String message;

  CartPageError({required this.message});
}
