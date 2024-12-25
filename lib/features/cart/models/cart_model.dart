// lib/features/cart/models/cart_item.dart
class CartItem {
  final int id;
  final String name;
  final double price;
  final int quantity;

  CartItem({
    required this.quantity,
    required this.id,
    required this.name,
    required this.price,
  });

  CartItem copyWith({
    int? id,
    String? name,
    double? price,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }
}
