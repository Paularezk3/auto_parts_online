import 'dart:math';

import 'package:auto_parts_online/features/products/products_page_model.dart';

import '../../common/models/stock_level.dart';

abstract class IMockProductsPageService {
  IMockProductsPageService();

  Future<ProductsPageData> fetchProductsPageData();
}

class MockProductsPageService implements IMockProductsPageService {
  @override
  Future<ProductsPageData> fetchProductsPageData() async {
    await Future.delayed(Duration(seconds: getRandomNumber()));

    // Generate fake carousel data
    CartData cartData = CartData(3, 5400);

    // Generate fake featured products data
    final List<ProductsItems> productsData = [
      ProductsItems(
        productName: "Engine Mount",
        imageUrl: "https://via.placeholder.com/800x400",
        productPrice: 5000,
        brandImageUrl: "https://via.placeholder.com/50x50",
        stockLevel: StockLevel.inStock,
      ),
      ProductsItems(
          productName: "Balance Bar Link",
          imageUrl: "https://via.placeholder.com/600x400",
          productPrice: 2000,
          brandImageUrl: "https://via.placeholder.com/50x50",
          stockLevel: StockLevel.limited),
      ProductsItems(
          productName: "Ignition Coil",
          imageUrl: "https://via.placeholder.com/600x300",
          productPrice: 2400,
          brandImageUrl: "https://via.placeholder.com/50x50",
          stockLevel: StockLevel.outOfStock),
    ];

    return ProductsPageData(cartData: cartData, productsItems: productsData);
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
