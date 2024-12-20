import 'package:auto_parts_online/common/models/stock_level.dart';

class SearchPageModel {}

class SearchTappedDetails extends SearchPageModel {
  final List<String> popularSearches;
  SearchTappedDetails({required this.popularSearches});
}

class ProductCardDetails {
  final String productImage;
  final String productName;
  final double productPrice;
  final StockLevel stockAvailability;
  final String carBrandImage;
  ProductCardDetails(
      {required this.carBrandImage,
      required this.productImage,
      required this.productPrice,
      required this.stockAvailability,
      required this.productName});
}

class SparePartsCategory {
  final String partName;
  SparePartsCategory(this.partName);
}
