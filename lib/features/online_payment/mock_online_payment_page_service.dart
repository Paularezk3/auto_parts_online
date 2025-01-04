import 'dart:math';

import 'package:auto_parts_online/features/online_payment/online_payment_page_model.dart';

import '../checkout/checkout_page_model.dart';

abstract class IMockOnlinePaymentPage {
  IMockOnlinePaymentPage();
  Future<OnlinePaymentPageModel> loadOnlinePaymentPage(
      PaymentWay paymentWay, double paymentAmount);
}

class MockOnlinePaymentPageService extends IMockOnlinePaymentPage {
  @override
  Future<OnlinePaymentPageModel> loadOnlinePaymentPage(
      PaymentWay paymentWay, double paymentAmount) async {
    await Future.delayed(Duration(seconds: getRandomNumber()));
    if (PaymentWay.instapay == paymentWay) {
      return OnlinePaymentPageModel(
          widgetData: WidgetData(isReferenceUploaded: false, image: null),
          paymentWay: paymentWay,
          paymentAmount: paymentAmount,
          instapayUrl: 'https://ipn.eg/S/paularezk/instapay/3HB8En');
    } else if (PaymentWay.vodafoneCash == paymentWay) {
      final mobileNumber = '01015811730';
      return OnlinePaymentPageModel(
          widgetData: WidgetData(isReferenceUploaded: false),
          paymentWay: paymentWay,
          paymentAmount: paymentAmount,
          vadafoneCashNumberLink:
              "tel:*9*7*$mobileNumber*${paymentAmount.ceil()}%23",
          vadafoneCashNumber: mobileNumber);
    }
    throw Exception('Payment way not supported');
  }

  int getRandomNumber({int? number}) {
    final random = Random();
    return random.nextInt(
        number ?? 4); // Generates a random number from 0 to 3 (inclusive)
  }
}
