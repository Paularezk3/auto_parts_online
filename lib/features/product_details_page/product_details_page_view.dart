import 'package:auto_parts_online/app/setup_dependencies.dart';
import 'package:auto_parts_online/common/components/default_buttons.dart';
import 'package:auto_parts_online/common/models/guarantee_level.dart';
import 'package:auto_parts_online/common/models/stock_level.dart';
import 'package:auto_parts_online/common/widgets/default_appbar.dart';
import 'package:auto_parts_online/common/widgets/skeleton_loader.dart';
import 'package:auto_parts_online/core/constants/app_colors.dart';
import 'package:auto_parts_online/features/cart/app_level_cubit/cart_cubit.dart';
import 'package:auto_parts_online/features/cart/models/cart_model.dart';
import 'package:auto_parts_online/features/product_details_page/bloc/product_details_page_bloc.dart';
import 'package:auto_parts_online/features/product_details_page/bloc/product_details_page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../../core/utils/app_logger.dart';
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
          builder: (context, state) {
        if (state is ProductDetailsPageInitial) {
          context
              .read<ProductDetailsPageBloc>()
              .add(LoadProductDetailsPage(productId));
        } else if (state is ProductDetailsPageLoading) {
          return const Scaffold(
            appBar: OtherPageAppBar(
              title: "title",
              isLoading: true,
              isTitleLoading: true,
            ),
            body: SkeletonLoader(),
          );
        } else if (state is ProductDetailsPageLoaded) {
          final product = state.product;

          return Scaffold(
            appBar: OtherPageAppBar(
              title: product.title,
              isLoading: false,
              isTitleLoading: false,
            ),
            body: SingleChildScrollView(
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isDarkMode
                                      ? Colors.grey[800]
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: isDarkMode
                                          ? Colors.grey[600]!
                                          : Colors.grey[300]!,
                                      width: 1),
                                  boxShadow: [
                                    if (!isDarkMode)
                                      BoxShadow(
                                        color:
                                            Colors.grey.withValues(alpha: 0.2),
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    _buildWarrantyIcon(product.guaranteeLevel),
                                    const SizedBox(width: 8),
                                    Icon(Icons.info, color: Colors.grey[600]),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          "\$${product.discountedPrice != null ? product.discountedPrice!.toStringAsFixed(2) : product.originalPrice.toStringAsFixed(2)}",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        if (product.discountedPrice != null &&
                            product.originalPrice > product.discountedPrice!)
                          Text(
                            "\$${product.originalPrice.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 16,
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                            ),
                          ),
                        const SizedBox(height: 8.0),
                        Text(
                          product.stockLevel == StockLevel.inStock
                              ? "In Stock"
                              : (product.stockLevel == StockLevel.limited
                                  ? "Limited Stock"
                                  : "Out of Stock"),
                          style: TextStyle(
                            color: product.stockLevel == StockLevel.inStock
                                ? Colors.green
                                : (product.stockLevel == StockLevel.limited
                                    ? Colors.orange
                                    : Colors.red),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Align(
                          alignment: Alignment.center,
                          child: PrimaryButton(
                            logger: logger,
                            onPressed: product.stockLevel ==
                                        StockLevel.inStock ||
                                    product.stockLevel == StockLevel.limited
                                ? () {
                                    context.read<CartCubit>().addToCart(
                                        CartItem(
                                            id: product.productId,
                                            name: product.productName,
                                            price: product.discountedPrice ??
                                                product.originalPrice,
                                            quantity: 1));
                                  }
                                : null,
                            text: product.stockLevel == StockLevel.inStock ||
                                    product.stockLevel == StockLevel.limited
                                ? "Add to Cart"
                                : "Out of Stock",
                          ),
                        ),
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
                    height: 100,
                  )
                ],
              ),
            ),
          );
        }
        return const Scaffold(
          appBar: OtherPageAppBar(title: "title", isLoading: false),
        );
      }),
    );
  }

  Widget _buildWarrantyIcon(GuaranteeLevel guaranteeLevel) {
    switch (guaranteeLevel) {
      case GuaranteeLevel.basic:
        return _buildShieldIcon(
          color: Colors.grey, // Silver color
          gradient: LinearGradient(
            colors: [Colors.grey[300]!, Colors.grey[700]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        );
      case GuaranteeLevel.high:
        return _buildShieldIcon(
          color: Colors.amber, // Gold color or primary color
          gradient: LinearGradient(
            colors: [Colors.amber[300]!, Colors.amber[700]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        );
      default:
        return Container(); // Transparent
    }
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
                      Text(
                        'Warranty Details',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(
                                color: isDarkMode
                                    ? AppColors.primaryForegroundDark
                                    : AppColors.primaryForegroundLight),
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

  Widget _buildShieldIcon({required Color color, required Gradient gradient}) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: gradient,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Icon(Icons.shield, color: Colors.white, size: 16),
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
