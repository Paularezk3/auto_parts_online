import 'package:auto_parts_online/features/checkout/checkout_page_model.dart';

import '../../../core/models/account_address.dart';
import '../../cart/models/cart_page_model.dart';

abstract class CheckoutPageEvent {}

class LoadCheckoutPage extends CheckoutPageEvent {
  final CartPageModel cartDetails;
  LoadCheckoutPage({required this.cartDetails});
}

class UpdateAddress extends CheckoutPageEvent {
  final AccountAddress address;
  UpdateAddress({required this.address});
}

class UpdatePaymentMethod extends CheckoutPageEvent {
  final PaymentWay paymentWay;
  UpdatePaymentMethod({required this.paymentWay});
}

class UpdatePoints extends CheckoutPageEvent {
  final int pointsUsed;

  UpdatePoints({required this.pointsUsed});
}
