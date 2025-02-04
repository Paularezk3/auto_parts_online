import 'package:auto_parts_online/app/setup_dependencies.dart';
import 'package:auto_parts_online/common/widgets/default_product_card.dart';
import 'package:auto_parts_online/common/layouts/base_screen.dart';
import 'package:auto_parts_online/common/layouts/default_appbar.dart';
import 'package:auto_parts_online/common/widgets/skeleton_loader.dart';
import 'package:auto_parts_online/features/cart/app_level_cubit/cart_cubit.dart';
import 'package:auto_parts_online/features/cart/models/cart_model.dart';
import 'package:auto_parts_online/features/products/bloc/products_page_bloc.dart';
import 'package:auto_parts_online/features/products/bloc/products_page_event.dart';
import 'package:auto_parts_online/features/products/bloc/products_page_state.dart';
import 'package:auto_parts_online/features/products/products_page_model.dart';
import 'package:auto_parts_online/features/products/widgets/filter_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../app/routes/navigation_cubit.dart';
import '../../app/routes/navigation_state.dart';
import '../../common/widgets/cart_button.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_logger.dart';
import '../cart/app_level_cubit/cart_state.dart';

class ProductsPageView extends StatelessWidget {
  const ProductsPageView({super.key});

  @override
  Widget build(BuildContext context) {
    ILogger logger = getIt<ILogger>();
    final productsPageBloc = context.read<ProductsPageBloc>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Ensure the event is dispatched outside the build phase
    if (productsPageBloc.state is ProductsPageInitial) {
      logger.trace(
          "Current State: ${productsPageBloc.state}\nAdding LoadProductsPage event",
          StackTrace.current);
      productsPageBloc.add(LoadProductsPage());
    }
    return BaseScreen(
      selectedIndex: 1,
      child: Scaffold(
        appBar: OtherPageAppBar(
            withShadow: false,
            title: AppLocalizations.of(context)!.products,
            isLoading: false),
        body: RefreshIndicator(
          onRefresh: () async {
            productsPageBloc.add(LoadProductsPage());
          },
          backgroundColor: isDarkMode
              ? AppColors.accentDarkGrey
              : AppColors.secondaryForegroundLight,
          color: isDarkMode ? AppColors.primaryDark : AppColors.primaryLight,
          displacement: 15,
          child: BlocBuilder<ProductsPageBloc, ProductsPageState>(
            buildWhen: (previous, current) {
              if (current is FilterUIUpdated && previous is FilterUIUpdated) {
                return current.products !=
                    previous.products; // Rebuild only if products change
              }
              return current is! FilterUIUpdated; // Ignore filter-only updates
            },
            builder: (context, state) {
              if (state is ProductsPageInitial ||
                  state is ProductsPageLoading) {
                return const SkeletonLoader();
              } else if (state is ProductsPageLoaded ||
                  state is FilterUIUpdated) {
                FilterData filterData = (state is FilterUIUpdated)
                    ? state.products.filterData
                    : (state as ProductsPageLoaded).products.filterData;
                List<ProductsItems> products = state is ProductsPageLoaded
                    ? state.products.productsItems
                    : (state as FilterUIUpdated).products.productsItems;
                return _buildProductsPageLoaded(
                    context, isDarkMode, logger, filterData, products);
              } else if (state is ProductsPageError) {
                return _scrollableContainer(
                    const Center(child: Text('Error: Loading The Page')),
                    context);
              } else if (state is FilterUIUpdated) {}
              return _scrollableContainer(
                  const Center(child: Text('No products available.')), context);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProductsPageLoaded(BuildContext context, bool isDarkMode,
      ILogger logger, FilterData filterData, List<ProductsItems> products) {
    return Stack(children: [
      Column(
        children: [
          // Filters Panel
          _filtersPanel(context, isDarkMode, logger, filterData),
          // Expanded Product Grid to avoid nested scrollable issue
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: _productGrid(products, isDarkMode, logger, context),
            ),
          ),
        ],
      ),
      BlocBuilder<CartCubit, CartState>(builder: (context, cartState) {
        if (cartState.items.isEmpty) {
          return const SizedBox.shrink();
        } else {
          return CartButton(
              isLoading: cartState is CartLoadingState,
              itemCount: cartState.totalItems,
              totalPrice: cartState.totalPriceAfterDiscount,
              onTap: () => context
                  .read<NavigationCubit>()
                  .push(NavigationCartPageState()));
        }
      })
    ]);
  }

  Widget _scrollableContainer(Widget child, context) {
    return SingleChildScrollView(
      physics:
          const AlwaysScrollableScrollPhysics(), // Ensures refresh gesture works
      child: ConstrainedBox(
        constraints:
            BoxConstraints(minHeight: MediaQuery.of(context).size.height),
        child: Center(
            child: child), // Center aligns content like loaders or errors
      ),
    );
  }

  Widget _filtersPanel(BuildContext context, bool isDarkMode, ILogger logger,
      FilterData filterData) {
    return BlocBuilder<ProductsPageBloc, ProductsPageState>(
        buildWhen: (previous, current) {
      return current is FilterUIUpdated; // Rebuild only when filters change
    }, builder: (context, state) {
      if (state is! FilterUIUpdated) {
        logger.warning(
            "Filter UI Updated in state: $state", StackTrace.current);
      }

      SelectedFilterData selectedFilterData = SelectedFilterData(
          selectedCategories: [],
          isPriceRangeOn: false,
          selectedLowestPrice: null,
          selectedHighestPrice: null,
          selectedBrand: null,
          selectedModel: null,
          selectedYear: null);
      if (state is FilterUIUpdated) {
        selectedFilterData = SelectedFilterData(
            selectedCategories: state.selectedFilterData.selectedCategories,
            isPriceRangeOn: state.selectedFilterData.isPriceRangeOn,
            selectedLowestPrice: state.selectedFilterData.selectedLowestPrice,
            selectedHighestPrice: state.selectedFilterData.selectedHighestPrice,
            selectedBrand: state.selectedFilterData.selectedBrand,
            selectedModel: state.selectedFilterData.selectedModel,
            selectedYear: state.selectedFilterData.selectedYear);
      }

      final products = (state is FilterUIUpdated)
          ? state.products
          : (state as ProductsPageLoaded).products;

      onPriceRangeChanged(double min, double max) {
        // Ensure valid min and max price values
        if (max < min) {
          final temp = max;
          max = min;
          min = temp;
        }
        if (min < 0) min = 0;

        context.read<ProductsPageBloc>().add(UpdateFilterUI(
              productsPageData: products,
              selectedFilterData: SelectedFilterData(
                selectedCategories: selectedFilterData.selectedCategories,
                isPriceRangeOn: selectedFilterData.isPriceRangeOn,
                selectedLowestPrice: min,
                selectedHighestPrice: max,
                selectedBrand: selectedFilterData.selectedBrand,
                selectedModel: selectedFilterData.selectedModel,
                selectedYear: selectedFilterData.selectedYear,
              ),
            ));
      }

      onCategoryChanged(List<String> newCategories) {
        context.read<ProductsPageBloc>().add(UpdateFilterUI(
              productsPageData: products,
              selectedFilterData: SelectedFilterData(
                  selectedCategories: selectedFilterData.selectedCategories,
                  isPriceRangeOn: selectedFilterData.isPriceRangeOn,
                  selectedLowestPrice: selectedFilterData.selectedLowestPrice,
                  selectedHighestPrice: selectedFilterData.selectedHighestPrice,
                  selectedBrand: selectedFilterData.selectedBrand,
                  selectedModel: selectedFilterData.selectedModel,
                  selectedYear: selectedFilterData.selectedYear),
            ));
      }

      void onIsPriceRangeOn(bool newIsPriceRangeOn) {
        context.read<ProductsPageBloc>().add(UpdateFilterUI(
              productsPageData: products,
              selectedFilterData: SelectedFilterData(
                  selectedCategories: selectedFilterData.selectedCategories,
                  isPriceRangeOn: newIsPriceRangeOn,
                  selectedLowestPrice: selectedFilterData.selectedLowestPrice,
                  selectedHighestPrice: selectedFilterData.selectedHighestPrice,
                  selectedBrand: selectedFilterData.selectedBrand,
                  selectedModel: selectedFilterData.selectedModel,
                  selectedYear: selectedFilterData.selectedYear),
            ));
      }

      void onBrandChanged(String newBrandName) {
        context.read<ProductsPageBloc>().add(UpdateFilterUI(
              productsPageData: products,
              selectedFilterData: SelectedFilterData(
                  selectedCategories: selectedFilterData.selectedCategories,
                  isPriceRangeOn: selectedFilterData.isPriceRangeOn,
                  selectedLowestPrice: selectedFilterData.selectedLowestPrice,
                  selectedHighestPrice: selectedFilterData.selectedHighestPrice,
                  selectedBrand: newBrandName,
                  selectedModel: null,
                  selectedYear: null),
            ));
      }

      void onModelChanged(String newModelName) {
        context.read<ProductsPageBloc>().add(UpdateFilterUI(
              productsPageData: products,
              selectedFilterData: SelectedFilterData(
                  selectedCategories: selectedFilterData.selectedCategories,
                  isPriceRangeOn: selectedFilterData.isPriceRangeOn,
                  selectedLowestPrice: selectedFilterData.selectedLowestPrice,
                  selectedHighestPrice: selectedFilterData.selectedHighestPrice,
                  selectedBrand: selectedFilterData.selectedBrand,
                  selectedModel: newModelName,
                  selectedYear: null),
            ));
      }

      void onYearChanged(int newYear) {
        context.read<ProductsPageBloc>().add(UpdateFilterUI(
              productsPageData: products,
              selectedFilterData: SelectedFilterData(
                  selectedCategories: selectedFilterData.selectedCategories,
                  isPriceRangeOn: selectedFilterData.isPriceRangeOn,
                  selectedLowestPrice: selectedFilterData.selectedLowestPrice,
                  selectedHighestPrice: selectedFilterData.selectedHighestPrice,
                  selectedBrand: selectedFilterData.selectedBrand,
                  selectedModel: selectedFilterData.selectedModel,
                  selectedYear: newYear),
            ));
      }

      void onResetFilterPressed() {
        selectedFilterData = SelectedFilterData(
            selectedCategories: [],
            isPriceRangeOn: false,
            selectedLowestPrice: null,
            selectedHighestPrice: null,
            selectedBrand: null,
            selectedModel: null,
            selectedYear: null);

        context.read<ProductsPageBloc>().add(UpdateFilterUI(
            productsPageData: products,
            selectedFilterData: selectedFilterData));
      }

      return FilterPanel(
        onCategoryChanged: onCategoryChanged,
        onIsPriceRangeOn: onIsPriceRangeOn,
        onPriceRangeChanged: onPriceRangeChanged,
        onBrandChanged: onBrandChanged,
        onModelChanged: onModelChanged,
        onYearChanged: onYearChanged,
        filterData: filterData,
        logger: logger,
        selectedFilterData: selectedFilterData,
        onResetFilterPressed: onResetFilterPressed,
      );
    });
  }

  Widget _productGrid(List<ProductsItems> products, bool isDarkMode,
      ILogger logger, BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200, // Maximum width for each grid item
        mainAxisExtent:
            250, // Height of each grid item (optional, adjust as needed)
        crossAxisSpacing: 10, // Spacing between columns
        mainAxisSpacing: 10, // Spacing between rows
      ),
      itemCount: products.length + 2,
      itemBuilder: (context, index) {
        if (index > products.length - 1) {
          return const SizedBox.shrink();
        }
        final product = products[index];
        return DefaultProductCard(
          onProductTap: () => context
              .read<NavigationCubit>()
              .push(NavigationProductDetailsPageState(product.productId)),
          productImage: product.imageUrl,
          productName: product.productName,
          productPrice: product.productPrice,
          stockAvailability: product.stockLevel,
          brandLogoUrl: product.brandImageUrl,
          onAddToCart: () => context.read<CartCubit>().addToCart(CartItem(
                quantity: 1,
                productId: product.productId,
              )),
          isDarkMode: isDarkMode,
          logger: logger,
        );
      },
    );
  }
}
