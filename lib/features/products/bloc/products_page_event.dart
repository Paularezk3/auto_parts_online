class ProductsPageEvent {}

class LoadProductsPage extends ProductsPageEvent {}

class UpdateFilterUI extends ProductsPageEvent {
  final List<String>? selectedCategories;
  final bool isPriceRangeOn;
  final Set<int>? priceRange;
  final String? brandName;
  final String? modelName;
  final int? year;
  UpdateFilterUI(
      {this.brandName,
      required this.isPriceRangeOn,
      this.modelName,
      this.priceRange,
      this.selectedCategories,
      this.year});
}
