import 'dart:math';

import 'package:auto_parts_online/features/cart/models/cart_model.dart';
import 'package:auto_parts_online/features/cart/models/cart_page_model.dart';

abstract class IMockCartPageService {
  IMockCartPageService();

  Future<CartPageModel> fetchCartPageData(List<CartItem> cartItems);

  // Future<double> fetchTotalPriceBeforeDiscount(List<CartItem> cartItems);
  // Future<double> fetchTotalPriceAfterDiscount(List<CartItem> cartItems);
}

class MockCartPageService implements IMockCartPageService {
  @override
  Future<CartPageModel> fetchCartPageData(List<CartItem> cartItems) async {
    // Fetch Part
    await Future.delayed(Duration(seconds: getRandomNumber()));
    final List<CartPageItem> cartPageItems = await fetchCartItems(cartItems);

    // Calculate Part
    final cartTotal = calculateCartTotal(cartPageItems);

    return CartPageModel(cartItems: cartPageItems, cartTotal: cartTotal);
  }

  // @override
  // Future<double> fetchTotalPriceBeforeDiscount(List<CartItem> cartItems) async {
  //   // Fetch Part
  //   await Future.delayed(Duration(seconds: getRandomNumber()));
  //   final List<CartPageItem> cartPageItems = await fetchCartItems(cartItems);

  //   return _calculateTotalPriceBeforeDiscount(cartPageItems);
  // }

  // @override
  // Future<double> fetchTotalPriceAfterDiscount(List<CartItem> cartItems) async {
  //   // Fetch Part
  //   await Future.delayed(Duration(seconds: getRandomNumber()));
  //   final List<CartPageItem> cartPageItems = await fetchCartItems(cartItems);

  //   return _calculateTotalPriceBeforeDiscount(cartPageItems);
  // }

  CartTotal calculateCartTotal(List<CartPageItem> cartItem) {
    final int totalNumberOfItems = cartItem
        .map(
          (e) => e.quantity,
        )
        .fold(0, (total, item) => total + item);
    double totalPriceAfterDiscount =
        _calculateTotalPriceAfterDiscount(cartItem);
    double totalPriceBeforeDiscount =
        _calculateTotalPriceBeforeDiscount(cartItem);

    return CartTotal(
        totalNumberOfItems: totalNumberOfItems,
        totalPriceAfterDiscount: totalPriceAfterDiscount,
        totalPriceBeforeDiscount: totalPriceBeforeDiscount);
  }

  double _calculateTotalPriceBeforeDiscount(List<CartPageItem> cartItem) {
    return cartItem
        .map((item) => item.quantity * (item.priceBeforeDiscount))
        .fold(0.0, (total, item) => total + item);
  }

  double _calculateTotalPriceAfterDiscount(List<CartPageItem> cartItem) {
    return cartItem
        .map((item) =>
            item.quantity *
            (item.priceAfterDiscount ?? item.priceBeforeDiscount))
        .fold(0.0, (total, item) => total + item);
  }

  Future<List<CartPageItem>> fetchCartItems(List<CartItem> cartItems) async {
    List<CartPageItem> products = [
      CartPageItem(
        name: "Camshaft Column",
        priceBeforeDiscount: 7999.99,
        priceAfterDiscount: 6999.99,
        quantity: 0,
        productId: 0,
      ),
      CartPageItem(
        quantity: 0,
        productId: 1,
        name: "Vacuum Cell",
        priceBeforeDiscount: 999.99,
        priceAfterDiscount: 899.99,
      ),
      CartPageItem(
        quantity: 0,
        productId: 3,
        name: "Ignition Coil",
        priceBeforeDiscount: 2399.99,
      ),
    ];

    return cartItems.map((cartItem) {
      // Find the matching product
      final matchingProduct = products.firstWhere(
        (product) => product.productId == cartItem.productId,
      );
      // orElse: () => CartPageItem(
      //   // Default empty product if no match is found
      //   name: "Unknown Product",
      //   priceBeforeDiscount: 0,
      //   quantity: 0,
      //   productId: cartItem.productId,
      // ));

      // Update the quantity with the value from cartItem
      return matchingProduct.copyWith(quantity: cartItem.quantity);
    }).toList();
  }

  int getRandomNumber({int? number}) {
    final random = Random();
    return random.nextInt(
        number ?? 4); // Generates a random number from 0 to 3 (inclusive)
  }

  double getRandomDouble(num? number) {
    final random = Random().nextDouble() * (number ?? 4);
    return random; // Generates a random number from 0 to 3 (inclusive)
  }
}
