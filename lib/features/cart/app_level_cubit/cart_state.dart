import '../models/cart_model.dart';
import '../models/cart_page_model.dart';

class CartState {
  final List<CartItem> items;
  final double totalPriceBeforeDiscount;
  final double totalPriceAfterDiscount;
  final CartPageModel? cartPageItems;
  final String? error;

  CartState({
    this.items = const [],
    this.totalPriceBeforeDiscount = 0.0,
    this.totalPriceAfterDiscount = 0.0,
    this.cartPageItems,
    this.error,
  });

  int get totalItems => items
      .map((item) => item.quantity)
      .fold(0, (total, quantity) => total + quantity);

  CartState copyWith({
    List<CartItem>? items,
    double? totalPriceBeforeDiscount,
    double? totalPriceAfterDiscount,
    CartPageModel? cartPageItems,
    String? error,
  }) {
    return CartState(
      items: items ?? this.items,
      totalPriceBeforeDiscount:
          totalPriceBeforeDiscount ?? this.totalPriceBeforeDiscount,
      totalPriceAfterDiscount:
          totalPriceAfterDiscount ?? this.totalPriceAfterDiscount,
      cartPageItems: cartPageItems ?? this.cartPageItems,
      error: error,
    );
  }
}

class CartLoadingState extends CartState {
  final List<CartItem> recentItems;

  CartLoadingState({required this.recentItems}) : super(items: recentItems);
}
