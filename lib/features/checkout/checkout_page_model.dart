// lib\features\checkout\checkout_page_model.dart

import '../../core/models/account_address.dart';

class CheckoutPageModel {
  final int accountPoints;
  final double pointValue;
  final List<AccountAddress> accountAddress;
  final String? instapayLink;
  final AvailableAdresses availableAdresses;
  PaymentWay paymentWay;
  CheckoutPageModel({
    required this.accountAddress,
    required this.pointValue,
    required this.availableAdresses,
    required this.accountPoints,
    this.instapayLink,
    required this.paymentWay,
  });

  CheckoutPageModel copyWith({
    int? accountPoints,
    List<AccountAddress>? accountAddress,
    String? instapayLink,
    AvailableAdresses? availableAdresses,
    PaymentWay? paymentWay,
    double? pointValue,
  }) {
    return CheckoutPageModel(
      pointValue: pointValue ?? this.pointValue,
      accountPoints: accountPoints ?? this.accountPoints,
      accountAddress: accountAddress ?? this.accountAddress,
      instapayLink: instapayLink ?? this.instapayLink,
      availableAdresses: availableAdresses ?? this.availableAdresses,
      paymentWay: paymentWay ?? this.paymentWay,
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

enum PaymentWay { cash, instapay, vodafoneCash }
