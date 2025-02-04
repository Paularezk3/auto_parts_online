// lib\features\online_payment\online_payment_page_model.dart

import 'package:auto_parts_online/features/checkout/checkout_page_model.dart';
import 'package:image_picker/image_picker.dart';

class OnlinePaymentPageModel {
  final String? instapayUrl;
  final String? vadafoneCashNumber;
  final String? vadafoneCashNumberLink;
  final PaymentWay paymentWay;
  final double paymentAmount;
  WidgetData widgetData;
  OnlinePaymentPageModel({
    this.instapayUrl,
    this.vadafoneCashNumber,
    this.vadafoneCashNumberLink,
    required this.widgetData,
    required this.paymentWay,
    required this.paymentAmount,
  });

  OnlinePaymentPageModel copyWith(WidgetData? widgetData) {
    return OnlinePaymentPageModel(
      instapayUrl: instapayUrl,
      vadafoneCashNumber: vadafoneCashNumber,
      vadafoneCashNumberLink: vadafoneCashNumberLink,
      widgetData: widgetData ?? this.widgetData,
      paymentWay: paymentWay,
      paymentAmount: paymentAmount,
    );
  }
}

class WidgetData {
  bool isReferenceUploaded;
  XFile? image;
  WidgetData({this.image, this.isReferenceUploaded = false});
}
