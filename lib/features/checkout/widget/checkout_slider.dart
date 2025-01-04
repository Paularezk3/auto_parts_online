import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class CheckoutSlider extends StatefulWidget {
  final bool isReadyToCheckout; // Whether the user has completed all procedures
  final VoidCallback onCheckout; // Action when the slider completes
  final String buttonText; // Text to display on the slider
  final bool isProcessing;

  const CheckoutSlider({
    required this.isReadyToCheckout,
    required this.onCheckout,
    required this.buttonText,
    required this.isProcessing,
    super.key,
  });

  @override
  State<CheckoutSlider> createState() => _CheckoutSliderState();
}

class _CheckoutSliderState extends State<CheckoutSlider> {
  double _dragPosition = 0.0;
  late bool isCompleted;

  @override
  void initState() {
    super.initState();
    isCompleted = widget.isProcessing;
  }

  @override
  void didUpdateWidget(covariant CheckoutSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update _isCompleted if isProcessing changes
    isCompleted = widget.isProcessing;

    _dragPosition = 0.0;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    const double sliderHeight = 60;

    return Opacity(
      opacity: widget.isReadyToCheckout ? 1.0 : 0.5,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double sliderWidth = constraints.maxWidth;

          return GestureDetector(
            onHorizontalDragUpdate: widget.isReadyToCheckout
                ? (details) {
                    setState(() {
                      _dragPosition = (_dragPosition + details.delta.dx)
                          .clamp(0.0, sliderWidth - sliderHeight);
                    });
                  }
                : null,
            onHorizontalDragEnd: widget.isReadyToCheckout
                ? (details) {
                    if (_dragPosition >= sliderWidth - sliderHeight) {
                      setState(() {
                        isCompleted = true;
                      });
                      widget.onCheckout();
                    } else {
                      setState(() {
                        _dragPosition = 0.0;
                      });
                    }
                  }
                : null,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                // Slider background
                Container(
                  width: sliderWidth,
                  height: sliderHeight,
                  decoration: BoxDecoration(
                    color: widget.isReadyToCheckout
                        ? AppColors.primaryLight
                        : Colors.grey[400],
                    borderRadius:
                        BorderRadius.circular(12), // Less rounded edges
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    isCompleted ? "Processing..." : widget.buttonText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Draggable button
                Positioned(
                  left: _dragPosition + 4,
                  child: Container(
                    width: sliderHeight - 8,
                    height: sliderHeight - 8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8), // Same rounding
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.arrow_forward,
                      color: widget.isReadyToCheckout
                          ? AppColors.primaryLight
                          : Colors.grey[400],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
