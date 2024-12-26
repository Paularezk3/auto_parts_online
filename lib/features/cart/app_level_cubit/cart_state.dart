import '../models/cart_model.dart';

class CartState {
  final List<CartItem> items;

  CartState({this.items = const []});

  int get totalItems => items
      .map((item) => item.quantity)
      .fold(0, (total, quantity) => total + quantity);

  double get totalPrice => items
      .map((item) => item.quantity * item.price)
      .fold(0, (total, item) => total + item);

  CartState copyWith({List<CartItem>? items}) {
    return CartState(
      items: items ?? this.items,
    );
  }
}
