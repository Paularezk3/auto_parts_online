import 'promocode_details.dart';

class CartPageModel {
  final List<CartPageItem> cartItems;
  CartTotal cartTotal;
  List<PromocodeDetails> promocodeDetails;

  CartPageModel(
      {required this.cartItems,
      required this.cartTotal,
      required this.promocodeDetails});

  set setPromocodeDetails(List<PromocodeDetails> newPromo) {
    promocodeDetails = newPromo;
  }

  set setCartTotal(CartTotal cartTotal) {
    this.cartTotal = cartTotal;
  }
}

class CartTotal {
  final double totalPriceBeforeProductsDiscount;
  final double totalPriceAfterProductsDiscount;
  final double totalOrderDiscounts;
  final double totalDeliveryPrice;
  final double subTotalPrice;
  final int totalNumberOfItems;

  CartTotal(
      {required this.totalNumberOfItems,
      required this.totalOrderDiscounts,
      required this.totalDeliveryPrice,
      required this.subTotalPrice,
      required this.totalPriceBeforeProductsDiscount,
      required this.totalPriceAfterProductsDiscount});
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
