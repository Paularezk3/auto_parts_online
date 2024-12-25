// lib/features/cart/cart_page_view.dart
import 'package:auto_parts_online/common/layouts/base_screen.dart';
import 'package:auto_parts_online/common/layouts/default_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/cart_page_bloc.dart';
import 'bloc/cart_page_event.dart';
import 'bloc/cart_page_state.dart';

class CartPageView extends StatelessWidget {
  const CartPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      selectedIndex: 2,
      child: Scaffold(
        appBar: OtherPageAppBar(title: "Cart", isLoading: false),
        body: BlocBuilder<CartPageBloc, CartPageState>(
          builder: (context, state) {
            if (state is CartPageInitial) {
              context.read<CartPageBloc>().add(LoadCartPage());
              return const Center(child: CircularProgressIndicator());
            } else if (state is CartPageLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CartPageLoaded) {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.items.length,
                      itemBuilder: (context, index) {
                        final item = state.items[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          child: ListTile(
                            leading: Image.network(
                              'https://via.placeholder.com/50x50',
                              fit: BoxFit.cover,
                            ),
                            title: Text(
                              item.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Row(
                              children: [
                                Text(
                                  '\$${item.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      decoration: TextDecoration.lineThrough),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '\$${(item.price * 0.9).toStringAsFixed(2)}',
                                  style: const TextStyle(color: Colors.green),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () {
                                    if (item.quantity > 1) {
                                      context.read<CartPageBloc>().add(
                                            AddItemToCart(
                                              item: item.copyWith(
                                                  quantity: item.quantity - 1),
                                            ),
                                          );
                                    } else {
                                      context.read<CartPageBloc>().add(
                                          RemoveItemFromCart(itemId: item.id));
                                    }
                                  },
                                ),
                                Text(item.quantity.toString()),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    context.read<CartPageBloc>().add(
                                          AddItemToCart(
                                            item: item.copyWith(
                                                quantity: item.quantity + 1),
                                          ),
                                        );
                                  },
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
                        Text(
                          'Subtotal: \$${state.totalPrice.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text("Proceed to Checkout"),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else if (state is CartPageError) {
              return Center(child: Text(state.message));
            }

            return const Center(child: Text("Your cart is empty."));
          },
        ),
      ),
    );
  }
}
