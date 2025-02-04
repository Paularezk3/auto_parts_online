import 'package:auto_parts_online/features/product_details_page/product_details_page_model.dart';

abstract class ProductDetailsPageState {}

class ProductDetailsPageInitial extends ProductDetailsPageState {}

class ProductDetailsPageLoading extends ProductDetailsPageState {}

class ProductDetailsPageLoaded extends ProductDetailsPageState {
  final ProductDetailsPageData product;
  final int quantityCounter;
  ProductDetailsPageLoaded(this.product, this.quantityCounter);
}

class ProductDetailsPageError extends ProductDetailsPageState {
  final String message;

  ProductDetailsPageError({this.message = "An Error Occurred"});
}
