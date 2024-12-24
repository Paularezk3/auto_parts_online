// lib/features/cart/bloc/cart_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/cart_model.dart';

class CartState {
  final List<CartItem> items;

  CartState({this.items = const []});

  int get totalItems => items.length;

  double get totalPrice => items.fold(0, (total, item) => total + item.price);

  CartState copyWith({List<CartItem>? items}) {
    return CartState(
      items: items ?? this.items,
    );
  }
}

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartState());

  void addToCart(CartItem item) {
    emit(state.copyWith(items: [...state.items, item]));
  }

  void removeFromCart(CartItem item) {
    emit(state.copyWith(items: state.items.where((i) => i != item).toList()));
  }

  void clearCart() {
    emit(CartState());
  }
}
