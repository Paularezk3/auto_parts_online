// Path: lib/features/checkout/checkout_page_view.dart
import 'package:auto_parts_online/app/setup_dependencies.dart';
import 'package:auto_parts_online/common/components/default_buttons.dart';
import 'package:auto_parts_online/common/layouts/error_page.dart';
import 'package:auto_parts_online/core/utils/app_logger.dart';
import 'package:auto_parts_online/features/checkout/bloc/checkout_page_bloc.dart';
import 'package:auto_parts_online/features/checkout/bloc/checkout_page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/routes/navigation_cubit.dart';
import '../../common/layouts/default_appbar.dart';
import '../../common/widgets/skeleton_loader.dart';
import '../../core/models/account_address.dart';
import '../add_edit_address/add_edit_address_page_view.dart';
import '../cart/models/cart_page_model.dart';
import 'package:dotted_border/dotted_border.dart';

import 'bloc/checkout_page_event.dart';
import 'checkout_page_model.dart';
import 'widget/address_card.dart';
import 'widget/address_selection_modal.dart';
import 'widget/order_summary.dart';
import 'widget/payment_method_selector.dart';

class CheckoutPageView extends StatelessWidget {
  final CartPageModel cartDetails;

  const CheckoutPageView({
    required this.cartDetails,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final checkPageBloc = context.read<CheckoutPageBloc>();
    final ILogger logger = getIt<ILogger>();
    return Scaffold(
      appBar: OtherPageAppBar(
        title: "Checkout",
        isLoading: false,
        showBackButton: true,
        onBackTap: () => context.read<NavigationCubit>().pop(),
      ),
      body: BlocBuilder<CheckoutPageBloc, CheckoutPageState>(
          builder: (context, state) {
        logger.trace("current state is $state", StackTrace.empty);
        if (state is CheckoutPageInitial) {
          checkPageBloc.add(LoadCheckoutPage(cartDetails: cartDetails));
        } else if (state is CheckoutPageLoading) {
          return SkeletonLoader();
        } else if (state is CheckoutPageLoaded) {
          final checkoutPageData = state.checkoutPageModel;
          final lastUsedAddress = state.checkoutPageModel.accountAddress
              .firstWhere((address) => address.isLastUsed);
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Shipping Address",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  if (state.checkoutPageModel.accountAddress.isNotEmpty)
                    AddressCard(
                      address: lastUsedAddress.address,
                      city: lastUsedAddress.city,
                      phone: lastUsedAddress.phoneToContact,
                      onEdit: () => _showAddressModal(
                        context,
                        state.checkoutPageModel.accountAddress,
                      ),
                    )
                  else
                    AddAddressPlaceholder(
                      onAdd: () => _showAddressModal(
                          context, state.checkoutPageModel.accountAddress),
                    ),
                  const SizedBox(height: 32),
                  Text(
                    "Order Summary",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  OrderSummary(
                    pointValue: checkoutPageData.pointValue,
                    totalPrice: checkoutPageData.accountPoints * 10.0,
                    points: checkoutPageData.accountPoints,
                    onPointsRedeemed: (int pointsUsed) {
                      checkPageBloc.add(UpdatePoints(pointsUsed: pointsUsed));
                    },
                  ),
                  const SizedBox(height: 32),
                  Text(
                    "Payment Method",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  PaymentMethodSelector(
                    selectedMethod: checkoutPageData.paymentWay,
                    instapayLink: checkoutPageData.instapayLink,
                    onPaymentMethodChanged: (PaymentWay method) {
                      checkPageBloc
                          .add(UpdatePaymentMethod(paymentWay: method));
                    },
                  ),
                  PrimaryButton(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 0),
                    text: state.checkoutPageModel.paymentWay == PaymentWay.cash
                        ? "Order Now"
                        : "Pay Now",
                    logger: logger,
                    onPressed: () async {
                      var url = (state).checkoutPageModel.instapayLink!;
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url));
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                  )
                ],
              ),
            ),
          );
        } else if (state is CheckoutPageError) {
          ErrorPage(state.message, logger: logger, onButtonPressed: () {
            checkPageBloc.add(LoadCheckoutPage(cartDetails: cartDetails));
          });
        }
        return ErrorPage("something wrong had happened", onButtonPressed: () {
          checkPageBloc.add(LoadCheckoutPage(cartDetails: cartDetails));
        }, logger: logger);
      }),
    );
  }

  void _showAddressModal(BuildContext context, List<AccountAddress> addresses) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => AddressSelectionModal(
        addresses: addresses,
        onAddNewAddress: () {
          Navigator.pop(context); // Close the modal before navigating
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditAddressPage()),
          );
        },
        onEditAddress: (AccountAddress address) {
          Navigator.pop(context); // Close the modal before navigating
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddEditAddressPage(initialAddress: address),
            ),
          );
        },
      ),
    );
  }
}

class AddAddressPlaceholder extends StatelessWidget {
  final VoidCallback onAdd;

  const AddAddressPlaceholder({
    required this.onAdd,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onAdd,
      child: DottedBorder(
        color: Colors.grey,
        strokeWidth: 1,
        dashPattern: [6, 4],
        child: Container(
          height: 100,
          width: double.infinity,
          alignment: Alignment.center,
          child: const Text(
            "Add a new shipping address",
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
