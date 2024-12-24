// lib\app\routes\navigation_state.dart

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
