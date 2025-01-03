// lib\app\routes\navigation_state.dart

import 'package:auto_parts_online/features/cart/models/cart_page_model.dart';

abstract class NavigationState {}

class NavigationHomePageState extends NavigationState {}

class NavigationProductPageState extends NavigationState {}

class NavigationCartPageState extends NavigationState {}

class NavigationAccountPageState extends NavigationState {}

class NavigationSearchPageState extends NavigationState {}

class NavigationProductDetailsPageState extends NavigationState {
  final int productId;

  NavigationProductDetailsPageState(this.productId);

  Map<String, dynamic> toJson() {
    return {'productId': productId};
  }

  static NavigationProductDetailsPageState fromJson(Map<String, dynamic> json) {
    return NavigationProductDetailsPageState(json['productId']);
  }
}

class NavigationCheckoutPageState extends NavigationState {
  final CartPageModel cartDetails;

  NavigationCheckoutPageState(this.cartDetails);

  Map<String, dynamic> toJson() {
    return {'cartDetails': cartDetails.toJson()};
  }

  static NavigationCheckoutPageState fromJson(Map<String, dynamic> json) {
    return NavigationCheckoutPageState(
      CartPageModel.fromJson(json['cartDetails'] as Map<String, dynamic>),
    );
  }
}
