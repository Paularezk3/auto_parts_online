import 'package:auto_parts_online/features/cart/models/cart_page_model.dart';
import 'package:flutter/material.dart';

import '../../../common/widgets/skeleton_loader.dart';
import '../../../core/constants/app_colors.dart';

class OrderDetailsWidget extends StatelessWidget {
  final bool isLoading;
  final CartPageModel cartPageData;

  const OrderDetailsWidget({
    required this.cartPageData,
    required this.isLoading,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!isLoading) ...[
          _rowForTexts(
            "Items",
            "E£ ${cartPageData.cartTotal.totalPriceBeforeProductsDiscount.toStringAsFixed(2)}",
            context,
            false,
            false,
          ),
          const SizedBox(height: 10),
          _deliveryFeesRow(context, cartPageData.cartTotal.totalDeliveryPrice),
          const SizedBox(height: 10),
          _rowForTexts(
            "Discount",
            "E£ -${cartPageData.cartTotal.totalOrderDiscounts.toStringAsFixed(2)}",
            context,
            true,
            true,
            isDiscount: true,
          ),
          const Divider(
            indent: 15,
            endIndent: 15,
            thickness: 1,
            color: AppColors.primaryGrey,
          ),
          _rowForTexts(
            "Sub-Total",
            "E£ ${cartPageData.cartTotal.subTotalPrice.toStringAsFixed(2)}",
            context,
            true,
            true,
            isSubtotal: true,
          ),
        ],
        if (isLoading) ...[
          _rowForTexts("Items", "E£ ", context, false, false, isLoading: true),
          const SizedBox(height: 10),
          _deliveryFeesRow(context, null, isLoading: true),
          const SizedBox(height: 10),
          _rowForTexts(
            "Discount",
            "E£ -",
            context,
            true,
            true,
            isLoading: true,
            isDiscount: true,
          ),
          const Divider(
            indent: 15,
            endIndent: 15,
            thickness: 1,
            color: AppColors.primaryGrey,
          ),
          _rowForTexts(
            "Sub-Total",
            "E£ ",
            context,
            true,
            true,
            isLoading: true,
            isSubtotal: true,
          ),
        ],
      ],
    );
  }

  /// Delivery Fees Row with conditional formatting for "FREE"
  Widget _deliveryFeesRow(BuildContext context, double? deliveryPrice,
      {bool isLoading = false}) {
    if (isLoading) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Delivery Fees",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: AppColors.secondaryDarkerGrey,
                  fontWeight: FontWeight.w500,
                ),
          ),
          const ShimmerBox(
            width: 100,
            height: 15,
          ),
        ],
      );
    }

    final isFree = deliveryPrice != null && deliveryPrice == 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Delivery Fees",
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: AppColors.secondaryDarkerGrey,
                fontWeight: FontWeight.w500,
              ),
        ),
        Text(
          isFree ? "FREE" : "E£ ${deliveryPrice?.toStringAsFixed(2) ?? '0.00'}",
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: isFree ? Colors.green : AppColors.primaryTextLight,
                fontWeight: isFree ? FontWeight.bold : null,
                fontStyle: isFree ? FontStyle.italic : FontStyle.normal,
              ),
        ),
      ],
    );
  }

  /// General Row for Texts
  Row _rowForTexts(
    String leftText,
    String rightText,
    BuildContext context,
    bool isRightBold,
    bool isLeftBold, {
    bool? isLoading,
    bool isDiscount = false,
    bool isSubtotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          leftText,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: isDiscount
                    ? Colors.green
                    : isSubtotal
                        ? AppColors.primaryTextLight
                        : AppColors.secondaryDarkerGrey,
                fontSize: isSubtotal ? 18 : null,
                fontWeight: isLeftBold ? FontWeight.bold : FontWeight.w500,
              ),
        ),
        if (isLoading != null && isLoading == true)
          const ShimmerBox(
            width: 100,
            height: 15,
          ),
        if (isLoading == null)
          Text(
            rightText,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: isSubtotal ? 18 : null,
                  color: isDiscount ? Colors.green : AppColors.primaryTextLight,
                  fontWeight: isRightBold ? FontWeight.bold : null,
                ),
          ),
      ],
    );
  }
}
