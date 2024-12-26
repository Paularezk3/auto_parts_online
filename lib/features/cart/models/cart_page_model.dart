class CartPageModel {
  final List<CartPageItem> cartItems;
  final CartTotal cartTotal;
  CartPageModel({required this.cartItems, required this.cartTotal});
}

class CartTotal {
  final double totalPriceBeforeDiscount;
  final double totalPriceAfterDiscount;
  final int totalNumberOfItems;

  CartTotal(
      {required this.totalNumberOfItems,
      required this.totalPriceAfterDiscount,
      required this.totalPriceBeforeDiscount});
}

class CartPageItem {
  final int productId;
  final String name;
  final double priceBeforeDiscount;
  final double? priceAfterDiscount;
  final int quantity;

  CartPageItem(
      {required this.quantity,
      required this.productId,
      required this.name,
      required this.priceBeforeDiscount,
      this.priceAfterDiscount});

  CartPageItem copyWith(
      {int? id,
      String? name,
      double? priceAfterDiscount,
      double? priceBeforeDiscount,
      int? quantity,
      d}) {
    return CartPageItem(
      productId: id ?? productId,
      name: name ?? this.name,
      priceBeforeDiscount: priceBeforeDiscount ?? this.priceBeforeDiscount,
      priceAfterDiscount: priceAfterDiscount ?? this.priceAfterDiscount,
      quantity: quantity ?? this.quantity,
    );
  }
}
