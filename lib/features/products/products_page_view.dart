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
                return Column(
                  children: [
                    // Filters Panel
                    _filtersPanel(context, isDarkMode, logger, filterData),
                    // Expanded Product Grid to avoid nested scrollable issue
                    Expanded(
                      child:
                          _productGrid(products, isDarkMode, logger, context),
                    ),
                  ],
                );
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

      List<String> selectedCategories = [];
      double? selectedLowestPrice;
      double? selectedHighestPrice;
      String? selectedBrand;
      String? selectedModel;
      int? selectedYear;
      bool isPriceRangeOn = false;
      if (state is FilterUIUpdated) {
        selectedCategories = state.selectedFilterData.selectedCategories;
        selectedLowestPrice = state.selectedFilterData.selectedLowestPrice;
        selectedHighestPrice = state.selectedFilterData.selectedHighestPrice;
        selectedBrand = state.selectedFilterData.selectedBrand;
        selectedModel = state.selectedFilterData.selectedModel;
        selectedYear = state.selectedFilterData.selectedYear;
        isPriceRangeOn = state.selectedFilterData.isPriceRangeOn;
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
                selectedCategories: selectedCategories,
                isPriceRangeOn: isPriceRangeOn,
                selectedLowestPrice: min,
                selectedHighestPrice: max,
                selectedBrand: selectedBrand,
                selectedModel: selectedModel,
                selectedYear: selectedYear,
              ),
            ));
      }

      onCategoryChanged(List<String> newCategories) {
        context.read<ProductsPageBloc>().add(UpdateFilterUI(
              productsPageData: products,
              selectedFilterData: SelectedFilterData(
                  selectedCategories: selectedCategories,
                  isPriceRangeOn: isPriceRangeOn,
                  selectedLowestPrice: selectedLowestPrice,
                  selectedHighestPrice: selectedHighestPrice,
                  selectedBrand: selectedBrand,
                  selectedModel: selectedModel,
                  selectedYear: selectedYear),
            ));
      }

      void onIsPriceRangeOn(bool newIsPriceRangeOn) {
        context.read<ProductsPageBloc>().add(UpdateFilterUI(
              productsPageData: products,
              selectedFilterData: SelectedFilterData(
                  selectedCategories: selectedCategories,
                  isPriceRangeOn: newIsPriceRangeOn,
                  selectedLowestPrice: selectedLowestPrice,
                  selectedHighestPrice: selectedHighestPrice,
                  selectedBrand: selectedBrand,
                  selectedModel: selectedModel,
                  selectedYear: selectedYear),
            ));
      }

      void onBrandChanged(String newBrandName) {
        context.read<ProductsPageBloc>().add(UpdateFilterUI(
              productsPageData: products,
              selectedFilterData: SelectedFilterData(
                  selectedCategories: selectedCategories,
                  isPriceRangeOn: isPriceRangeOn,
                  selectedLowestPrice: selectedLowestPrice,
                  selectedHighestPrice: selectedHighestPrice,
                  selectedBrand: newBrandName,
                  selectedModel: null,
                  selectedYear: null),
            ));
      }

      void onModelChanged(String newModelName) {
        context.read<ProductsPageBloc>().add(UpdateFilterUI(
              productsPageData: products,
              selectedFilterData: SelectedFilterData(
                  selectedCategories: selectedCategories,
                  isPriceRangeOn: isPriceRangeOn,
                  selectedLowestPrice: selectedLowestPrice,
                  selectedHighestPrice: selectedHighestPrice,
                  selectedBrand: selectedBrand,
                  selectedModel: newModelName,
                  selectedYear: null),
            ));
      }

      void onYearChanged(int newYear) {
        context.read<ProductsPageBloc>().add(UpdateFilterUI(
              productsPageData: products,
              selectedFilterData: SelectedFilterData(
                  selectedCategories: selectedCategories,
                  isPriceRangeOn: isPriceRangeOn,
                  selectedLowestPrice: selectedLowestPrice,
                  selectedHighestPrice: selectedHighestPrice,
                  selectedBrand: selectedBrand,
                  selectedModel: selectedModel,
                  selectedYear: newYear),
            ));
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
                    _categoryFilter(
                        context,
                        isDarkMode,
                        logger,
                        onCategoryChanged,
                        selectedCategories,
                        filterData.categories),
                    const Divider(thickness: 1.0, color: Colors.grey),
                    _priceRangeFilter(
                        isDarkMode,
                        context,
                        onPriceRangeChanged,
                        selectedLowestPrice ?? filterData.lowestPrice,
                        selectedHighestPrice ?? filterData.highestPrice,
                        onIsPriceRangeOn,
                        isPriceRangeOn,
                        filterData.lowestPrice,
                        filterData.highestPrice),
                    const Divider(thickness: 1.0, color: Colors.grey),
                    _compatibilityFilter(
                        isDarkMode,
                        context,
                        filterData.brands,
                        selectedBrand != null
                            ? filterData.getModelsForBrand(selectedBrand)
                            : [],
                        selectedModel != null
                            ? filterData.getYearsForModel(
                                selectedBrand!, selectedModel)
                            : null,
                        onBrandChanged,
                        onModelChanged,
                        onYearChanged),
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
      List<String> selectedCategories,
      List<String> categories) {
    onPressed() => showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: isDarkMode
                  ? AppColors.primaryForegroundLight
                  : AppColors.primaryForegroundDark,
              title: Text(
                AppLocalizations.of(context)!.selectCategories,
                style: TextStyle(
                    color: isDarkMode
                        ? AppColors.primaryForegroundDark
                        : AppColors.primaryTextOnSurfaceDark),
              ),
              content: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: categories.map((category) {
                      return CheckboxListTile(
                        title: Text(
                          category,
                          style: TextStyle(
                              color: isDarkMode
                                  ? AppColors.primaryForegroundDark
                                  : AppColors.primaryTextOnSurfaceDark),
                        ),
                        value: selectedCategories.contains(category),
                        checkColor: isDarkMode
                            ? AppColors.primaryTextOnSurfaceDark
                            : AppColors.primaryForegroundDark,
                        side: BorderSide(
                          color: isDarkMode
                              ? AppColors.primaryForegroundDark
                              : AppColors.accentDarkGrey!, // Border color
                          width: 2.0, // Border width
                        ),
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
                mainAxisAlignment: MainAxisAlignment.center,
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
      bool isPriceRangeOn,
      double databaseMinPrice,
      double databaseMaxPrice) {
    return Card(
      color: isDarkMode ? AppColors.accentDarkGrey : AppColors.lightGrey,
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
                onIsPriceRangeChanged(value);
              },
              activeColor:
                  isDarkMode ? AppColors.primaryDark : AppColors.primaryLight,
            ),
            if (isPriceRangeOn) // Show filter widgets only when the switch is ON
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RangeSlider(
                    values: RangeValues(minPrice, maxPrice),
                    min: databaseMinPrice,
                    max: databaseMaxPrice > 20000
                        ? (maxPrice > 20000 ? maxPrice : 20000)
                        : databaseMaxPrice,
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
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
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _compatibilityFilter(
      bool isDarkMode,
      BuildContext context,
      List<String> brandsList,
      List<String>? brandModels,
      List<String>? modelYears,
      void Function(String brand) onBrandChanged,
      void Function(String model) onModelChanged,
      void Function(int year) onYearChanged) {
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
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: SizedBox(
            width: sizedBoxWidths,
            child: DropdownButtonFormField<String>(
              value: brandsList.isNotEmpty ? brandsList.first : null,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12), // Rounded dropdown edges
                  borderSide: BorderSide(
                    color: isDarkMode
                        ? Colors.grey[700]!
                        : Colors.grey[300]!, // Border color
                  ),
                ),
                filled: true,
                fillColor: isDarkMode
                    ? Colors.grey[850]! // Slightly lighter for dark mode
                    : Colors.grey[200]!, // Slightly lighter for light mode
              ),
              dropdownColor: isDarkMode
                  ? Colors.grey[
                      850] // Lighter dropdown menu background for dark mode
                  : Colors.grey[
                      200], // Lighter dropdown menu background for light mode
              items: brandsList
                  .toSet()
                  .map((brand) => DropdownMenuItem(
                        value: brand,
                        child: Center(
                          // Centers the container within the dropdown menu
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15), // Spaced styling
                            width: MediaQuery.of(context).size.width *
                                0.33, // 1/3 width of the screen
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? Colors.grey[
                                      800]! // Dark grey for dark mode items
                                  : Colors.grey[
                                      300]!, // Light grey for light mode items
                              borderRadius: BorderRadius.circular(
                                  12), // Rounded container
                            ),
                            child: Center(
                              child: Text(
                                brand,
                                style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.white // White text for dark mode
                                      : Colors
                                          .black, // Black text for light mode
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ))
                  .toList(),
              onChanged: (value) {
                onBrandChanged(value!);
              },
              // Display the selected value as plain text in the button
              selectedItemBuilder: (BuildContext context) {
                return brandsList.map((brand) {
                  return Text(
                    brand,
                    style: TextStyle(
                      color: isDarkMode
                          ? Colors.white // White text for dark mode
                          : Colors.black, // Black text for light mode
                      fontSize: 14,
                      fontWeight: FontWeight.w400, // Button text styling
                    ),
                  );
                }).toList();
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
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: SizedBox(
            width: sizedBoxWidths,
            child: DropdownButtonFormField<String>(
              value:
                  brandModels?.isNotEmpty == true ? brandModels!.first : null,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12), // Rounded edges
                ),
                labelStyle: TextStyle(
                  color: isDarkMode
                      ? AppColors.primaryTextDark
                      : AppColors.primaryTextLight,
                ),
                labelText: AppLocalizations.of(context)!.selectModel,
              ),
              dropdownColor: isDarkMode
                  ? Colors.grey[
                      850] // Lighter dropdown menu background for dark mode
                  : Colors.grey[
                      200], // Lighter dropdown menu background for light mode
              style: TextStyle(
                color: isDarkMode
                    ? AppColors.primaryTextDark
                    : AppColors.primaryTextLight,
              ),
              items: brandModels == null
                  ? []
                  : brandModels
                      .toSet()
                      .map((model) => DropdownMenuItem(
                            value: model,
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                width: MediaQuery.of(context).size.width * 0.33,
                                decoration: BoxDecoration(
                                  color: isDarkMode
                                      ? Colors.grey[
                                          800]! // Dark mode item background
                                      : Colors.grey[
                                          300]!, // Light mode item background
                                  borderRadius: BorderRadius.circular(
                                      12), // Rounded corners
                                ),
                                child: Center(
                                  child: Text(
                                    model,
                                    style: TextStyle(
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ))
                      .toList(),
              onChanged: (model) {
                onModelChanged(model!);
              },
              selectedItemBuilder: (BuildContext context) {
                return brandModels == null
                    ? []
                    : brandModels.map((model) {
                        return Text(
                          model,
                          style: TextStyle(
                            color: isDarkMode
                                ? AppColors.primaryTextDark
                                : AppColors.primaryTextLight,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        );
                      }).toList();
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
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: SizedBox(
            width: sizedBoxWidths,
            child: DropdownButtonFormField<String>(
              value: modelYears?.isNotEmpty == true ? modelYears!.first : null,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12), // Rounded edges
                ),
                labelStyle: TextStyle(
                  color: isDarkMode
                      ? AppColors.primaryTextDark
                      : AppColors.primaryTextLight,
                ),
                labelText: AppLocalizations.of(context)!.selectYear,
              ),
              dropdownColor: isDarkMode
                  ? Colors.grey[
                      850] // Lighter dropdown menu background for dark mode
                  : Colors.grey[
                      200], // Lighter dropdown menu background for light mode
              style: TextStyle(
                color: isDarkMode
                    ? AppColors.primaryTextDark
                    : AppColors.primaryTextLight,
              ),
              items: modelYears == null
                  ? []
                  : modelYears
                      .toSet()
                      .map((year) => DropdownMenuItem(
                            value: year,
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                width: MediaQuery.of(context).size.width * 0.33,
                                decoration: BoxDecoration(
                                  color: isDarkMode
                                      ? Colors.grey[
                                          800]! // Dark mode item background
                                      : Colors.grey[
                                          300]!, // Light mode item background
                                  borderRadius: BorderRadius.circular(
                                      12), // Rounded corners
                                ),
                                child: Center(
                                  child: Text(
                                    year,
                                    style: TextStyle(
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ))
                      .toList(),
              onChanged: (year) {
                onYearChanged(int.parse(year!));
              },
              selectedItemBuilder: (BuildContext context) {
                return modelYears == null
                    ? []
                    : modelYears.map((year) {
                        return Text(
                          year,
                          style: TextStyle(
                            color: isDarkMode
                                ? AppColors.primaryTextDark
                                : AppColors.primaryTextLight,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        );
                      }).toList();
              },
            ),
          ),
        ),
      ],
    );
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
          logger: logger,
        );
      },
    );
  }
}
