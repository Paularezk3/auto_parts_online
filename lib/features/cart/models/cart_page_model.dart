import 'promocode_details.dart';

class CartPageModel {
  final List<CartPageItem> cartItems;
  CartTotal cartTotal;
  List<PromocodeDetails> promocodeDetails;
  DeliveryStatus deliveryStatus;

  CartPageModel({
    required this.deliveryStatus,
    required this.cartItems,
    required this.cartTotal,
    required this.promocodeDetails,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'cartItems': cartItems.map((item) => item.toJson()).toList(),
      'cartTotal': cartTotal.toJson(),
      'promocodeDetails':
          promocodeDetails.map((promo) => promo.toJson()).toList(),
      'deliveryStatus': deliveryStatus.toJson()
    };
  }

  // Create from JSON
  factory CartPageModel.fromJson(Map<String, dynamic> json) {
    return CartPageModel(
      deliveryStatus: DeliveryStatus.fromJson(json['deliveryStatus']),
      cartItems: (json['cartItems'] as List<dynamic>)
          .map((item) => CartPageItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      cartTotal: CartTotal.fromJson(json['cartTotal'] as Map<String, dynamic>),
      promocodeDetails: (json['promocodeDetails'] as List<dynamic>)
          .map((promo) =>
              PromocodeDetails.fromJson(promo as Map<String, dynamic>))
          .toList(),
    );
  }
}

class DeliveryStatus {
  final bool isFastDeliveryEnabledFromAdmin;
  bool isFastDelivery;
  double fastDeliveryFees;
  double normalDeliveryFees;

  DeliveryStatus(
      {required this.isFastDeliveryEnabledFromAdmin,
      required this.fastDeliveryFees,
      required this.normalDeliveryFees,
      required this.isFastDelivery});

  get getIsFastDelivery =>
      isFastDeliveryEnabledFromAdmin ? isFastDelivery : false;

  Map<String, dynamic> toJson() {
    return {
      'isFastDeliveryEnabledFromAdmin': isFastDeliveryEnabledFromAdmin,
      'isFastDelivery': isFastDelivery,
      'fastDeliveryFees': fastDeliveryFees,
      'normalDeliveryFees': normalDeliveryFees
    };
  }

  factory DeliveryStatus.fromJson(Map<String, dynamic> json) {
    return DeliveryStatus(
      fastDeliveryFees: json['fastDeliveryFees'] as double,
      normalDeliveryFees: json['normalDeliveryFees'] as double,
      isFastDeliveryEnabledFromAdmin:
          json['isFastDeliveryEnabledFromAdmin'] as bool,
      isFastDelivery: json['isFastDelivery'] as bool,
    );
  }
}

class CartPageItem {
  final int productId;
  final String name;
  final double priceBeforeDiscount;
  final double? priceAfterDiscount;
  final int quantity;

  CartPageItem({
    required this.quantity,
    required this.productId,
    required this.name,
    required this.priceBeforeDiscount,
    this.priceAfterDiscount,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'name': name,
      'priceBeforeDiscount': priceBeforeDiscount,
      'priceAfterDiscount': priceAfterDiscount,
      'quantity': quantity,
    };
  }

  factory CartPageItem.fromJson(Map<String, dynamic> json) {
    return CartPageItem(
      productId: json['productId'] as int,
      name: json['name'] as String,
      priceBeforeDiscount: (json['priceBeforeDiscount'] as num).toDouble(),
      priceAfterDiscount: (json['priceAfterDiscount'] as num?)?.toDouble(),
      quantity: json['quantity'] as int,
    );
  }

  CartPageItem copyWith(
      {int? id,
      String? name,
      double? priceAfterDiscount,
      double? priceBeforeDiscount,
      int? quantity,
      d}) {
    return CartPageItem(
      productId: id ?? productId,
      name: name ?? this.name,
      priceBeforeDiscount: priceBeforeDiscount ?? this.priceBeforeDiscount,
      priceAfterDiscount: priceAfterDiscount ?? this.priceAfterDiscount,
      quantity: quantity ?? this.quantity,
    );
  }
}

class CartTotal {
  final double totalPriceBeforeProductsDiscount;
  final double totalPriceAfterProductsDiscount;
  final double totalOrderDiscounts;
  final double totalDeliveryPrice;
  final double subTotalPrice;
  final int totalNumberOfItems;

  CartTotal({
    required this.totalNumberOfItems,
    required this.totalOrderDiscounts,
    required this.totalDeliveryPrice,
    required this.subTotalPrice,
    required this.totalPriceBeforeProductsDiscount,
    required this.totalPriceAfterProductsDiscount,
  });

  Map<String, dynamic> toJson() {
    return {
      'totalPriceBeforeProductsDiscount': totalPriceBeforeProductsDiscount,
      'totalPriceAfterProductsDiscount': totalPriceAfterProductsDiscount,
      'totalOrderDiscounts': totalOrderDiscounts,
      'totalDeliveryPrice': totalDeliveryPrice,
      'subTotalPrice': subTotalPrice,
      'totalNumberOfItems': totalNumberOfItems,
    };
  }

  factory CartTotal.fromJson(Map<String, dynamic> json) {
    return CartTotal(
      totalPriceBeforeProductsDiscount:
          (json['totalPriceBeforeProductsDiscount'] as num).toDouble(),
      totalPriceAfterProductsDiscount:
          (json['totalPriceAfterProductsDiscount'] as num).toDouble(),
      totalOrderDiscounts: (json['totalOrderDiscounts'] as num).toDouble(),
      totalDeliveryPrice: (json['totalDeliveryPrice'] as num).toDouble(),
      subTotalPrice: (json['subTotalPrice'] as num).toDouble(),
      totalNumberOfItems: json['totalNumberOfItems'] as int,
    );
  }
}
