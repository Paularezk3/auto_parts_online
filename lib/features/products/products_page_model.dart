import '../../common/models/stock_level.dart';

class ProductsPageData {
  final CartData cartData;
  final List<ProductsItems> productsItems;
  final FilterData filterData;
  ProductsPageData(
      {required this.cartData,
      required this.productsItems,
      required this.filterData});
}

class ProductsItems {
  final String productName;
  final double productPrice;
  final StockLevel stockLevel;
  final String imageUrl;
  final String brandImageUrl;
  ProductsItems(
      {required this.productName,
      required this.productPrice,
      required this.stockLevel,
      required this.brandImageUrl,
      required this.imageUrl});
}

class FilterData {
  final List<String> categories;
  final double lowestPrice;
  final double highestPrice;
  final List<String> brands;
  final Map<String, Map<String, List<int>>>
      brandsModels; // Brand -> Model -> Years

  FilterData({
    required this.categories,
    required this.lowestPrice,
    required this.highestPrice,
    required this.brands,
    required this.brandsModels,
  });

  // Get models for a specific brand
  List<String> getModelsForBrand(String brand) {
    return brandsModels[brand]?.keys.toList() ?? [];
  }

  // Get years for a specific model
  List<String> getYearsForModel(String brand, String model) {
    return brandsModels[brand]?[model]!
            .map((year) => year.toString())
            .toList() ??
        <String>[];
  }
}

class SelectedFilterData {
  final List<String> selectedCategories;
  final bool isPriceRangeOn;
  final double? selectedLowestPrice;
  final double? selectedHighestPrice;
  final String? selectedBrand;
  final String? selectedModel;
  final int? selectedYear;

  SelectedFilterData({
    required this.selectedCategories,
    required this.isPriceRangeOn,
    required this.selectedLowestPrice,
    required this.selectedHighestPrice,
    required this.selectedBrand,
    required this.selectedModel,
    required this.selectedYear,
  });
}

class CartData {
  final int noOfItemsInCart;
  final double cartAmount;
  CartData(this.noOfItemsInCart, this.cartAmount);
}
