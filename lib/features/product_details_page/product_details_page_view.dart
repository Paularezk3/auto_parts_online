import 'package:auto_parts_online/app/routes/navigation_cubit.dart';
import 'package:auto_parts_online/app/routes/navigation_state.dart';
import 'package:auto_parts_online/app/setup_dependencies.dart';
import 'package:auto_parts_online/common/components/default_buttons.dart';
import 'package:auto_parts_online/core/models/guarantee_level.dart';
import 'package:auto_parts_online/core/models/stock_level.dart';
import 'package:auto_parts_online/common/layouts/default_appbar.dart';
import 'package:auto_parts_online/common/widgets/cart_button.dart';
import 'package:auto_parts_online/common/widgets/skeleton_loader.dart';
import 'package:auto_parts_online/core/constants/app_colors.dart';
import 'package:auto_parts_online/features/cart/app_level_cubit/cart_cubit.dart';
import 'package:auto_parts_online/features/cart/models/cart_model.dart';
import 'package:auto_parts_online/features/product_details_page/bloc/product_details_page_bloc.dart';
import 'package:auto_parts_online/features/product_details_page/bloc/product_details_page_state.dart';
import 'package:auto_parts_online/features/product_details_page/widgets/quantity_counter.dart';
import 'package:auto_parts_online/features/product_details_page/widgets/warranty_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../../common/components/stock_level_text.dart';
import '../../core/utils/app_logger.dart';
import '../cart/app_level_cubit/cart_state.dart';
import 'bloc/product_details_page_event.dart';
import 'product_details_page_model.dart';

