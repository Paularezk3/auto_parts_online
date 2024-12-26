// lib/features/cart/bloc/cart_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/cart_model.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartState());

  void addToCart(CartItem item) {
    emit(state.copyWith(items: [...state.items, item]));
  }

  void removeFromCart(int itemId) {
    emit(state.copyWith(
        items: state.items.where((i) => i.id != itemId).toList()));
  }

  void clearCart() {
    emit(CartState());
  }
}
