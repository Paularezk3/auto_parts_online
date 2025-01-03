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
    final data = CheckoutPageModel(
      paymentWay: PaymentWay.instapay,
      pointValue: 0.05,
      accountAddress: [
        AccountAddress(
            address: "55 abdel aziz",
            city: "Cairo",
            landMark: "AbdelAziz Stores",
            phoneToContact: "01015811730",
            isLastUsed: true)
      ],
      accountPoints: 500,

      availableAdresses: AvailableAdresses(
          availableCities: ["Cairo", "Giza"], availableCountries: ["Egypt"]),
      instapayLink: "https://ipn.eg/S/paularezk/instapay/3HB8En",
      // promocode: PromocodeDetails(promocodeDiscountPercent: promocodeDiscountPercent, promocodeDiscountPrice: promocodeDiscountPrice, promocodeMaxDiscountPrice: promocodeMaxDiscountPrice, promocodeName: promocodeName)
    );
    return data;
  }

  // @override
  // Future<PromocodeDetails?> checkPromoCode(String promocode) async {
  //   // as if loading from firestore
  //   await Future.delayed(Duration(seconds: getRandomNumber()));

  //   // fake data
  //   if (promocode == "MaxDiscount-40") {
  //     return PromocodeDetails(
  //         promocodeDiscountPercent: 40,
  //         promocodeDiscountPrice: null,
  //         promocodeMaxDiscountPrice: 2000,
  //         promocodeName: promocode);
  //   } else if (promocode == "50EGP") {
  //     return PromocodeDetails(
  //         promocodeDiscountPercent: null,
  //         promocodeDiscountPrice: 50,
  //         promocodeMaxDiscountPrice: null,
  //         promocodeName: promocode);
  //   }
  //   return null;
  // }

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
