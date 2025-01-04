class AccountAddress {
  final int addressId;
  final String address;
  final String landMark;
  final String city;
  final String phoneToContact;
  bool isLastUsed;
  AccountAddress(
      {required this.addressId,
      required this.address,
      required this.city,
      required this.phoneToContact,
      required this.landMark,
      required this.isLastUsed});

  AccountAddress copyWith(
      {address, city, phoneToContact, landMark, isLastUsed}) {
    return AccountAddress(
      addressId: addressId,
      address: address ?? this.address,
      city: city ?? this.city,
      phoneToContact: phoneToContact ?? this.phoneToContact,
      landMark: landMark ?? this.landMark,
      isLastUsed: isLastUsed ?? this.isLastUsed,
    );
  }
}
