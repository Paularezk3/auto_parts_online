// lib/features/cart/cart_page_view.dart
import 'package:auto_parts_online/app/routes/navigation_cubit.dart';
import 'package:auto_parts_online/app/routes/navigation_state.dart';
import 'package:auto_parts_online/app/setup_dependencies.dart';
import 'package:auto_parts_online/common/layouts/base_screen.dart';
import 'package:auto_parts_online/common/layouts/default_appbar.dart';
import 'package:auto_parts_online/common/layouts/error_page.dart';
import 'package:auto_parts_online/common/widgets/default_loading_widget.dart';
import 'package:auto_parts_online/common/widgets/skeleton_loader.dart';
import 'package:auto_parts_online/features/cart/app_level_cubit/cart_cubit.dart';
import 'package:auto_parts_online/features/cart/app_level_cubit/cart_state.dart';
import 'package:auto_parts_online/features/cart/bloc/cart_page_bloc.dart';
import 'package:auto_parts_online/features/cart/widgets/checkout_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_logger.dart';
import 'bloc/cart_page_event.dart';
import 'bloc/cart_page_state.dart';
import 'widgets/cart_page_product_card.dart';
import 'widgets/order_details_widget.dart';

class CartPageView extends StatelessWidget {
  const CartPageView({super.key});

  Future<void> _waitForLoading(BuildContext context) async {
    final cartCubit = context.read<CartCubit>();
    while (cartCubit.state is CartLoadingState) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  @override
  Widget build(BuildContext context) {
    final ILogger logger = getIt<ILogger>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        return didPop
            ? context.read<CartPageBloc>().add(LeaveCartPage())
            : null;
      },
      child: BaseScreen(
        selectedIndex: 2,
        child: FutureBuilder(
          future: _waitForLoading(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _loadingWidget();
            } else {
              return BlocBuilder<CartPageBloc, CartPageState>(
                buildWhen: (previous, current) {
                  if (current is CartPageLeft) {
                    logger.trace(
                        "previous State: $previous,\ncurrent state: $current, and bloc builder won't rebuild",
                        StackTrace.empty);
                    return false;
                  } else if (current is LeaveCartPage) {
                    return false;
                  }
                  return true;
                },
                builder: (context, state) {
                  logger.trace("current State: $state", StackTrace.empty);
                  if (state is CartPageInitial || state is CartPageLeft) {
                    context.read<CartPageBloc>().add(LoadCartPage());
                    return _loadingWidget();
                  } else if (state is CartPageLoading) {
                    return _loadingWidget();
                  } else if (state is CartPageLoaded ||
                      state is CartPageEditLoading) {
                    state = state is CartPageLoaded
                        ? state
                        : state as CartPageEditLoading;
                    return _loadedCartPage(state, context, logger, isDarkMode,
                        isLoading: state is CartPageLoaded ? false : true);
                  } else if (state is CartPageError) {
                    return ErrorPage(
                        "Error While Building The Cart, The Error has sent to the team.",
                        onButtonPressed: () =>
                            context.read<CartPageBloc>().add(LoadCartPage()),
                        logger: logger);
                  } else if (state is CartPageEmpty) {
                    return const Center(child: Text("Your cart is empty."));
                  }

                  return const Center(child: Text("Your cart is empty."));
                },
              );
            }
          },
        ),
      ),
    );
  }

  Scaffold _loadedCartPage(CartPageState state, BuildContext context,
      ILogger logger, bool isDarkMode,
      {required bool isLoading}) {
    final cartPageData = state is CartPageLoaded
        ? state.cartPageData
        : (state as CartPageEditLoading).cartPageData;

    final TextEditingController promocodeController = TextEditingController();
    return Scaffold(
      appBar: OtherPageAppBar(
        title: "Cart",
        isLoading: false,
        withShadow: false,
      ),
      body: SingleChildScrollView(
          // todo: remove this single
          child: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap:
                  true, // Prevents the list view from expanding infinitely
              physics:
                  NeverScrollableScrollPhysics(), // Disable internal scrolling
              itemCount: cartPageData!.cartItems.length,
              itemBuilder: (context, index) {
                final item = cartPageData.cartItems[index];
                return CartPageProductCard(
                  item: item,
                  isLoading: isLoading,
                );
              },
            ),
            const SizedBox(height: 16),
            const Divider(
              indent: 8,
              endIndent: 8,
              color: AppColors.primaryGrey,
            ),
            const SizedBox(height: 16),
            // ListView for added promocodes
            if (cartPageData.promocodeDetails.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: cartPageData.promocodeDetails.length,
                itemBuilder: (context, index) {
                  final promocode = cartPageData.promocodeDetails[index];
                  return Card(
                    margin:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Gift Icon
                          Icon(
                            Icons.card_giftcard,
                            color: Colors.green.shade700,
                            size: 28.0,
                          ),
                          SizedBox(width: 12.0),
                          // Promocode Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  promocode.promocodeName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                    color: AppColors.primaryLight,
                                  ),
                                ),
                                SizedBox(height: 4.0),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 4.0, horizontal: 8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.greenAccent.shade100,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                    promocode.promocodeDiscountPercent != null
                                        ? '${promocode.promocodeDiscountPercent}%'
                                        : '${promocode.promocodeDiscountPrice} E£',
                                    style: TextStyle(
                                      color: Colors.green.shade700,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Delete Button
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                              size: 20.0,
                            ),
                            onPressed: () {
                              context
                                  .read<CartPageBloc>()
                                  .add(RemovePromocode(promocodeIndex: index));
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(height: 4), // Promocode input field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.secondaryGrey, // Background color
                  border: Border.all(
                    color: AppColors.primaryGrey, // Dotted outline color
                    style: BorderStyle.solid, // Border style
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: promocodeController,
                        decoration: InputDecoration(
                          hintText: 'Enter promocode',
                          hintStyle: TextStyle(
                            color: AppColors
                                .primaryTextLight, // White text for hint
                          ),
                          filled: true,
                          fillColor: Colors
                              .transparent, // Inherit container background
                          border: InputBorder.none, // Remove default border
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (promocodeController.text.trim().isNotEmpty) {
                          context.read<CartPageBloc>().add(
                                AddPromocode(
                                    promocode: promocodeController.text.trim()),
                              );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black, // Black button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                      ),
                      child: isLoading
                          ? DefaultLoadingWidget(
                              height: 20,
                              width: 20,
                              color: AppColors.primaryTextOnSurfaceLight,
                            )
                          : Text(
                              'Apply',
                              style: TextStyle(
                                color: AppColors
                                    .primaryTextOnSurfaceLight, // White text color
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(
              indent: 8,
              endIndent: 8,
              color: AppColors.primaryGrey,
            ),
            const SizedBox(height: 16),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 16),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: OrderDetailsWidget(
                  cartPageData: cartPageData,
                  isLoading: isLoading,
                ),
              ),
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              CheckoutButton(
                // logger: logger,
                onPressed: () {
                  context
                      .read<NavigationCubit>()
                      .push(NavigationCheckoutPageState(cartPageData));
                },
                text: "Checkout",
              ),
            ]),
          ],
        ),
      )),
    );
  }

  Scaffold _loadingWidget() {
    return const Scaffold(
      appBar: OtherPageAppBar(
        title: "Cart",
        isLoading: true,
        withShadow: false,
      ),
      body: SkeletonLoader(),
    );
  }
}
