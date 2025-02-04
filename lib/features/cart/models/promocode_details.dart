class PromocodeDetails {
  final String promocodeName;
  final double?
      promocodeDiscountPercent; // Null means price discount instead of percent
  final List<String> tags;
  final double? promocodeMaxDiscountPrice;
  final double?
      promocodeDiscountPrice; // Null means percent discount instead of price

  PromocodeDetails({
    required this.promocodeDiscountPercent,
    required this.promocodeDiscountPrice,
    required this.promocodeMaxDiscountPrice,
    required this.tags,
    required this.promocodeName,
  });

  /// Check if the promocode is percentage-based
  bool discountPercentOrPrice() {
    return (promocodeDiscountPercent != null &&
        promocodeMaxDiscountPrice != null);
  }

  /// Calculate percentage discount
  double _discountPercentCalculator(double beforeDiscount) {
    final afterPercent =
        beforeDiscount * (1 - promocodeDiscountPercent! * 0.01);

    return afterPercent < promocodeMaxDiscountPrice!
        ? afterPercent
        : promocodeMaxDiscountPrice!;
  }

  /// Apply the discount to a given price
  double applyDiscount(double beforeDiscount) {
    if (discountPercentOrPrice()) {
      return _discountPercentCalculator(beforeDiscount);
    } else {
      return beforeDiscount - promocodeDiscountPrice!;
    }
  }

  /// Apply all discounts in a list of promotions
  double applyAllDiscounts(
      double priceBeforeDiscount, List<PromocodeDetails> promotions) {
    // Variables to track the highest percentage discount and its max cap
    double highestPercentageDiscount = 0.0;
    double? maxDiscountCap;

    // Find the highest percentage discount and its max cap
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

  /// Convert the object to JSON
  Map<String, dynamic> toJson() {
    return {
      'promocodeName': promocodeName,
      'promocodeDiscountPercent': promocodeDiscountPercent,
      'promocodeMaxDiscountPrice': promocodeMaxDiscountPrice,
      'promocodeDiscountPrice': promocodeDiscountPrice,
      'tags': tags
    };
  }

  /// Create an object from JSON
  factory PromocodeDetails.fromJson(Map<String, dynamic> json) {
    return PromocodeDetails(
      tags: json['tags'] as List<String>,
      promocodeName: json['promocodeName'] as String,
      promocodeDiscountPercent:
          (json['promocodeDiscountPercent'] as num?)?.toDouble(),
      promocodeMaxDiscountPrice:
          (json['promocodeMaxDiscountPrice'] as num?)?.toDouble(),
      promocodeDiscountPrice:
          (json['promocodeDiscountPrice'] as num?)?.toDouble(),
    );
  }
}
