import 'dart:math';

import 'package:auto_parts_online/core/utils/hive_helper.dart';

import 'bloc/search_page_state.dart';
import 'search_page_model.dart';

abstract class IMockSearchPageService {
  IMockSearchPageService();

  Future<SearchBarActiveWithoutTyping> fetchSearchEmptyFieldDetails(
      HiveHelper hivehelper);

  Future<List<ProductCardDetails>> fetchSearchResultDetails();
}

class MockSearchPageService implements IMockSearchPageService {
  @override
  Future<SearchBarActiveWithoutTyping> fetchSearchEmptyFieldDetails(
      HiveHelper hiveHelper) async {
    await Future.delayed(Duration(seconds: getRandomNumber()));
    return SearchBarActiveWithoutTyping(
      recentSearches: hiveHelper.getRecentSearches(),
      searchTappedDetails: SearchTappedDetails(
        popularSearches: List.generate(
            6,
            (i) => i % 3 == 0
                ? "This is long Popular Searches $i"
                : "Popular adsdasddsa$i"),
      ),
      sparePartsCategorySuggestions:
          List.generate(7, (i) => SparePartsCategory("Part Suggestion $i")),
    );
  }

  @override
  Future<List<ProductCardDetails>> fetchSearchResultDetails() async {
    await Future.delayed(Duration(seconds: getRandomNumber()));
    return List.generate(
        getRandomNumber(number: 20),
        (index) => ProductCardDetails(
            carBrandName: "Mercedes $index",
            productImage:
                "https://www.mercedes-benz.com.eg/content/dam/hq/passengercars/cars/bodytypes-landingpages/compact-cars/modeloverview/07-2023/images/mercedes-benz-compact-cars-modeloverview-692x392-07-2023.png",
            productPrice: getRandomDouble(index),
            stockAvailability: "About to Finish",
            productName: "Stabilizer Bar Link"));
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
