import 'package:auto_parts_online/app/setup_dependencies.dart';
import 'package:auto_parts_online/common/layouts/default_appbar.dart';
import 'package:auto_parts_online/core/constants/assets_path.dart';
import 'package:auto_parts_online/features/cart/bloc/cart_page_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../common/components/default_buttons.dart';
import '../../core/utils/app_logger.dart';
import '../cart/bloc/cart_page_state.dart';
import '../checkout/checkout_page_model.dart';

class OrderPlacedView extends StatefulWidget {
  final PaymentWay paymentWay;
  const OrderPlacedView({required this.paymentWay, super.key});

  @override
  State<OrderPlacedView> createState() => _OrderPlacedViewState();
}

class _OrderPlacedViewState extends State<OrderPlacedView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  final ILogger logger = getIt<ILogger>();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Stop animation at frame 49
        _animationController.stop();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String getPaymentMessage() {
    switch (widget.paymentWay) {
      case PaymentWay.cash:
        return "Please prepare cash payment upon delivery.";
      case PaymentWay.instapay:
        return "Your payment is being processed.";
      case PaymentWay.vodafoneCash:
        return "Payment via Vodafone Cash is being processed.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OtherPageAppBar(
        title: "Order Placed",
        isLoading: false,
        showBackButton: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Lottie animation
              SizedBox(
                height: 200,
                child: Lottie.asset(
                  AssetsPath.verifiedMarkAnimation,
                  controller: _animationController,
                  onLoaded: (composition) {
                    // Configure the animation to stop at frame 49
                    final targetFrame = 49 / composition.endFrame;
                    _animationController.duration = composition.duration;
                    _animationController.animateTo(targetFrame);
                  },
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Thank You for Your Order!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                "Your order has been successfully placed.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Card(
                elevation: 6,
                shadowColor: Colors.grey.withValues(alpha: 0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 24.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20,
                        color: Colors.blueAccent,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          getPaymentMessage(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if ((context.read<CartPageBloc>().state as CartPageLoaded)
                  .cartPageData!
                  .deliveryStatus
                  .getIsFastDelivery)
                // Action buttons
                PrimaryButton.icon(
                  onPressed: () {
                    // Navigate to order tracking
                    // Navigator.pushNamed(context, '/order-tracking');
                  },
                  logger: logger,
                  icon: Icons.local_shipping,
                  text: 'Track Order',
                ),
              OutlinedPrimaryButton(
                logger: logger,
                onPressed: () {
                  // Navigate to order summary
                  // Navigator.pushNamed(context, '/order-summary');
                },
                text: 'View Order Summary',
              ),
              TextButton(
                onPressed: () {
                  // Navigate to support
                  // Navigator.pushNamed(context, '/support');
                },
                child: const Text(
                  'Need Help?',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
