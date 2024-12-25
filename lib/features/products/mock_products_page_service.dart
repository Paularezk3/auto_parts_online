import 'dart:math';

import 'package:auto_parts_online/features/products/products_page_model.dart';

import '../../core/models/stock_level.dart';

abstract class IMockProductsPageService {
  IMockProductsPageService();

  Future<ProductsPageData> fetchProductsPageData();
}

class MockProductsPageService implements IMockProductsPageService {
  @override
  Future<ProductsPageData> fetchProductsPageData() async {
    await Future.delayed(Duration(seconds: getRandomNumber()));

    CartData cartData = CartData(3, 5400);

    // Generate fake featured products data
    final List<ProductsItems> productsData = [
      ProductsItems(
        productId: 0,
        productName: "Camshaft Column",
        imageUrl: "https://via.placeholder.com/800x400",
        productPrice: 6999.99,
        brandImageUrl: "https://via.placeholder.com/50x50",
        stockLevel: StockLevel.inStock,
      ),
      ProductsItems(
          productId: 2,
          productName: "Balance Bar Link",
          imageUrl: "https://via.placeholder.com/600x400",
          productPrice: 1999.99,
          brandImageUrl: "https://via.placeholder.com/50x50",
          stockLevel: StockLevel.outOfStock),
      ProductsItems(
          productId: 3,
          productName: "Ignition Coil",
          imageUrl: "https://via.placeholder.com/600x300",
          productPrice: 2399.99,
          brandImageUrl: "https://via.placeholder.com/50x50",
          stockLevel: StockLevel.inStock),
      ProductsItems(
          productId: 4,
          productName: "Engine Mount",
          imageUrl: "https://via.placeholder.com/600x300",
          productPrice: 4999.99,
          brandImageUrl: "https://via.placeholder.com/50x50",
          stockLevel: StockLevel.outOfStock),
    ];

    return ProductsPageData(
        cartData: cartData,
        productsItems: productsData,
        filterData: getFilterData());
  }

  FilterData getFilterData() {
    return FilterData(
        categories: ["Accessories", "Engine Parts"],
        lowestPrice: 300,
        highestPrice: 20000,
        brands: ["Mercedes", "Hyundai"],
        brandsModels: {
          "Mercedes": {
            "A-Class": [2010, 2011, 2012],
            "B-Class": [2013, 2014, 2015]
          },
          "Hyundai": {
            "Accent": [2010, 2011, 2012],
            "Elantra": [2013, 2014, 2015]
          },
        });
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
