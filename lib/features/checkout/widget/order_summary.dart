// Refactored OrderSummary with skewmorphic star icon and white container design
import 'package:flutter/material.dart';

class OrderSummary extends StatelessWidget {
  final double totalPrice;
  final int points;
  final ValueChanged<int> onPointsRedeemed;
  final double pointValue;

  const OrderSummary({
    required this.pointValue,
    required this.totalPrice,
    required this.points,
    required this.onPointsRedeemed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final pointsDiscount = points * 0.05;
    final finalPrice = totalPrice - pointsDiscount;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryRow(
              "Total Before Discount", totalPrice.toStringAsFixed(2), context),
          const SizedBox(height: 8),
          _buildPointsRow(context, pointsDiscount),
          const SizedBox(height: 8),
          _buildSummaryRow(
              "Final Total", finalPrice.toStringAsFixed(2), context,
              isHighlighted: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, BuildContext context,
      {bool isHighlighted = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isHighlighted
              ? Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  )
              : Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          "E£ $value",
          style: isHighlighted
              ? Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  )
              : Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }

  Widget _buildPointsRow(BuildContext context, double discount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withValues(alpha: 0.4),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: const Offset(4, 4),
                  ),
                  BoxShadow(
                    color: Colors.white,
                    blurRadius: 8,
                    offset: const Offset(-4, -4),
                  ),
                ],
              ),
              child: Icon(
                Icons.star,
                color: Colors.amber,
                size: 20,
                shadows: [
                  Shadow(
                    color: Colors.amber.withValues(alpha: 0.2),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "$points Points",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
        Text(
          "E£ -${discount.toStringAsFixed(2)}",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.red,
              ),
        ),
      ],
    );
  }
}
