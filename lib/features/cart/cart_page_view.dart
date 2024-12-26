// lib/features/cart/cart_page_view.dart
import 'package:auto_parts_online/app/setup_dependencies.dart';
import 'package:auto_parts_online/common/components/default_buttons.dart';
import 'package:auto_parts_online/common/components/quantity_counter.dart';
import 'package:auto_parts_online/common/layouts/base_screen.dart';
import 'package:auto_parts_online/common/layouts/default_appbar.dart';
import 'package:auto_parts_online/common/layouts/error_page.dart';
import 'package:auto_parts_online/common/widgets/skeleton_loader.dart';
import 'package:auto_parts_online/features/cart/app_level_cubit/cart_cubit.dart';
import 'package:auto_parts_online/features/cart/app_level_cubit/cart_state.dart';
import 'package:auto_parts_online/features/cart/bloc/cart_page_bloc.dart';
import 'package:auto_parts_online/features/cart/models/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_logger.dart';
import 'bloc/cart_page_event.dart';
import 'bloc/cart_page_state.dart';

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
        anotherPageClicked: () =>
            context.read<CartPageBloc>().add(LeaveCartPage()),
        selectedIndex: 2,
        child: FutureBuilder(
          future: _waitForLoading(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _loadingWidget();
            } else {
              return BlocBuilder<CartPageBloc, CartPageState>(
                buildWhen: (previous, current) {
                  return current is CartPageInitial &&
                          previous is! CartPageInitial
                      ? false
                      : true;
                },
                builder: (context, state) {
                  logger.trace("current State: $state", StackTrace.empty);
                  if (state is CartPageInitial) {
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
    return Scaffold(
      appBar: OtherPageAppBar(
        title: "Cart",
        isLoading: false,
        withShadow: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartPageData!.cartItems.length,
              itemBuilder: (context, index) {
                final item = cartPageData.cartItems[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  color:
                      isDarkMode ? AppColors.accentDarkGrey : Colors.grey[200],
                  child: ListTile(
                    leading: Image.network(
                      'https://via.placeholder.com/50x50',
                      fit: BoxFit.cover,
                    ),
                    minTileHeight: 100,
                    title: Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode
                              ? AppColors.primaryTextDark
                              : AppColors.primaryTextLight),
                    ),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (item.priceAfterDiscount != null) ...[
                          Text(
                            'E£ ${(item.priceAfterDiscount!).toStringAsFixed(2)}',
                            style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          'E£ ${item.priceBeforeDiscount.toStringAsFixed(2)}',
                          style: TextStyle(
                              decoration: item.priceAfterDiscount != null
                                  ? TextDecoration.lineThrough
                                  : null,
                              decorationColor: isDarkMode
                                  ? AppColors.primaryTextDark
                                  : AppColors.primaryTextLight,
                              color: isDarkMode
                                  ? AppColors.secondaryGrey
                                  : AppColors.secondaryDarkerGrey),
                        ),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IntrinsicWidth(
                          child: QuantityCounter(
                              isLoading: isLoading,
                              counterValue: item.quantity,
                              onIncrement: () {
                                if (isLoading) return;
                                context.read<CartPageBloc>().add(
                                      AddItemToCart(
                                        item: CartItem(
                                            quantity: 1,
                                            productId: item.productId),
                                      ),
                                    );
                              },
                              onDecrement: () {
                                if (isLoading) return;
                                if (item.quantity > 1) {
                                  context.read<CartPageBloc>().add(
                                        ReduceItemFromCart(
                                            quantity: 1,
                                            itemId: item.productId),
                                      );
                                } else {
                                  context.read<CartPageBloc>().add(
                                      RemoveItemFromCart(
                                          itemId: item.productId));
                                }
                              }),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!isLoading) ...[
                  _rowForTexts(
                      "Items",
                      "E£ ${cartPageData.cartTotal.totalPriceBeforeDiscount.toStringAsFixed(2)}",
                      context,
                      isDarkMode,
                      false),
                  SizedBox(
                    height: 10,
                  ),
                  _rowForTexts(
                      "Discount",
                      "- E£ ${(cartPageData.cartTotal.totalPriceBeforeDiscount - cartPageData.cartTotal.totalPriceAfterDiscount).toStringAsFixed(2)}",
                      context,
                      isDarkMode,
                      false),
                  Divider(
                    indent: 30,
                    endIndent: 30,
                    thickness: 1,
                  ),
                  _rowForTexts(
                      "Total",
                      "E£ ${cartPageData.cartTotal.totalPriceAfterDiscount.toStringAsFixed(2)}",
                      context,
                      isDarkMode,
                      true)
                ],
                if (isLoading) ...[
                  _rowForTexts(
                      "Items",
                      "E£ ${cartPageData.cartTotal.totalPriceBeforeDiscount.toStringAsFixed(2)}",
                      context,
                      isDarkMode,
                      false,
                      isLoading: true),
                  SizedBox(
                    height: 10,
                  ),
                  _rowForTexts(
                      "Discount",
                      "- E£ ${(cartPageData.cartTotal.totalPriceBeforeDiscount - cartPageData.cartTotal.totalPriceAfterDiscount).toStringAsFixed(2)}",
                      context,
                      isDarkMode,
                      false,
                      isLoading: true),
                  Divider(
                    indent: 30,
                    endIndent: 30,
                    thickness: 1,
                  ),
                  _rowForTexts(
                      "Total",
                      "E£ ${cartPageData.cartTotal.totalPriceAfterDiscount.toStringAsFixed(2)}",
                      context,
                      isDarkMode,
                      true,
                      isLoading: true)
                ],
                const SizedBox(height: 8),
                PrimaryButton(
                  logger: logger,
                  onPressed: () {},
                  text: "Proceed to Checkout",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row _rowForTexts(String leftText, String rightText, BuildContext context,
      bool isDarkMode, bool isRightBold,
      {bool? isLoading}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          leftText,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: isDarkMode
                  ? AppColors.secondaryGrey
                  : AppColors.secondaryDarkerGrey,
              fontWeight: FontWeight.w500),
        ),
        if (isLoading != null && isLoading == true)
          ShimmerBox(
            width: 100,
            height: 15,
          ),
        if (isLoading == null)
          Text(
            rightText,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: isDarkMode
                    ? AppColors.primaryTextDark
                    : AppColors.primaryTextLight,
                fontWeight: isRightBold ? FontWeight.bold : null),
          )
      ],
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
