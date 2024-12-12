import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

enum ButtonSize { small, big }

mixin ButtonStyles {
  static TextStyle getTextStyle({
    required String text,
    required bool isEnabled,
    required ThemeData theme,
    required ButtonSize buttonSize,
    required bool isPrimary,
  }) {
    final isArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(text);
    return TextStyle(
      fontSize: buttonSize == ButtonSize.big ? 18 : 14,
      fontWeight: FontWeight.bold,
      color: isPrimary
          ? Colors.white
          : (isEnabled
              ? (theme.brightness == Brightness.dark
                  ? AppColors.primaryDark
                  : AppColors.primaryLight)
              : AppColors.secondaryDarkerGrey),
      fontFamily: isArabic ? 'Cairo' : 'Montserrat',
    );
  }

  static BorderSide getBorderSide({
    required bool isEnabled,
    required ThemeData theme,
  }) {
    return BorderSide(
      color: isEnabled
          ? (theme.brightness == Brightness.dark
              ? AppColors.primaryDark
              : AppColors.primaryLight)
          : AppColors.primaryGrey,
      width: 2,
    );
  }

  static Size getButtonSize(ButtonSize size) {
    return Size(
      size == ButtonSize.big ? 160 : 120,
      size == ButtonSize.big ? 52 : 38,
    );
  }

  static Size getCircularLoadingSize(ButtonSize size) {
    return Size(
      size == ButtonSize.big ? 27 : 19,
      size == ButtonSize.big ? 27 : 19,
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String text;
  final bool isEnabled;
  final bool isLoading;
  final VoidCallback? onPressed;
  final ButtonSize buttonSize;
  final double? padding;

  const PrimaryButton({
    required this.text,
    this.isEnabled = true,
    this.isLoading = false,
    this.onPressed,
    this.buttonSize = ButtonSize.big,
    this.padding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.all(padding ?? 15),
      child: SizedBox.fromSize(
        size: ButtonStyles.getButtonSize(buttonSize),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              return isEnabled
                  ? (theme.brightness == Brightness.dark
                      ? AppColors.primaryDark
                      : AppColors.primaryLight)
                  : AppColors.primaryGrey;
            }),
            overlayColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) {
                return Colors.white.withOpacity(0.1);
              }
              return null;
            }),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            elevation: WidgetStateProperty.resolveWith(
                (states) => states.contains(WidgetState.pressed) ? 0 : 2),
          ),
          onPressed: isEnabled && !isLoading ? onPressed : null,
          child: isLoading
              ? SizedBox.fromSize(
                  size: ButtonStyles.getCircularLoadingSize(buttonSize),
                  child: const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  text,
                  style: ButtonStyles.getTextStyle(
                    text: text,
                    isEnabled: isEnabled,
                    theme: theme,
                    buttonSize: buttonSize,
                    isPrimary: true,
                  ),
                ),
        ),
      ),
    );
  }
}

class OutlinedPrimaryButton extends StatelessWidget {
  final String text;
  final bool isEnabled;
  final bool isLoading;
  final VoidCallback? onPressed;
  final ButtonSize buttonSize;
  final double? padding;

  const OutlinedPrimaryButton({
    required this.text,
    this.isEnabled = true,
    this.isLoading = false,
    this.onPressed,
    this.buttonSize = ButtonSize.big,
    this.padding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.all(padding ?? 15),
      child: SizedBox.fromSize(
        size: ButtonStyles.getButtonSize(buttonSize),
        child: OutlinedButton(
          style: ButtonStyle(
            side: WidgetStateProperty.resolveWith(
              (states) => ButtonStyles.getBorderSide(
                isEnabled: isEnabled,
                theme: theme,
              ),
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            overlayColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) {
                return (theme.brightness == Brightness.dark
                        ? AppColors.primaryDark
                        : AppColors.primaryLight)
                    .withOpacity(0.1);
              }
              return null;
            }),
          ),
          onPressed: isEnabled && !isLoading ? onPressed : null,
          child: isLoading
              ? SizedBox.fromSize(
                  size: ButtonStyles.getCircularLoadingSize(buttonSize),
                  child: const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  text,
                  style: ButtonStyles.getTextStyle(
                    text: text,
                    isEnabled: isEnabled,
                    theme: theme,
                    buttonSize: buttonSize,
                    isPrimary: false,
                  ),
                ),
        ),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String text;
  final bool isEnabled;
  final bool isLoading;
  final VoidCallback? onPressed;
  final ButtonSize buttonSize;
  final double? padding;

  const SecondaryButton({
    required this.text,
    this.isEnabled = true,
    this.isLoading = false,
    this.onPressed,
    this.buttonSize = ButtonSize.big,
    this.padding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(text);
    final textStyle = TextStyle(
      fontSize: buttonSize == ButtonSize.big ? 18 : 14,
      fontWeight: FontWeight.bold,
      color: isEnabled
          ? (Theme.of(context).brightness == Brightness.dark
              ? AppColors.primaryDark
              : AppColors.primaryLight)
          : AppColors.secondaryDarkerGrey,
      fontFamily: isArabic ? 'Cairo' : 'Montserrat',
    );

    return Padding(
      padding: EdgeInsets.all(padding ?? 15),
      child: SizedBox.fromSize(
        size: ButtonStyles.getButtonSize(buttonSize),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isEnabled ? Colors.white : AppColors.secondaryGrey,
            disabledBackgroundColor: AppColors.secondaryGrey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: isEnabled && !isLoading ? onPressed : null,
          child: isLoading
              ? SizedBox.fromSize(
                  size: ButtonStyles.getCircularLoadingSize(buttonSize),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isEnabled
                          ? (Theme.of(context).brightness == Brightness.dark
                              ? AppColors.primaryDark
                              : AppColors.primaryLight)
                          : Colors.white,
                    ),
                  ),
                )
              : Text(
                  text,
                  style: textStyle,
                ),
        ),
      ),
    );
  }
}
