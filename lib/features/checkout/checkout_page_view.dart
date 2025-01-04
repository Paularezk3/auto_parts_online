// Path: lib/features/checkout/checkout_page_view.dart
import 'package:auto_parts_online/app/routes/navigation_state.dart';
import 'package:auto_parts_online/app/setup_dependencies.dart';
import 'package:auto_parts_online/common/layouts/error_page.dart';
import 'package:auto_parts_online/core/utils/app_logger.dart';
import 'package:auto_parts_online/features/checkout/bloc/checkout_page_bloc.dart';
import 'package:auto_parts_online/features/checkout/bloc/checkout_page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'widget/checkout_slider.dart';
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
          late final AccountAddress? lastUsedAddress;
          if (state.checkoutPageModel.accountAddress.isEmpty) {
            lastUsedAddress = null;
          } else {
            lastUsedAddress = state.checkoutPageModel.accountAddress
                .firstWhere((address) => address.isLastUsed);
          }
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
                      address: lastUsedAddress!.address,
                      city: lastUsedAddress.city,
                      phone: lastUsedAddress.phoneToContact,
                      onEdit: () => _showAddressModal(context,
                          state.checkoutPageModel.accountAddress, state),
                    )
                  else
                    AddAddressPlaceholder(
                      onAdd: () => _showAddressModal(context,
                          state.checkoutPageModel.accountAddress, state),
                    ),
                  const SizedBox(height: 32),
                  Text(
                    "Order Summary",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  OrderSummary(
                    subTotalPrice: checkoutPageData.widgetData.subTotal,
                    points: checkoutPageData.accountPoints,
                    totalPrice:
                        checkoutPageData.widgetData.totalAfterPointsDiscount,
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
                    selectedMethod: checkoutPageData.widgetData.paymentWay,
                    onPaymentMethodChanged: (PaymentWay method) {
                      checkPageBloc
                          .add(UpdatePaymentMethod(paymentWay: method));
                    },
                  ),
                  const SizedBox(height: 32),
                  CheckoutSlider(
                    isReadyToCheckout:
                        state.checkoutPageModel.widgetData.paymentWay != null
                            ? (state.checkoutPageModel.accountAddress
                                    .isNotEmpty &&
                                state.checkoutPageModel.accountAddress
                                    .where((element) => element.isLastUsed)
                                    .isNotEmpty)
                            : false, // Boolean to indicate readiness
                    isProcessing:
                        state.checkoutPageModel.widgetData.isSliderProcessing,
                    onCheckout: () {
                      // Handle the checkout process
                      context.read<NavigationCubit>().push(
                          NavigationOnlinePaymentPageState(
                              state.checkoutPageModel.widgetData.paymentWay!,
                              state.checkoutPageModel.widgetData
                                  .totalAfterPointsDiscount));
                      context.read<CheckoutPageBloc>().add(UpdateWidgetData(
                              widgetData:
                                  state.checkoutPageModel.widgetData.copyWith(
                            isSliderProcessing: false,
                          )));
                    },
                    buttonText: state.checkoutPageModel.widgetData.paymentWay ==
                            null
                        ? "Choose Payment"
                        : !(state.checkoutPageModel.accountAddress.isNotEmpty &&
                                state.checkoutPageModel.accountAddress
                                    .where((element) => element.isLastUsed)
                                    .isNotEmpty)
                            ? "Put Address"
                            : (state.checkoutPageModel.widgetData.paymentWay ==
                                    PaymentWay.cash
                                ? "Slide to Order"
                                : "Slide to Pay"),
                  ),
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

  void _showAddressModal(BuildContext context, List<AccountAddress> addresses,
      CheckoutPageLoaded state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => AddressSelectionModal(
        addresses: addresses,
        onAddNewAddress: () {
          Navigator.pop(context); // Close the modal before navigating
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => AddEditAddressPage(
                      onAddressSaved: (p0) {
                        state.checkoutPageModel.accountAddress.add(p0);
                        context.read<CheckoutPageBloc>().add(UpdateAddress(
                            address: state.checkoutPageModel.accountAddress));
                      },
                    )),
          );
        },
        onChoosingAnotherAddress: (AccountAddress address) {
          context.read<CheckoutPageBloc>().add(UpdateAddress(
              address: state.checkoutPageModel.accountAddress
                  .map((e) => e.copyWith(isLastUsed: false))
                  .toList()));
          context.read<CheckoutPageBloc>().add(UpdateAddress(
              address: state.checkoutPageModel.accountAddress
                  .map((e) => e.copyWith(
                      isLastUsed:
                          e.addressId == address.addressId ? true : false))
                  .toList()));
          Navigator.pop(context);
        },
        onEditAddress: (AccountAddress address) {
          Navigator.pop(context); // Close the modal before navigating
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddEditAddressPage(
                  initialAddress: address,
                  onAddressSaved: (p0) {
                    state.checkoutPageModel.accountAddress.removeWhere(
                        (element) => element.addressId == address.addressId);
                    state.checkoutPageModel.accountAddress.add(p0);
                    context.read<CheckoutPageBloc>().add(UpdateAddress(
                        address: state.checkoutPageModel.accountAddress));
                  }),
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
