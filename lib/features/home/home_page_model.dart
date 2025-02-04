// lib\features\home\home_page_model.dart

import 'package:auto_parts_online/core/models/stock_level.dart';
import 'package:flutter/material.dart';

abstract class HomePageModel {
  final int noOfItemsInCart;

  HomePageModel({required this.noOfItemsInCart});
}

class HomePageData extends HomePageModel {
  final List<CarouselData>? carousel;
  final List<FeaturedProducts> featuredProducts;
  final List<CategoryData> categoryData;
  HomePageData(
      {this.carousel,
      required this.featuredProducts,
      required this.categoryData,
      required super.noOfItemsInCart});
}

class UserProfile {
  final String userAddress;
  final Image userPhoto;

  UserProfile({
    required this.userAddress,
    required this.userPhoto,
  });
}

class CategoryData {
  final String imageUrl;
  final int categoryId;
  final String categoryName;
  CategoryData(this.imageUrl, this.categoryId, this.categoryName);
}

class CarouselData {
  final String imageUrl;
  final int productId;
  CarouselData(this.imageUrl, this.productId);
}

class FeaturedProducts {
  final int productId;
  final String productName;
  final double productPrice;
  final StockLevel stockLevel;
  final String imageUrl;
  final String brandImageUrl;
  FeaturedProducts(
      {required this.productId,
      required this.productName,
      required this.productPrice,
      required this.stockLevel,
      required this.brandImageUrl,
      required this.imageUrl});
}
