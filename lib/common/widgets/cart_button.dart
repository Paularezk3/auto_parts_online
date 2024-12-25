import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class CartButton extends StatelessWidget {
  final int itemCount;
  final double totalPrice;
  final VoidCallback onTap;

  const CartButton({
    super.key,
    required this.itemCount,
    required this.totalPrice,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (itemCount == 0) {
      return const SizedBox.shrink(); // Hidden when the cart is empty
    }

    return Positioned(
      bottom: 8,
      left: 8,
      right: 8,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDarkMode
                ? AppColors.primaryDark
                : AppColors.primaryLight, // Light mode color

            borderRadius: const BorderRadius.all(Radius.circular(12)),
            boxShadow: [
              BoxShadow(
                color: isDarkMode
                    ? AppColors.primaryDark.withValues(alpha: 0.4)
                    : Colors.grey.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // Container around the icon
                  const SizedBox(width: 8),
                  Icon(
                    Icons.shopping_cart,
                    size: 20,
                    color: isDarkMode
                        ? AppColors.primaryTextOnSurfaceDark
                        : AppColors.primaryTextOnSurfaceLight,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$itemCount items',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode
                          ? AppColors.primaryTextOnSurfaceDark
                          : AppColors.primaryTextOnSurfaceLight,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    '${totalPrice.toStringAsFixed(2)} E£',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode
                          ? AppColors.primaryTextOnSurfaceDark
                          : AppColors.primaryTextOnSurfaceLight,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  // Optional container around the final row
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: isDarkMode
                          ? AppColors.primaryTextOnSurfaceDark
                          : AppColors.primaryTextOnSurfaceLight,
                      boxShadow: [
                        BoxShadow(
                          color: isDarkMode
                              ? Colors.black.withValues(alpha: 0.5)
                              : Colors.grey.withValues(alpha: 0.5),
                          blurRadius: 6,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.arrow_forward,
                      size: 18,
                      color: isDarkMode
                          ? AppColors.primaryLight
                          : AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
