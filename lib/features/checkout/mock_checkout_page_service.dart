import 'dart:math';

import 'package:auto_parts_online/features/cart/models/cart_page_model.dart';

import '../../core/models/account_address.dart';
import 'checkout_page_model.dart';

abstract class IMockCheckoutPageService {
  IMockCheckoutPageService();

  Future<CheckoutPageModel> fetchCheckoutPageData(
      String accountId, CartPageModel cartDetails);
  // Future<PromocodeDetails?> checkPromoCode(String promocode);
}

class MockCheckoutPageService extends IMockCheckoutPageService {
  @override
  Future<CheckoutPageModel> fetchCheckoutPageData(
      String accountId, CartPageModel cartDetails) async {
    await Future.delayed(Duration(seconds: getRandomNumber()));
    const int accountPoints = 520;
    const double pointValue = 0.05;
    final data = CheckoutPageModel(
      widgetData: CheckOutWidgetData(
        isSliderProcessing: false,
        subTotal: cartDetails.cartTotal.subTotalPrice,
        totalAfterPointsDiscount:
            cartDetails.cartTotal.subTotalPrice - (accountPoints * pointValue),
        paymentWay: null,
      ),
      pointValue: pointValue,
      accountAddress: [
        AccountAddress(
            addressId: 1,
            address: "55 abdel aziz",
            city: "Cairo",
            landMark: "AbdelAziz Stores",
            phoneToContact: "01015811730",
            isLastUsed: true)
      ],
      accountPoints: accountPoints,
      availableAdresses: AvailableAdresses(
          availableCities: ["Cairo", "Giza"], availableCountries: ["Egypt"]),
    );
    return data;
  }

  int getRandomNumber({int? number}) {
    final random = Random();
    return random.nextInt(
        number ?? 4); // Generates a random number from 0 to 3 (inclusive)
  }

  double getRandomDouble(num? number) {
    final random = Random().nextDouble() * (number ?? 4);
    return random; // Generates a random number from 0 to 3 (inclusive)
  }
}
