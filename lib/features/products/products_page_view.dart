import 'dart:ffi';

import 'package:auto_parts_online/app/setup_dependencies.dart';
import 'package:auto_parts_online/common/components/default_buttons.dart';
import 'package:auto_parts_online/common/components/default_product_card.dart';
import 'package:auto_parts_online/common/layouts/base_screen.dart';
import 'package:auto_parts_online/common/widgets/default_appbar.dart';
import 'package:auto_parts_online/common/widgets/skeleton_loader.dart';
import 'package:auto_parts_online/features/products/bloc/products_page_bloc.dart';
import 'package:auto_parts_online/features/products/bloc/products_page_event.dart';
import 'package:auto_parts_online/features/products/bloc/products_page_state.dart';
import 'package:auto_parts_online/features/products/products_page_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:logger/logger.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/app_logger.dart';
import '../../core/utils/hive_helper.dart';

class ProductsPageView extends StatelessWidget {
  const ProductsPageView({super.key});

  @override
  Widget build(BuildContext context) {
    ILogger logger = getIt<ILogger>();
    final productsPageBloc = context.read<ProductsPageBloc>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final hiveHelper = HiveHelper();
    hiveHelper.init(); // Initialize the helper
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
            title: AppLocalizations.of(context)!.products, isLoading: false),
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
              return current is FilterUIUpdated ? false : true;
            },
            builder: (context, state) {
              if (state is ProductsPageInitial ||
                  state is ProductsPageLoading) {
                return const SkeletonLoader();
              } else if (state is ProductsPageLoaded) {
                return Column(
                  children: [
                    // Filters Panel
                    _filtersPanel(context, isDarkMode, logger),
                    // Expanded Product Grid to avoid nested scrollable issue
                    Expanded(
                      child: _productGrid(
                          state.products.productsItems, isDarkMode, logger),
                    ),
                  ],
                );
              } else if (state is ProductsPageError) {
                return _scrollableContainer(
                    const Center(child: Text('Error: Loading The Page')),
                    context);
              }
              return _scrollableContainer(
                  const Center(child: Text('No products available.')), context);
            },
          ),
        ),
      ),
    );
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

  Widget _filtersPanel(BuildContext context, bool isDarkMode, ILogger logger) {
    return BlocBuilder<ProductsPageBloc, ProductsPageState>(
        buildWhen: (previous, current) {
      logger.trace("!!!current is $current", null);
      return current is FilterUIUpdated ? true : false;
    }, builder: (context, state) {
      if (state is! FilterUIUpdated) {
        logger.warning(
            "Filter UI Updated in state: $state", StackTrace.current);
      }
      final List<String>? selectedCategories;
      final Set<int>? priceRange;
      final String? brandName;
      final String? modelName;
      final int? year;
      final bool isPriceRangeOn;
      if (state is FilterUIUpdated) {
        selectedCategories = state.selectedCategories;
        priceRange = <int>{state.priceRange!.first, state.priceRange!.last};
        brandName = state.brandName;
        modelName = state.modelName;
        year = state.year;
        isPriceRangeOn = state.isPriceRangeOn;
      } else {
        selectedCategories = [];
        priceRange = <int>{500, 5000};
        brandName = "Mercedes";
        modelName = "C180";
        year = 2012;
        isPriceRangeOn = false;
      }
      onPriceRangeChanged(double min, double max) {
        context.read<ProductsPageBloc>().add(UpdateFilterUI(
            isPriceRangeOn: isPriceRangeOn,
            brandName: brandName,
            modelName: modelName,
            priceRange: <int>{min.toInt(), max.toInt()},
            selectedCategories: selectedCategories,
            year: year));
      }

      onCategoryChanged(List<String> newCategories) {
        context.read<ProductsPageBloc>().add(UpdateFilterUI(
            isPriceRangeOn: isPriceRangeOn,
            brandName: brandName,
            modelName: modelName,
            priceRange: priceRange,
            selectedCategories: newCategories,
            year: year));
      }

      void onIsPriceRangeOn(bool newIsPriceRangeOn) {
        context.read<ProductsPageBloc>().add(UpdateFilterUI(
            isPriceRangeOn: newIsPriceRangeOn,
            brandName: brandName,
            modelName: modelName,
            priceRange: priceRange,
            selectedCategories: selectedCategories,
            year: year));
      }

      return Card(
        margin: const EdgeInsets.all(12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        color: isDarkMode
            ? AppColors.accentDarkGrey
            : AppColors.accentForegroundDark,
        child: ExpansionTile(
          expansionAnimationStyle: AnimationStyle(
            duration: const Duration(milliseconds: 500),
            reverseDuration: const Duration(milliseconds: 500),
            curve: Curves.easeInOutCubic,
            reverseCurve: Curves.easeInOutCubic,
          ),
          trailing: Icon(
            Icons.filter_alt,
            color: isDarkMode ? AppColors.primaryDark : AppColors.primaryLight,
          ),
          title: Text(
            AppLocalizations.of(context)!.filters,
            style: TextStyle(
              color: isDarkMode
                  ? AppColors.primaryTextDark
                  : AppColors.primaryTextLight,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          childrenPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          children: [
            // Wrapping all children in a scrollable widget
            SizedBox(
              height:
                  MediaQuery.of(context).size.height * 0.5, // Restrict height
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _categoryFilter(context, isDarkMode, logger,
                        onCategoryChanged, selectedCategories!),
                    const Divider(thickness: 1.0, color: Colors.grey),
                    _priceRangeFilter(
                        isDarkMode,
                        context,
                        onPriceRangeChanged,
                        priceRange.first.toDouble(),
                        priceRange.last.toDouble(),
                        onIsPriceRangeOn,
                        isPriceRangeOn),
                    const Divider(thickness: 1.0, color: Colors.grey),
                    _compatibilityFilter(isDarkMode, context),
                    const SizedBox(height: 10),
                    PrimaryButton(
                      text: "Filter",
                      logger: logger,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _categoryFilter(
      BuildContext context,
      bool isDarkMode,
      ILogger logger,
      void Function(List<String> newCategories) onCategoryChanged,
      List<String> selectedCategories) {
    onPressed() => showDialog(
          context: context,
          builder: (context) {
            final categories = ['Engine', 'Body Parts', 'Accessories'];
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.selectCategories),
              content: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: categories.map((category) {
                      return CheckboxListTile(
                        title: Text(category),
                        value: selectedCategories.contains(category),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              selectedCategories.add(category);
                            } else {
                              selectedCategories.remove(category);
                            }
                          });
                        },
                      );
                    }).toList(),
                  );
                },
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    onCategoryChanged(selectedCategories);
                    Navigator.of(context).pop();
                    // Apply selected categories as filters
                  },
                  child: Text(AppLocalizations.of(context)!.done),
                ),
              ],
            );
          },
        );
    return ListTile(
      title: Text(
        AppLocalizations.of(context)!.category,
        style: TextStyle(
          color: isDarkMode
              ? AppColors.primaryTextDark
              : AppColors.primaryTextLight,
          fontWeight: FontWeight.bold,
        ),
      ),
      minTileHeight: selectedCategories.length > 3 ? 100 : 72,
      trailing: selectedCategories.isEmpty
          ? OutlinedPrimaryButton(
              logger: logger,
              buttonSize: ButtonSize.small,
              padding: const EdgeInsets.all(0),
              width: 150,
              onPressed: onPressed,
              text: AppLocalizations.of(context)!.selectCategories,
            )
          : SizedBox(
              width: 150, // Constrain the width of the trailing widget
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: onPressed,
                    child: Text(
                      selectedCategories.join(", "),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis, // Truncate with "..."
                      style: TextStyle(
                          decoration:
                              TextDecoration.underline, // Underlined text
                          decorationColor: isDarkMode
                              ? AppColors.primaryDark
                              : AppColors.primaryLight),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _priceRangeFilter(
      bool isDarkMode,
      BuildContext context,
      void Function(double minPrice, double maxPrice) onRangeChanged,
      double minPrice,
      double maxPrice,
      void Function(bool isPriceRangeOn) onIsPriceRangeChanged,
      bool isPriceRangeOn) {
    // Ensure valid min and max price values
    if (maxPrice < minPrice) {
      final temp = maxPrice;
      maxPrice = minPrice;
      minPrice = temp;
    }
    if (minPrice < 0) minPrice = 0;

    return Card(
      color: Colors.grey[850],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: Text(
                AppLocalizations.of(context)!.priceRange,
                style: TextStyle(
                  color: isDarkMode
                      ? AppColors.primaryTextDark
                      : AppColors.primaryTextLight,
                  fontWeight: FontWeight.bold,
                ),
              ),
              value: isPriceRangeOn,
              onChanged: (value) {
                Logger().t(value);
                onIsPriceRangeChanged(value);
              },
              activeColor:
                  isDarkMode ? AppColors.primaryDark : AppColors.primaryLight,
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              child: Column(
                children: [
                  if (isPriceRangeOn) // Show filter widgets only when the switch is ON
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RangeSlider(
                          values: RangeValues(minPrice, maxPrice),
                          min: 0,
                          max: maxPrice > 20000 ? maxPrice : 20000,
                          divisions: 200,
                          labels: RangeLabels(
                            minPrice.toStringAsFixed(0),
                            maxPrice >= 20000
                                ? "20000+"
                                : maxPrice.toStringAsFixed(0),
                          ),
                          onChanged: (values) {
                            minPrice = values.start;
                            maxPrice = values.end;
                            onRangeChanged(values.start, values.end);
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 80,
                              child: TextField(
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: "Min",
                                  labelStyle: TextStyle(
                                    color: isDarkMode
                                        ? AppColors.primaryTextDark
                                        : AppColors.primaryTextLight,
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                onSubmitted: (value) {
                                  onRangeChanged(double.parse(value), maxPrice);
                                },
                                controller: TextEditingController(
                                  text: minPrice.toStringAsFixed(0),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 80,
                              child: TextField(
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: 'Max',
                                  labelStyle: TextStyle(
                                    color: isDarkMode
                                        ? AppColors.primaryTextDark
                                        : AppColors.primaryTextLight,
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                onSubmitted: (value) {
                                  onRangeChanged(minPrice, double.parse(value));
                                },
                                controller: TextEditingController(
                                  text: maxPrice.toStringAsFixed(0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _compatibilityFilter(bool isDarkMode, BuildContext context) {
    const double sizedBoxWidths = 160;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(
            AppLocalizations.of(context)!.brand,
            style: TextStyle(
                color: isDarkMode
                    ? AppColors.primaryTextDark
                    : AppColors.primaryTextLight,
                fontWeight: FontWeight.bold),
          ),
          trailing: SizedBox(
            width: sizedBoxWidths,
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelStyle: TextStyle(
                    color: isDarkMode
                        ? AppColors.primaryTextDark
                        : AppColors.primaryTextLight),
                labelText: AppLocalizations.of(context)!.selectBrand,
              ),
              items: ['Toyota', 'Ford', 'BMW', 'Mercedes', 'Honda']
                  .map((brand) => DropdownMenuItem(
                        value: brand,
                        child: Text(brand),
                      ))
                  .toList(),
              onChanged: (value) {
                // Dynamically filter products by the selected brand
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
        ListTile(
          title: Text(
            AppLocalizations.of(context)!.model,
            style: TextStyle(
                color: isDarkMode
                    ? AppColors.primaryTextDark
                    : AppColors.primaryTextLight,
                fontWeight: FontWeight.bold),
          ),
          trailing: SizedBox(
            width: sizedBoxWidths,
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelStyle: TextStyle(
                    color: isDarkMode
                        ? AppColors.primaryTextDark
                        : AppColors.primaryTextLight),
                labelText: AppLocalizations.of(context)!.selectModel,
              ),
              items: ['Corolla', 'Camry', 'Focus']
                  .map((model) => DropdownMenuItem(
                        value: model,
                        child: Text(model),
                      ))
                  .toList(),
              onChanged: (model) {
                // Populate years based on selected model
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
        ListTile(
          title: Text(
            AppLocalizations.of(context)!.year,
            style: TextStyle(
                color: isDarkMode
                    ? AppColors.primaryTextDark
                    : AppColors.primaryTextLight,
                fontWeight: FontWeight.bold),
          ),
          trailing: SizedBox(
            width: sizedBoxWidths,
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelStyle: TextStyle(
                    color: isDarkMode
                        ? AppColors.primaryTextDark
                        : AppColors.primaryTextLight),
                labelText: AppLocalizations.of(context)!.selectYear,
              ),
              items: ['2020', '2021', '2022']
                  .map((year) => DropdownMenuItem(
                        value: year,
                        child: Text(year),
                      ))
                  .toList(),
              onChanged: (year) {
                // Dynamically filter products based on year
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _productGrid(
      List<ProductsItems> products, bool isDarkMode, ILogger logger) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return DefaultProductCard(
            productImage: product.imageUrl,
            productName: product.productName,
            productPrice: product.productPrice,
            stockAvailability: product.stockLevel,
            brandLogoUrl: product.brandImageUrl,
            onAddToCart: () {},
            isDarkMode: isDarkMode,
            logger: logger);
      },
    );
  }
}
