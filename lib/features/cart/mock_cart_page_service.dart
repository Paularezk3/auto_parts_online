import 'dart:math';

import 'package:auto_parts_online/features/cart/models/cart_model.dart';
import 'package:auto_parts_online/features/cart/models/cart_page_model.dart';

import 'models/promocode_details.dart';

abstract class IMockCartPageService {
  IMockCartPageService();

  Future<CartPageModel> fetchCartPageData(List<CartItem> cartItems);

  Future<PromocodeDetails?> checkPromoCode(String promocode);
  CartTotal updateCartTotal(
      List<CartPageItem> cartItem, List<PromocodeDetails> promocodeDetails);
}

class MockCartPageService implements IMockCartPageService {
  double deliveryFees = 40;

  @override
  Future<CartPageModel> fetchCartPageData(List<CartItem> cartItems) async {
    // Fetch Part
    await Future.delayed(Duration(seconds: getRandomNumber()));
    final List<CartPageItem> cartPageItems = await fetchCartItems(cartItems);

    final promocode = [
      PromocodeDetails(
          promocodeDiscountPercent: 40,
          promocodeDiscountPrice: null,
          promocodeMaxDiscountPrice: 2000,
          promocodeName: "40 OFF"),
      PromocodeDetails(
          promocodeDiscountPercent: null,
          promocodeDiscountPrice: 500,
          promocodeMaxDiscountPrice: null,
          promocodeName: "500 OFF"),
    ];

    // Calculate Part
    final cartTotal =
        calculateCartTotal(cartPageItems, deliveryFees, promocode);

    return CartPageModel(
        cartItems: cartPageItems,
        cartTotal: cartTotal,
        promocodeDetails: promocode);
  }

  @override
  Future<PromocodeDetails?> checkPromoCode(String promocode) async {
    // as if loading from firestore
    await Future.delayed(Duration(seconds: getRandomNumber()));

    // fake data
    if (promocode == "MaxDiscount-40") {
      return PromocodeDetails(
          promocodeDiscountPercent: 40,
          promocodeDiscountPrice: null,
          promocodeMaxDiscountPrice: 2000,
          promocodeName: promocode);
    } else if (promocode == "50EGP") {
      return PromocodeDetails(
          promocodeDiscountPercent: null,
          promocodeDiscountPrice: 50,
          promocodeMaxDiscountPrice: null,
          promocodeName: promocode);
    }
    return null;
  }

  @override
  CartTotal updateCartTotal(
      List<CartPageItem> cartItem, List<PromocodeDetails> promocodeDetails) {
    return calculateCartTotal(cartItem, deliveryFees, promocodeDetails);
  }

  CartTotal calculateCartTotal(List<CartPageItem> cartItem, double deliveryFees,
      List<PromocodeDetails> promocodeDetails) {
    final int totalNumberOfItems = cartItem
        .map(
          (e) => e.quantity,
        )
        .fold(0, (total, item) => total + item);
    double totalPriceAfterProductsDiscount =
        _calculateTotalPriceAfterDiscount(cartItem);
    double totalPriceBeforeProductsDiscount =
        _calculateTotalPriceBeforeDiscount(cartItem);

    final double totalOrderDiscounts = totalPriceBeforeProductsDiscount -
        totalPriceAfterProductsDiscount +
        (totalPriceAfterProductsDiscount -
            promocodeDetails.first.applyAllDiscounts(
                totalPriceAfterProductsDiscount, promocodeDetails));

    final double subTotalPrice = promocodeDetails.first.applyAllDiscounts(
            totalPriceAfterProductsDiscount, promocodeDetails) +
        deliveryFees;

    return CartTotal(
        totalNumberOfItems: totalNumberOfItems,
        totalDeliveryPrice: deliveryFees,
        totalOrderDiscounts: totalOrderDiscounts,
        subTotalPrice: subTotalPrice,
        totalPriceAfterProductsDiscount: totalPriceAfterProductsDiscount,
        totalPriceBeforeProductsDiscount: totalPriceBeforeProductsDiscount);
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

      // Update the quantity with the value from cartItem
      return matchingProduct.copyWith(quantity: cartItem.quantity);
    }).toList();
  }

  int getRandomNumber({int? number}) {
    final random = Random();
    return random.nextInt(
        number ?? 4); // Generates a random number from 0 to 3 (inclusive)
  }
}
