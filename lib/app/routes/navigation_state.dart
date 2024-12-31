// lib\app\routes\navigation_state.dart

import '../../features/cart/models/cart_model.dart';

abstract class NavigationState {}

class NavigationHomePageState extends NavigationState {}

class NavigationProductPageState extends NavigationState {}

class NavigationCartPageState extends NavigationState {}

class NavigationAccountPageState extends NavigationState {}

class NavigationSearchPageState extends NavigationState {}

class NavigationProductDetailsPageState extends NavigationState {
  final int productId;

  NavigationProductDetailsPageState(this.productId);

  Map<String, dynamic> toJson() {
    return {'productId': productId};
  }

  static NavigationProductDetailsPageState fromJson(Map<String, dynamic> json) {
    return NavigationProductDetailsPageState(json['productId']);
  }
}

class NavigationCheckoutPageState extends NavigationState {
  final List<CartItem> items;

  NavigationCheckoutPageState(this.items);

  Map<String, dynamic> toJson() {
    return {
      'cartProducts': items
          .map((item) => "${item.productId}```${item.quantity}")
          .join("{{{"),
    };
  }

  static NavigationCheckoutPageState fromJson(Map<String, dynamic> json) {
    if (json['cartProducts'] == null || json['cartProducts'] is! String) {
      throw FormatException("Invalid cartProducts format in JSON");
    }

    final cartProductsString = json['cartProducts'] as String;
    final cartItems = cartProductsString
        .split("{{{")
        .where((item) => item.contains("```"))
        .map((item) {
      final idAndQuantity = item.split("```");
      if (idAndQuantity.length != 2) {
        throw FormatException("Invalid CartItem format: $item");
      }
      return CartItem(
        productId: int.parse(idAndQuantity[0]),
        quantity: int.parse(idAndQuantity[1]),
      );
    }).toList();

    return NavigationCheckoutPageState(cartItems);
  }
}
