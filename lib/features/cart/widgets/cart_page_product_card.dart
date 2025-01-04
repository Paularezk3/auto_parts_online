import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/components/quantity_counter.dart';
import '../../../core/constants/app_colors.dart';
import '../bloc/cart_page_bloc.dart';
import '../bloc/cart_page_event.dart';
import '../models/cart_model.dart';
import '../models/cart_page_model.dart';

class CartPageProductCard extends StatelessWidget {
  const CartPageProductCard(
      {super.key, required this.item, required this.isLoading});
  final bool isLoading;
  final CartPageItem item;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Colors.grey[200],
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section - 1/6 of the card width
              Flexible(
                flex: 3, // Allocates 1 part of the space
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: AspectRatio(
                    aspectRatio: 1, // Ensures the image remains square
                    child: Image.network(
                      'https://via.placeholder.com/300x300',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              // Product Details Section - 5/6 of the card width
              Flexible(
                flex: 7, // Allocates 5 parts of the space
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                        // style: TextStyle(
                        //   fontWeight: FontWeight.bold,
                        //   color: AppColors.primaryTextLight,
                        // ),
                      ),
                      const SizedBox(height: 4),
                      if (item.priceAfterDiscount != null) ...[
                        Text(
                          'E£ ${(item.priceAfterDiscount!).toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                      Text(
                        'E£ ${item.priceBeforeDiscount.toStringAsFixed(2)}',
                        style: TextStyle(
                          decoration: item.priceAfterDiscount != null
                              ? TextDecoration.lineThrough
                              : null,
                          decorationColor: AppColors.primaryTextLight,
                          color: AppColors.secondaryDarkerGrey,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Quantity Counter Section
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
                                      productId: item.productId,
                                    ),
                                  ),
                                );
                          },
                          canBeDeleted: true,
                          onDeleteItem: () {
                            if (isLoading) return;
                            context.read<CartPageBloc>().add(
                                  RemoveItemFromCart(
                                    itemId: item.productId,
                                  ),
                                );
                          },
                          onDecrement: () {
                            if (isLoading) return;
                            if (item.quantity > 1) {
                              context.read<CartPageBloc>().add(
                                    ReduceItemFromCart(
                                      quantity: 1,
                                      itemId: item.productId,
                                    ),
                                  );
                            } else {
                              context.read<CartPageBloc>().add(
                                  RemoveItemFromCart(itemId: item.productId));
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
