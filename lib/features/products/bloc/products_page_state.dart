import '../products_page_model.dart';

class ProductsPageState {}

class ProductsPageInitial extends ProductsPageState {}

class ProductsPageLoading extends ProductsPageState {}

class ProductsPageLoaded extends ProductsPageState {
  final ProductsPageData products;
  ProductsPageLoaded(this.products);
}

class ProductsPageError extends ProductsPageState {}

class FilterUIUpdated extends ProductsPageState {
  final bool isPriceRangeOn;
  final List<String>? selectedCategories;
  final Set<int>? priceRange;
  final String? brandName;
  final String? modelName;
  final int? year;
  FilterUIUpdated(
      {required this.isPriceRangeOn,
      this.brandName,
      this.modelName,
      this.priceRange,
      this.selectedCategories,
      this.year});
}
