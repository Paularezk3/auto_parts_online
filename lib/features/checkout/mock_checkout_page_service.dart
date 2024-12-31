import 'dart:math';

import 'checkout_page_model.dart';

abstract class IMockCheckoutPageService {
  IMockCheckoutPageService();

  Future<CheckoutPageModel> fetchCheckoutPageData(String accountId);
  // Future<PromocodeDetails?> checkPromoCode(String promocode);
}

class MockCheckoutPageService extends IMockCheckoutPageService {
  @override
  Future<CheckoutPageModel> fetchCheckoutPageData(String accountId) async {
    await Future.delayed(Duration(seconds: getRandomNumber()));
    final data = CheckoutPageModel(
      accountAddress: [
        AccountAddress(
            address: "55 abdel aziz",
            city: "Cairo",
            landMark: "AbdelAziz Stores",
            phoneToContact: "01015811730")
      ],
      accountPoints: 5000,
      availableCities: ["Cairo", "Giza"],
      availableCountries: ["Egypt"],
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
