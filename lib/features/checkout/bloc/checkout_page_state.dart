import 'package:auto_parts_online/features/checkout/checkout_page_model.dart';

abstract class CheckoutPageState {}

class CheckoutPageInitial extends CheckoutPageState {}

class CheckoutPageLoading extends CheckoutPageState {}

class CheckoutPageLoaded extends CheckoutPageState {
  final CheckoutPageModel checkoutPageModel;
  CheckoutPageLoaded({required this.checkoutPageModel});

  CheckoutPageState copyWith({required checkoutPageModel}) {
    return CheckoutPageLoaded(checkoutPageModel: checkoutPageModel);
  }
}

class CheckoutPageError extends CheckoutPageState {
  final String message;
  CheckoutPageError({required this.message});
}
