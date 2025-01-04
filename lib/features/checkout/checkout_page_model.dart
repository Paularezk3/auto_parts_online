// lib\features\checkout\checkout_page_model.dart

import '../../core/models/account_address.dart';

class CheckoutPageModel {
  final int accountPoints;
  final double pointValue;
  final List<AccountAddress> accountAddress;
  final AvailableAdresses availableAdresses;
  final CheckOutWidgetData widgetData;
  CheckoutPageModel({
    required this.widgetData,
    required this.accountAddress,
    required this.pointValue,
    required this.availableAdresses,
    required this.accountPoints,
  });

  CheckoutPageModel copyWith({
    int? accountPoints,
    List<AccountAddress>? accountAddress,
    AvailableAdresses? availableAdresses,
    double? pointValue,
    CheckOutWidgetData? widgetData,
  }) {
    return CheckoutPageModel(
      pointValue: pointValue ?? this.pointValue,
      accountPoints: accountPoints ?? this.accountPoints,
      accountAddress: accountAddress ?? this.accountAddress,
      availableAdresses: availableAdresses ?? this.availableAdresses,
      widgetData: widgetData ?? this.widgetData,
    );
  }
}

class AvailableAdresses {
  final List<String> availableCities;
  final List<String> availableCountries;
  AvailableAdresses({
    required this.availableCities,
    required this.availableCountries,
  });
}

class CheckOutWidgetData {
  final double subTotal;
  PaymentWay? paymentWay;

  final double totalAfterPointsDiscount;
  bool isSliderProcessing;
  CheckOutWidgetData({
    required this.totalAfterPointsDiscount,
    required this.paymentWay,
    required this.subTotal,
    this.isSliderProcessing = false,
  });

  CheckOutWidgetData copyWith({
    double? subTotal,
    PaymentWay? paymentWay,
    double? totalAfterPointsDiscount,
    bool? isSliderProcessing,
  }) {
    return CheckOutWidgetData(
      subTotal: subTotal ?? this.subTotal,
      paymentWay: paymentWay ?? this.paymentWay,
      totalAfterPointsDiscount:
          totalAfterPointsDiscount ?? this.totalAfterPointsDiscount,
      isSliderProcessing: isSliderProcessing ?? this.isSliderProcessing,
    );
  }
}

enum PaymentWay { cash, instapay, vodafoneCash }
