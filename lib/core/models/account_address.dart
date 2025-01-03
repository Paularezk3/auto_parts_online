class AccountAddress {
  final String address;
  final String landMark;
  final String city;
  final String phoneToContact;
  bool isLastUsed;
  AccountAddress(
      {required this.address,
      required this.city,
      required this.phoneToContact,
      required this.landMark,
      required this.isLastUsed});
}
