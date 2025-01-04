// lib\common\components\quantity_counter.dart

import 'package:auto_parts_online/common/widgets/skeleton_loader.dart';
import 'package:flutter/material.dart';

class QuantityCounter extends StatelessWidget {
  final int counterValue;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final bool isLoading;
  final bool canBeDeleted;
  final void Function()? onDeleteItem;
  const QuantityCounter({
    this.canBeDeleted = false,
    this.onDeleteItem,
    this.isLoading = false,
    required this.counterValue,
    required this.onIncrement,
    required this.onDecrement,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    final containerColor = isDarkMode ? const Color(0xFF5A5A5A) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          _buildCounterButton(
            icon: canBeDeleted
                ? (counterValue == 1 ? Icons.delete_rounded : Icons.remove)
                : Icons.remove,
            onPressed: canBeDeleted
                ? (counterValue > 1 ? onDecrement : onDeleteItem)
                : (counterValue > 1 ? onDecrement : null),
            textColor: textColor,
          ),
          SizedBox(
            width: 10,
          ),
          !isLoading
              ? Text(
                  '${counterValue < 10 ? '0' : ''}$counterValue',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                )
              : ShimmerBox(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  borderColor: const Color(0xFF5A5A5A),
                  width: 18,
                  height: 25,
                  baseColor: isDarkMode ? const Color(0xFF5A5A5A) : null,
                  highlightColor: isDarkMode
                      ? const Color.fromARGB(255, 117, 117, 117)
                      : null,
                ),
          SizedBox(
            width: 10,
          ),
          _buildCounterButton(
            icon: Icons.add,
            onPressed: counterValue < 10 ? onIncrement : null,
            textColor: textColor,
          ),
        ],
      ),
    );
  }

  Widget _buildCounterButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required Color textColor,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 30,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: onPressed != null
              ? textColor.withValues(alpha: 0.1)
              : Colors.transparent,
        ),
        child: Icon(icon,
            size: 20,
            color: onPressed != null
                ? textColor
                : textColor.withValues(alpha: 0.3)),
      ),
    );
  }
}
