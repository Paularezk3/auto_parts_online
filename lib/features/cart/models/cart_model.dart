// lib/features/cart/models/cart_item.dart
class CartItem {
  final int productId;
  final int quantity;

  CartItem({
    required this.quantity,
    required this.productId,
  });

  CartItem copyWith({
    int? id,
    String? name,
    double? price,
    int? quantity,
  }) {
    return CartItem(
      productId: id ?? productId,
      quantity: quantity ?? this.quantity,
    );
  }
}
