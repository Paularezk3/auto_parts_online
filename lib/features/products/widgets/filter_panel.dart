import 'package:auto_parts_online/features/products/products_page_model.dart';
import 'package:flutter/material.dart';
import '../../../common/components/default_buttons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/app_logger.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FilterPanel extends StatelessWidget {
  final ILogger logger;
  final FilterData filterData;
  final void Function(List<String> newCategories) onCategoryChanged;
  final void Function(bool isPriceRangeOn) onIsPriceRangeOn;
  final void Function(double minPrice, double maxPrice) onPriceRangeChanged;
  final void Function(String brand) onBrandChanged;
  final void Function(String model) onModelChanged;
  final void Function(int year) onYearChanged;
  final SelectedFilterData selectedFilterData;
  final void Function() onResetFilterPressed;
  const FilterPanel(
      {required this.filterData,
      required this.logger,
      required this.onCategoryChanged,
      required this.onIsPriceRangeOn,
      required this.onPriceRangeChanged,
      required this.onBrandChanged,
      required this.onModelChanged,
      required this.onYearChanged,
      required this.selectedFilterData,
      required this.onResetFilterPressed,
      super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode
            ? const Color.fromARGB(255, 29, 16, 0)
            : AppColors.primaryForegroundDark,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            offset: const Offset(0, 2),
            blurRadius: 2,
          ),
        ],
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
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
                        selectedFilterData.selectedCategories,
                        filterData.categories),
                    const Divider(thickness: 1.0, color: Colors.grey),
                    _priceRangeFilter(
                        isDarkMode,
                        context,
                        onPriceRangeChanged,
                        selectedFilterData.selectedLowestPrice ??
                            filterData.lowestPrice,
                        selectedFilterData.selectedHighestPrice ??
                            filterData.highestPrice,
                        onIsPriceRangeOn,
                        selectedFilterData.isPriceRangeOn,
                        filterData.lowestPrice,
                        filterData.highestPrice),
                    const Divider(thickness: 1.0, color: Colors.grey),
                    _compatibilityFilter(
                        isDarkMode,
                        context,
                        filterData.brands,
                        selectedFilterData.selectedBrand != null
                            ? filterData.getModelsForBrand(
                                selectedFilterData.selectedBrand!)
                            : [],
                        selectedFilterData.selectedModel != null
                            ? filterData.getYearsForModel(
                                selectedFilterData.selectedBrand!,
                                selectedFilterData.selectedModel!)
                            : null,
                        onBrandChanged,
                        onModelChanged,
                        onYearChanged),
                    const SizedBox(height: 10),
                    SecondaryButton(
                      buttonSize: ButtonSize.small,
                      text: "Reset Filter",
                      logger: logger,
                      onPressed: onResetFilterPressed,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
                              : AppColors.accentDarkGrey, // Border color
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
}
