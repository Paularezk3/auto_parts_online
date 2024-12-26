// lib/features/cart/bloc/cart_page_event.dart
import '../models/cart_model.dart';

abstract class CartPageEvent {}

class LoadCartPage extends CartPageEvent {}

class AddItemToCart extends CartPageEvent {
  final CartItem item;

  AddItemToCart({required this.item});
}

class RemoveItemFromCart extends CartPageEvent {
  final int itemId;

  RemoveItemFromCart({required this.itemId});
}

class ClearCart extends CartPageEvent {}

class ReduceItemFromCart extends CartPageEvent {
  final int itemId;
  final int quantity;
  ReduceItemFromCart({required this.itemId, required this.quantity});
}

class LeaveCartPage extends CartPageEvent {}
