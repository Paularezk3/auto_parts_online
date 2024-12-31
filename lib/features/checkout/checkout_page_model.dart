// lib\features\checkout\checkout_page_model.dart

class CheckoutPageModel {
  final int accountPoints;
  final List<AccountAddress> accountAddress;
  final List<String> availableCities;
  final List<String> availableCountries;
  final String? instapayLink;
  // final List<PromocodeDetails>? promocode;
  CheckoutPageModel({
    required this.accountAddress,
    required this.accountPoints,
    required this.availableCities,
    required this.availableCountries,
    // this.promocode,
    this.instapayLink,
  });
}

class AccountAddress {
  final String address;
  final String landMark;
  final String city;
  final String phoneToContact;
  AccountAddress(
      {required this.address,
      required this.city,
      required this.phoneToContact,
      required this.landMark});
}

enum PaymentWay { cash, instapay }
