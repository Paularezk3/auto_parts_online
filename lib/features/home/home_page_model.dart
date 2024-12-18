import 'package:flutter/material.dart';

abstract class HomePageModel {
  final int noOfItemsInCart;

  HomePageModel({required this.noOfItemsInCart});
}

class HomePageData extends HomePageModel {
  final String title;
  final String description;
  final List<HomePageItem> items;
  HomePageData(
      {required this.title,
      required this.description,
      required this.items,
      required super.noOfItemsInCart});
}

class HomePageItem {
  final String title;
  final String subtitle;

  HomePageItem({
    required this.title,
    required this.subtitle,
  });
}

class UserProfile {
  final String userAddress;
  final Image userPhoto;

  UserProfile({
    required this.userAddress,
    required this.userPhoto,
  });
}

class SearchData extends HomePageModel {
  final List<HomePageItem> data;
  SearchData({required this.data, required super.noOfItemsInCart});
}

class SearchTappedDetails extends HomePageModel {
  final List<String> popularSearches;
  SearchTappedDetails(
      {required this.popularSearches, required super.noOfItemsInCart});
}

class SparePartsCategory {
  final String partName;
  SparePartsCategory(this.partName);
}
