import 'package:auto_parts_online/core/models/guarantee_level.dart';
import 'package:auto_parts_online/core/models/stock_level.dart';

class ProductDetailsPageData {
  final int productId;
  final String title;
  final String productName;
  final String description;
  final List<CarouselData> carousel;
  final GuaranteeLevel guaranteeLevel;
  final StockLevel stockLevel;

  final double? discountedPrice;
  final double originalPrice;
  final List<String> compatibility;
  final List<Review>? reviews;

  ProductDetailsPageData(
      {required this.title,
      required this.productName,
      required this.compatibility,
      this.reviews,
      required this.productId,
      required this.description,
      required this.originalPrice,
      this.discountedPrice,
      required this.carousel,
      required this.stockLevel,
      required this.guaranteeLevel});

  get id => null;
}

class CarouselData {
  final String imageUrl;

  CarouselData(this.imageUrl);
}

class Review {
  final String customerName;
  final String comment;

  Review({required this.customerName, required this.comment});
}
