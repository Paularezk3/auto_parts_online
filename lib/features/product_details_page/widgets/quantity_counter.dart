import 'package:flutter/material.dart';

class QuantityCounter extends StatelessWidget {
  final int counterValue;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const QuantityCounter({
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
            icon: Icons.remove,
            onPressed: counterValue > 1 ? onDecrement : null,
            textColor: textColor,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            '${counterValue < 10 ? '0' : ''}$counterValue',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
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
