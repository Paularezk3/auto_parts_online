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
  final ProductsPageData products; // Add products to this state
  final SelectedFilterData selectedFilterData;

  FilterUIUpdated({
    required this.selectedFilterData,
    required this.products,
  });
}
