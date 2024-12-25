// lib/features/cart/bloc/cart_page_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/cart_model.dart';
import 'cart_page_event.dart';
import 'cart_page_state.dart';

class CartPageBloc extends Bloc<CartPageEvent, CartPageState> {
  CartPageBloc() : super(CartPageInitial()) {
    on<LoadCartPage>(_loadCartPage);
    on<AddItemToCart>(_addItemToCart);
    on<RemoveItemFromCart>(_removeItemFromCart);
    on<ClearCart>(_clearCart);
  }

  void _loadCartPage(LoadCartPage event, Emitter<CartPageState> emit) {
    emit(CartPageLoading());
    // Simulate loading cart items.
    final items = [
      CartItem(id: 1, name: 'Sample Product', price: 10.0, quantity: 1),
    ];
    emit(CartPageLoaded(
        items: items,
        totalPrice:
            items.fold(0, (sum, item) => sum + (item.price * item.quantity))));
  }

  void _addItemToCart(AddItemToCart event, Emitter<CartPageState> emit) {
    if (state is CartPageLoaded) {
      final currentState = state as CartPageLoaded;
      final updatedItems = [...currentState.items, event.item];
      final totalPrice = updatedItems.fold(
          0.0, (sum, item) => sum + (item.price * item.quantity));
      emit(CartPageLoaded(items: updatedItems, totalPrice: totalPrice));
    }
  }

  void _removeItemFromCart(
      RemoveItemFromCart event, Emitter<CartPageState> emit) {
    if (state is CartPageLoaded) {
      final currentState = state as CartPageLoaded;
      final updatedItems =
          currentState.items.where((item) => item.id != event.itemId).toList();
      final totalPrice = updatedItems.fold(
          0.0, (sum, item) => sum + (item.price * item.quantity));
      emit(CartPageLoaded(items: updatedItems, totalPrice: totalPrice));
    }
  }

  void _clearCart(ClearCart event, Emitter<CartPageState> emit) {
    emit(CartPageLoaded(items: [], totalPrice: 0));
  }
}
