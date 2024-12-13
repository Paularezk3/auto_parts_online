import 'package:flutter/material.dart';

class HomePageModel {
  final String title;
  final String description;
  final List<HomePageItem> items;
  final int noOfItemsInCart;

  HomePageModel(
      {required this.title,
      required this.description,
      required this.items,
      required this.noOfItemsInCart});
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
