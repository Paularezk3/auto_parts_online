import 'package:auto_parts_online/common/components/default_buttons.dart';
import 'package:auto_parts_online/common/components/stock_level_text.dart';
import 'package:auto_parts_online/core/models/stock_level.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/utils/app_logger.dart';

class DefaultProductCard extends StatelessWidget {
  final String productImage;
  final String productName;
  final double productPrice;
  final StockLevel stockAvailability;
  final String brandLogoUrl;
  final VoidCallback onAddToCart;
  final bool isDarkMode;
  final ILogger logger;
  final void Function() onProductTap;

  const DefaultProductCard(
      {super.key,
      required this.productImage,
      required this.productName,
      required this.productPrice,
      required this.stockAvailability,
      required this.brandLogoUrl,
      required this.onAddToCart,
      required this.isDarkMode,
      required this.onProductTap,
      required this.logger});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: isDarkMode
          ? AppColors.accentDarkGrey
          : AppColors.secondaryForegroundLight,
      child: InkWell(
        onTap: onProductTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: isDarkMode
            ? Colors.white.withValues(alpha: 0.2)
            : Colors.black.withValues(alpha: 0.1),
        highlightColor: Colors.transparent,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Product Image
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Image.network(
                      productImage,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.broken_image,
                          size: 64,
                          color: Colors.grey),
                    ),
                  ),
                ),

                // Product Details
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Name
                      Text(productName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: isDarkMode
                                      ? AppColors.primaryTextDark
                                      : AppColors.primaryTextLight)),
                      const SizedBox(height: 8),

                      // Product Price
                      Text(
                        AppLocalizations.of(context)!.localeName == "ar"
                            ? "ج.م. ${productPrice.toStringAsFixed(2)}"
                            : "E£ ${productPrice.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 16,
                          color: isDarkMode
                              ? AppColors.secondaryGrey
                              : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Stock Availability
                      StockLevelText(
                        stockLevel: stockAvailability,
                        isBold: false,
                        fontSize: 12,
                      )
                    ],
                  ),
                ),

                // Add to Cart Button
                SecondaryButton(
                  text: stockAvailability == StockLevel.outOfStock
                      ? AppLocalizations.of(context)!.outOfStock
                      : AppLocalizations.of(context)!.addToCart,
                  logger: logger,
                  buttonSize: ButtonSize.small,
                  onPressed: stockAvailability != StockLevel.outOfStock
                      ? onAddToCart
                      : null,
                  isEnabled:
                      stockAvailability != StockLevel.outOfStock ? true : false,
                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 12),
                )
              ],
            ),

            // Brand Logo
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(4),
                child: Image.network(
                  brandLogoUrl,
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.broken_image,
                    size: 24,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
