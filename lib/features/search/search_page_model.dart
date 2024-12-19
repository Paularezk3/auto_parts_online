class SearchPageModel {}

class SearchTappedDetails extends SearchPageModel {
  final List<String> popularSearches;
  SearchTappedDetails({required this.popularSearches});
}

class ProductCardDetails {
  final String productImage;
  final String productName;
  final double productPrice;
  final String stockAvailability;
  final String carBrandName;
  ProductCardDetails(
      {required this.carBrandName,
      required this.productImage,
      required this.productPrice,
      required this.stockAvailability,
      required this.productName});
}

class SparePartsCategory {
  final String partName;
  SparePartsCategory(this.partName);
}
