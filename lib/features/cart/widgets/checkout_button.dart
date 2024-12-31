import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/constants/app_colors.dart';

class CheckoutButton extends StatefulWidget {
  final bool isEnabled;
  final bool isLoading;
  final VoidCallback? onPressed;
  final double? padding;
  final String text;

  const CheckoutButton({
    this.isEnabled = true,
    this.isLoading = false,
    required this.onPressed,
    required this.text,
    this.padding,
    super.key,
  });

  @override
  CheckoutButtonState createState() => CheckoutButtonState();
}

class CheckoutButtonState extends State<CheckoutButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 4, end: 12).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(widget.text);

    return Padding(
      padding: EdgeInsets.all(widget.padding ?? 15),
      child: SizedBox(
        height: 52,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                widget.isEnabled ? (AppColors.primaryLight) : Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 8,
            overlayColor: Colors.white,
          ),
          onPressed:
              widget.isEnabled && !widget.isLoading ? widget.onPressed : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Shimmering Text
              Center(
                child: Shimmer.fromColors(
                  baseColor: Colors.white,
                  highlightColor: Colors.white.withValues(alpha: 0.5),
                  period: Duration(seconds: 2),
                  child: Text(widget.text,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: isArabic ? 'Cairo' : 'Montserrat',
                      )),
                ),
              ),
              const SizedBox(width: 8),
              // Animated Arrow Container
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_animation.value, 0),
                    child: Container(
                      height: 36,
                      width: 36,
                      decoration: BoxDecoration(
                        color: AppColors.secondaryForegroundLight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: AppColors.primaryLight,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
