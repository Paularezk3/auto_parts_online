import '../../checkout/checkout_page_model.dart';
import '../online_payment_page_model.dart';

abstract class OnlinePaymentPageEvent {}

class LoadOnlinePaymentPage extends OnlinePaymentPageEvent {
  final PaymentWay paymentWay;
  final double paymentAmount;
  LoadOnlinePaymentPage(this.paymentWay, this.paymentAmount);
}

class UpdateOnlinePaymentPage extends OnlinePaymentPageEvent {
  final OnlinePaymentPageModel onlinePaymentData;
  UpdateOnlinePaymentPage(this.onlinePaymentData);
}

class LeaveOnlinePaymentPage extends OnlinePaymentPageEvent {}