class ProductDetailsPageView extends StatelessWidget {
  final int productId;
  const ProductDetailsPageView({required this.productId, super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    ILogger logger = getIt<ILogger>();

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        logger.trace(
            "Product Details Page Pop Scope Invoked\nReturning to ProductDetailsPageInitial",
            StackTrace.empty);
        context.read<ProductDetailsPageBloc>().add(ReturnToInitialState());
      },
      child: BlocBuilder<ProductDetailsPageBloc, ProductDetailsPageState>(
          buildWhen: (previous, current) {
        return (previous is ProductDetailsPageLoaded ||
                    previous is ProductDetailsPageLoading) &&
                current is ProductDetailsPageInitial
            ? false
            : (previous.runtimeType != current.runtimeType);
      }, builder: (context, state) {
        logger.trace("current state: $state", null);
        switch (state.runtimeType) {
          case const (ProductDetailsPageInitial):
            context
                .read<ProductDetailsPageBloc>()
                .add(LoadProductDetailsPage(productId));
            return _buildLoadingView(context);
          case const (ProductDetailsPageLoading):
            return _buildLoadingView(context);
          case const (ProductDetailsPageLoaded):
            return _buildLoadedView((state as ProductDetailsPageLoaded).product,
                context, isDarkMode, logger, state);
          case const (ProductDetailsPageError):
            return _buildErrorView(context, logger);
          default:
            return Scaffold(
              appBar: OtherPageAppBar(
                title: "title",
                isLoading: false,
                onBackTap: () => context.read<NavigationCubit>().pop(),
                showBackButton: true,
              ),
            );
        }
      }),
    );
  }

  Scaffold _buildLoadingView(BuildContext context) {
    return Scaffold(
      appBar: OtherPageAppBar(
        title: "title",
        isLoading: true,
        isTitleLoading: true,
        onBackTap: () => context.read<NavigationCubit>().pop(),
        showBackButton: true,
      ),
      body: SkeletonLoader(),
    );
  }

  Scaffold _buildLoadedView(
      ProductDetailsPageData product,
      BuildContext context,
      bool isDarkMode,
      ILogger logger,
      ProductDetailsPageLoaded state) {
    return Scaffold(
      appBar: OtherPageAppBar(
        title: product.title,
        isLoading: false,
        isTitleLoading: false,
        onBackTap: () => context.read<NavigationCubit>().pop(),
        showBackButton: true,
      ),
      body: Stack(children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image Gallery
              ProductImageGallery(images: product.carousel),

              // Product Details Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            product.productName,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        InkWell(
                            onTap: () => _showWarrantyDetails(
                                context, product.guaranteeLevel, isDarkMode),
                            child: WarrantyIcon(
                              withContainer: true,
                              margin: EdgeInsets.fromLTRB(12, 2, 0, 0),
                              guaranteeLevel: product.guaranteeLevel,
                              withInfoIcon: true,
                            ))
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      "E£ ${product.discountedPrice != null ? product.discountedPrice!.toStringAsFixed(2) : product.originalPrice.toStringAsFixed(2)}",
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    if (product.discountedPrice != null &&
                        product.originalPrice > product.discountedPrice!)
                      Text(
                        "E£ ${product.originalPrice.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 16,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: isDarkMode
                              ? AppColors.primaryTextDark
                              : AppColors.primaryTextLight,
                          color: Colors.grey,
                        ),
                      ),
                    const SizedBox(height: 8.0),
                    StockLevelText(stockLevel: product.stockLevel),
                    const SizedBox(height: 16.0),
                    BlocBuilder<ProductDetailsPageBloc,
                            ProductDetailsPageState>(
                        buildWhen: (previous, current) {
                      if (previous is ProductDetailsPageLoaded &&
                          current is ProductDetailsPageLoaded) {
                        return previous.quantityCounter !=
                            current.quantityCounter;
                      }
                      return false;
                    }, builder: (context, state) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          QuantityCounter(
                            counterValue: (state as ProductDetailsPageLoaded)
                                .quantityCounter,
                            onDecrement: () => context
                                .read<ProductDetailsPageBloc>()
                                .add(DecrementQuantityCounter()),
                            onIncrement: () => context
                                .read<ProductDetailsPageBloc>()
                                .add(IncrementQuantityCounter()),
                          ),
                          const SizedBox(width: 16),
                          PrimaryButton(
                            padding: 0,
                            logger: logger,
                            onPressed: product.stockLevel ==
                                        StockLevel.inStock ||
                                    product.stockLevel == StockLevel.limited
                                ? () {
                                    logger.trace(
                                        "product id: ${product.productId}, \nproduct price = ${product.discountedPrice ?? product.originalPrice}, \nquantity : ${state.quantityCounter}",
                                        StackTrace.empty);
                                    context.read<CartCubit>().addToCart(
                                        CartItem(
                                            id: product.productId,
                                            name: product.productName,
                                            price: product.discountedPrice ??
                                                product.originalPrice,
                                            quantity: state.quantityCounter));
                                  }
                                : null,
                            isEnabled:
                                product.stockLevel == StockLevel.inStock ||
                                        product.stockLevel == StockLevel.limited
                                    ? true
                                    : false,
                            text: product.stockLevel == StockLevel.inStock ||
                                    product.stockLevel == StockLevel.limited
                                ? "Add to Cart"
                                : "Out of Stock",
                          ),
                        ],
                      );
                    }),
                    const SizedBox(height: 16.0),
                    if (product.compatibility.isNotEmpty)
                      CompatibilitySection(
                          compatibility: product.compatibility),
                    const SizedBox(height: 20.0),
                    _descriptionSection(context, isDarkMode, product),
                    const SizedBox(height: 24.0),
                  ],
                ),
              ),

              // Customer Reviews Section
              if (product.reviews != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CustomerReviewsSection(reviews: product.reviews!),
                ),
              SizedBox(
                height: 40,
              )
            ],
          ),
        ),
        // Floating Cart Button
        BlocBuilder<CartCubit, CartState>(
          builder: (context, cartState) {
            if (cartState.items.isEmpty) {
              return const SizedBox.shrink(); // Hide button if cart is empty
            }
            return CartButton(
                itemCount: cartState.totalItems,
                totalPrice: cartState.totalPrice,
                onTap: () => context
                    .read<NavigationCubit>()
                    .push(NavigationCartPageState()));
          },
        ),
      ]),
    );
  }

  void _showWarrantyDetails(
      BuildContext context, GuaranteeLevel guaranteeLevel, bool isDarkMode) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (_, controller) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: guaranteeLevel == GuaranteeLevel.basic
                    ? (isDarkMode
                        ? AppColors.primaryForegroundLight
                        : AppColors.primaryForegroundDark)
                    : (guaranteeLevel == GuaranteeLevel.high
                        ? AppColors.secondaryForegroundLight
                        : AppColors.primaryGrey),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: ListView(
                controller: controller,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Warranty Details',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                    fontWeight:
                                        guaranteeLevel == GuaranteeLevel.high
                                            ? FontWeight.bold
                                            : null,
                                    color: guaranteeLevel == GuaranteeLevel.high
                                        ? (isDarkMode
                                            ? AppColors.primaryDark
                                            : AppColors.primaryLight)
                                        : isDarkMode
                                            ? AppColors.primaryForegroundDark
                                            : AppColors.primaryForegroundLight),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          WarrantyIcon(
                              withContainer: false,
                              guaranteeLevel: guaranteeLevel)
                        ],
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: isDarkMode
                              ? AppColors.primaryForegroundDark
                              : AppColors.primaryForegroundLight,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Coverage:',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'The warranty covers manufacturing defects for 1 year.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Exclusions:',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Does not cover accidental damage, water damage, or misuse.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Contact Us:',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'For more information, please call 1-800-WARRANTY or email support@example.com.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Column _descriptionSection(
      BuildContext context, bool isDarkMode, ProductDetailsPageData product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Description",
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black),
        ),
        const SizedBox(height: 16.0),
        HtmlWidget(
          product.description,
          textStyle: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildErrorView(BuildContext context, ILogger logger) {
    return Scaffold(
        appBar: OtherPageAppBar(
      title: "",
      isLoading: true,
      isTitleLoading: true,
      showBackButton: true,
      onBackTap: () => context.read<NavigationCubit>().pop(),
    ));
  }
}

// Placeholder widgets for components
class ProductImageGallery extends StatelessWidget {
  final List<CarouselData> images;

  const ProductImageGallery({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: PageView(
        children: images.map((image) {
          return Image.network(
            image.imageUrl,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image),
          );
        }).toList(),
      ),
    );
  }
}

class CompatibilitySection extends StatelessWidget {
  final List<String> compatibility;

  const CompatibilitySection({super.key, required this.compatibility});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Compatibility",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black),
        ),
        const SizedBox(height: 8.0),
        ...compatibility.map((item) => Text("• $item")),
      ],
    );
  }
}

class CustomerReviewsSection extends StatelessWidget {
  final List<Review> reviews;

  const CustomerReviewsSection({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Customer Reviews",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16.0),
        ...reviews.map((review) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  review.customerName,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 4.0),
                Text(review.comment),
                const Divider(),
              ],
            ),
          );
        }),
      ],
    );
  }
}
