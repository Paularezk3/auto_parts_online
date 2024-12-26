import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/setup_dependencies.dart';
import '../mock_cart_page_service.dart';
import '../models/cart_model.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final IMockCartPageService _cartPageService = getIt<IMockCartPageService>();

  CartCubit() : super(CartState());

  /// Updates the state with recalculated totals and updated cart items.
  Future<void> _updateCartState(List<CartItem> items) async {
    emit(CartLoadingState(
        recentItems: items)); // Emit a loading state while fetching data.
    try {
      final cartPageData = await _cartPageService.fetchCartPageData(items);
      final totalBeforeDiscount =
          cartPageData.cartTotal.totalPriceBeforeDiscount;
      final totalAfterDiscount = cartPageData.cartTotal.totalPriceAfterDiscount;
      emit(CartState(
        items: items,
        totalPriceBeforeDiscount: totalBeforeDiscount,
        totalPriceAfterDiscount: totalAfterDiscount,
        cartPageItems: cartPageData,
      ));
    } catch (error) {
      // Handle errors if necessary.
      emit(state.copyWith(error: 'Failed to fetch cart details.'));
    }
  }

  /// Adds an item to the cart. If the item already exists, increment its quantity.
  Future<void> addToCart(CartItem item) async {
    final existingItemIndex =
        state.items.indexWhere((i) => i.productId == item.productId);

    List<CartItem> updatedItems;
    if (existingItemIndex != -1) {
      final existingItem = state.items[existingItemIndex];
      updatedItems = List<CartItem>.from(state.items);
      updatedItems[existingItemIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + item.quantity,
      );
    } else {
      updatedItems = [...state.items, item];
    }
    await _updateCartState(updatedItems);
  }

  /// Reduces the quantity of an item or removes it completely if the quantity reaches zero.
  Future<void> reduceItemFromCart(int itemId, int quantity) async {
    final existingItemIndex =
        state.items.indexWhere((i) => i.productId == itemId);

    if (existingItemIndex != -1) {
      final existingItem = state.items[existingItemIndex];
      List<CartItem> updatedItems = List<CartItem>.from(state.items);

      if (existingItem.quantity > quantity) {
        updatedItems[existingItemIndex] = existingItem.copyWith(
          quantity: existingItem.quantity - quantity,
        );
      } else {
        updatedItems.removeAt(existingItemIndex);
      }
      await _updateCartState(updatedItems);
    }
  }

  /// Removes an item completely from the cart by its productId.
  Future<void> removeFromCart(int itemId) async {
    final updatedItems =
        state.items.where((i) => i.productId != itemId).toList();
    await _updateCartState(updatedItems);
  }

  /// Clears the cart completely.
  Future<void> clearCart() async {
    await _updateCartState([]);
  }
}
