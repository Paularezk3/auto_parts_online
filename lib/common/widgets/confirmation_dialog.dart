import 'package:auto_parts_online/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Delete',
    this.cancelText = 'Cancel',
    required this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    // Check current brightness for dark/light mode
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDarkMode
          ? AppColors.primaryForegroundLight
          : AppColors.primaryForegroundDark,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
              color:
                  isDarkMode ? AppColors.accentDark : AppColors.accentLight)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Dialog Title
            Text(
              title.toUpperCase(),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode
                      ? AppColors.primaryTextOnSurfaceLight
                      : AppColors.primaryTextOnSurfaceDark),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            // Dialog Message
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: isDarkMode
                      ? AppColors.primaryTextOnSurfaceLight
                      : AppColors.primaryTextOnSurfaceDark),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Cancel Button
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDarkMode
                          ? AppColors.secondaryGrey
                          : AppColors.accentDarkGrey,
                      foregroundColor: isDarkMode ? Colors.white : Colors.black,
                    ),
                    onPressed: () {
                      if (onCancel != null) {
                        onCancel!();
                      }
                      Navigator.of(context).pop(); // Close dialog
                    },
                    child: Text(
                      cancelText,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode
                              ? AppColors.primaryTextOnSurfaceDark
                              : AppColors.primaryTextOnSurfaceLight),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Confirm Button
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isDarkMode ? Colors.red[400] : Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      onConfirm();
                      Navigator.of(context).pop(); // Close dialog
                    },
                    child: Text(confirmText,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDarkMode
                                ? AppColors.primaryTextOnSurfaceDark
                                : AppColors.primaryTextOnSurfaceLight)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
