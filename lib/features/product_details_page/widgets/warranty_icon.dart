import 'package:auto_parts_online/core/models/guarantee_level.dart';
import 'package:flutter/material.dart';

class WarrantyIcon extends StatelessWidget {
  final GuaranteeLevel guaranteeLevel;
  final bool withInfoIcon;
  final bool withContainer;
  final EdgeInsetsGeometry? containerPadding;
  final EdgeInsetsGeometry? margin;
  const WarrantyIcon(
      {this.withInfoIcon = false,
      required this.withContainer,
      this.margin,
      this.containerPadding,
      required this.guaranteeLevel,
      super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return withContainer
        ? _container(isDarkMode, _containerItems())
        : _containerItems();
  }

  Widget _containerItems() {
    return Row(
      children: [
        if (guaranteeLevel != GuaranteeLevel.none) ...[
          _buildWarrantyIcon(guaranteeLevel),
          const SizedBox(width: 8),
        ],
        if (withInfoIcon) Icon(Icons.info, color: Colors.grey[600]),
      ],
    );
  }

  Widget _container(bool isDarkMode, Widget child) {
    return Container(
      padding: containerPadding ??
          const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      margin: margin,
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isDarkMode ? Colors.grey[600]! : Colors.grey[300]!,
            width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildWarrantyIcon(GuaranteeLevel guaranteeLevel) {
    switch (guaranteeLevel) {
      case GuaranteeLevel.basic:
        return _buildShieldIcon(
          guaranteeLevel: guaranteeLevel,
        );
      case GuaranteeLevel.high:
        return _buildShieldIcon(
          guaranteeLevel: guaranteeLevel,
        );
      default:
        return SizedBox.shrink(); // Transparent
    }
  }

  Widget _buildShieldIcon({required GuaranteeLevel guaranteeLevel}) {
    final color =
        guaranteeLevel == GuaranteeLevel.high ? Colors.amber : Colors.grey;
    final gradient = guaranteeLevel == GuaranteeLevel.high
        ? LinearGradient(
            colors: [Colors.amber[300]!, Colors.amber[700]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : LinearGradient(
            colors: [Colors.grey[300]!, Colors.grey[700]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: gradient,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Icon(Icons.shield, color: Colors.white, size: 16),
    );
  }
}
