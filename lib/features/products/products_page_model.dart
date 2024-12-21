import '../../common/models/stock_level.dart';

class ProductsPageData {
  final CartData cartData;
  final List<ProductsItems> productsItems;
  ProductsPageData({required this.cartData, required this.productsItems});
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

class CartData {
  final int noOfItemsInCart;
  final double cartAmount;
  CartData(this.noOfItemsInCart, this.cartAmount);
}
