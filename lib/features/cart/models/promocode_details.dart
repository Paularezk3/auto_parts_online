class PromocodeDetails {
  final String promocodeName;
  final double?
      promocodeDiscountPercent; // if null therefore it's price not percent discount
  final double? promocodeMaxDiscountPrice;
  final double?
      promocodeDiscountPrice; // if null therefore it's percent discount not price
  PromocodeDetails(
      {required this.promocodeDiscountPercent,
      required this.promocodeDiscountPrice,
      required this.promocodeMaxDiscountPrice,
      required this.promocodeName});

  bool discountPercentOrPrice() {
    return (promocodeDiscountPercent != null &&
        promocodeMaxDiscountPrice != null);
  }

  double _discountPercentCalculator(double beforeDiscount) {
    final afterPercent =
        beforeDiscount * (1 - promocodeDiscountPercent! * 0.01);

    return afterPercent < promocodeMaxDiscountPrice!
        ? afterPercent
        : promocodeMaxDiscountPrice!;
  }

  double applyDiscount(double beforeDiscount) {
    if (discountPercentOrPrice()) {
      return _discountPercentCalculator(beforeDiscount);
    } else {
      return promocodeDiscountPrice!;
    }
  }

  double applyAllDiscounts(
      double priceBeforeDiscount, List<PromocodeDetails> promotions) {
    // Variables to track the highest percentage discount and its max cap
    double highestPercentageDiscount = 0.0;
    double? maxDiscountCap;

    // Iterate to find the highest percentage discount and its max cap
    for (var promo in promotions) {
      if (promo.promocodeDiscountPercent != null &&
          promo.promocodeMaxDiscountPrice != null) {
        if (promo.promocodeDiscountPercent! > highestPercentageDiscount) {
          highestPercentageDiscount = promo.promocodeDiscountPercent!;
          maxDiscountCap = promo.promocodeMaxDiscountPrice;
        }
      }
    }

    // Calculate the price after applying the highest percentage discount
    double priceAfterPercentageDiscount = priceBeforeDiscount;
    if (highestPercentageDiscount > 0) {
      double calculatedDiscount =
          priceBeforeDiscount * (highestPercentageDiscount / 100);
      double effectiveDiscount =
          maxDiscountCap != null && calculatedDiscount > maxDiscountCap
              ? maxDiscountCap
              : calculatedDiscount;
      priceAfterPercentageDiscount -= effectiveDiscount;
    }

    // Calculate the total fixed discount
    double totalFixedDiscount = promotions
        .where((promo) => promo.promocodeDiscountPrice != null)
        .map((promo) => promo.promocodeDiscountPrice!)
        .fold(0.0, (sum, discount) => sum + discount);

    // Apply the fixed discounts
    double finalPrice = priceAfterPercentageDiscount - totalFixedDiscount;

    // Ensure the price is not negative
    return finalPrice < 0 ? 0 : finalPrice;
  }
}
