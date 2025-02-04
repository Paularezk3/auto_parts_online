import 'package:flutter/material.dart';

import '../../core/models/stock_level.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StockLevelText extends StatelessWidget {
  final StockLevel stockLevel;
  final bool isBold;
  final double? fontSize;
  const StockLevelText({
    required this.stockLevel,
    this.isBold = true,
    this.fontSize,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      stockLevel == StockLevel.inStock
          ? AppLocalizations.of(context)!.inStock
          : (stockLevel == StockLevel.limited
              ? AppLocalizations.of(context)!.limitedStock
              : AppLocalizations.of(context)!.outOfStock),
      style: TextStyle(
        fontSize: fontSize,
        color: stockLevel == StockLevel.inStock
            ? Colors.green
            : (stockLevel == StockLevel.limited ? Colors.orange : Colors.red),
        fontWeight: isBold ? FontWeight.bold : null,
      ),
    );
  }
}
