// Refactored OrderSummary with skewmorphic star icon and white container design
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_gradients.dart';

class OrderSummary extends StatelessWidget {
  final double subTotalPrice;
  final int points;
  final ValueChanged<int> onPointsRedeemed;
  final double totalPrice;

  const OrderSummary({
    required this.totalPrice,
    required this.subTotalPrice,
    required this.points,
    required this.onPointsRedeemed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
          _buildSummaryRow("Total Before Discount",
              subTotalPrice.toStringAsFixed(2), context),
          const SizedBox(height: 8),
          _buildPointsRow(context, subTotalPrice - totalPrice),
          const SizedBox(height: 8),
          const Divider(
            color: AppColors.primaryGrey,
            endIndent: 12,
            indent: 12,
          ),
          const SizedBox(height: 8),
          _buildSummaryRow(
              "Final Total", totalPrice.toStringAsFixed(2), context,
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
                    color: Colors.amber.withValues(alpha: 0.3),
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: const Offset(2, 2),
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
              style: GoogleFonts.inter(
                fontSize: 18.0,
                fontWeight: FontWeight.w900,
                foreground: Paint()
                  ..shader = AppGradients.linearPrimaryAccent.createShader(
                      Rect.fromLTWH(50, 0, 100, 0)), // Adjust width as needed
              ),
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
