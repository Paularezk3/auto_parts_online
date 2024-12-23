import 'package:auto_parts_online/features/products/products_page_model.dart';

class ProductsPageEvent {}

class LoadProductsPage extends ProductsPageEvent {}

class UpdateFilterUI extends ProductsPageEvent {
  final SelectedFilterData selectedFilterData;
  final ProductsPageData productsPageData;
  UpdateFilterUI(
      {required this.productsPageData, required this.selectedFilterData});
}
