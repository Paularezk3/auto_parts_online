abstract class ProductDetailsPageEvent {}

class LoadProductDetailsPage extends ProductDetailsPageEvent {
  final int productId;
  LoadProductDetailsPage(this.productId);
}

class ReturnToInitialState extends ProductDetailsPageEvent {}

class IncrementQuantityCounter extends ProductDetailsPageEvent {}

class DecrementQuantityCounter extends ProductDetailsPageEvent {}
