import 'dart:math';

import '../../core/models/stock_level.dart';
import 'home_page_model.dart';

abstract class IMockHomePageService {
  IMockHomePageService();

  Future<HomePageData> fetchHomePageData();
}

class MockHomePageService implements IMockHomePageService {
  @override
  Future<HomePageData> fetchHomePageData() async {
    await Future.delayed(Duration(seconds: getRandomNumber()));

    // Generate fake carousel data
    final List<CarouselData> carouselData = [
      CarouselData("https://via.placeholder.com/600x300", 1),
      CarouselData("https://via.placeholder.com/600x300", 1),
      CarouselData("https://via.placeholder.com/600x300", 1)
    ];

    // Generate fake featured products data
    final List<FeaturedProducts> featuredProductsData = [
      FeaturedProducts(
          productId: 0,
          productName: "Camshaft Column",
          productPrice: 6999.99,
          stockLevel: StockLevel.inStock,
          brandImageUrl: "https://via.placeholder.com/50x50",
          imageUrl: "https://via.placeholder.com/150x150"),
      FeaturedProducts(
          productId: 1,
          productName: "Vacuum Cell",
          productPrice: 899.99,
          stockLevel: StockLevel.limited,
          brandImageUrl: "https://via.placeholder.com/50x50",
          imageUrl: "https://via.placeholder.com/150x150"),
      FeaturedProducts(
          productId: 2,
          productName: "Balance Bar",
          productPrice: 1999.99,
          stockLevel: StockLevel.outOfStock,
          brandImageUrl: "https://via.placeholder.com/50x50",
          imageUrl: "https://via.placeholder.com/150x150")
    ];

    // Generate fake category data
    final List<CategoryData> categoryData = [
      CategoryData("https://via.placeholder.com/800x400", 10),
      CategoryData("https://via.placeholder.com/800x400", 2),
      CategoryData("https://via.placeholder.com/800x400", 1)
    ];

    return HomePageData(
      carousel: carouselData,
      featuredProducts: featuredProductsData,
      categoryData: categoryData,
      noOfItemsInCart: 5,
    );
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
