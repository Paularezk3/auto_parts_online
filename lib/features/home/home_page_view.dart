// lib\features\home_page\home_page_view.dart

import 'package:auto_parts_online/app/routes/navigation_cubit.dart';
import 'package:auto_parts_online/app/routes/navigation_state.dart';
import 'package:auto_parts_online/common/components/default_product_card.dart';
import 'package:auto_parts_online/common/layouts/base_screen.dart';
import 'package:auto_parts_online/common/widgets/default_loading_widget.dart';
import 'package:auto_parts_online/common/widgets/skeleton_loader.dart';
import 'package:auto_parts_online/core/utils/app_logger.dart';
import 'package:auto_parts_online/features/home/bloc/home_page_bloc.dart';
import 'package:auto_parts_online/features/home/bloc/home_page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app/setup_dependencies.dart';
import '../../common/components/default_buttons.dart';
import '../../common/widgets/default_appbar.dart';
import '../../core/constants/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'bloc/home_page_event.dart';
import 'home_page_model.dart';

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  onCartTapped() {}

  @override
  Widget build(BuildContext context) {
    final logger = getIt<ILogger>();
    final String homePageTitle = AppLocalizations.of(context)!.homePageTitle;
    final homePageBackgroundColor =
        Theme.of(context).brightness == Brightness.light
            ? AppColors.secondaryForegroundLight
            : const Color.fromARGB(255, 10, 10, 10);
    return BaseScreen(
      selectedIndex: 0,
      child:
          BlocBuilder<HomePageBloc, HomePageState>(builder: (context, state) {
        if (state is HomePageInitial) {
          logger.trace("init HomePage", StackTrace.current);
          context.read<HomePageBloc>().add(LoadHomePageDataEvent());
          return const DefaultLoadingWidget();
        } else if (state is HomePageLoading) {
          logger.trace("HomePage Loading", StackTrace.current);
          return _buildHomePageLoadingUI(
            context,
            homePageTitle,
            homePageBackgroundColor,
            onCartTapped,
          );
        } else if (state is HomePageLoaded) {
          logger.trace("HomePage Loaded State", StackTrace.current);
          return _buildHomePageLoadedUI(homePageTitle, homePageBackgroundColor,
              context, logger, onCartTapped, state.homePageData,
              onSearchBarTap: () => context
                  .read<NavigationCubit>()
                  .navigateTo(NavigationSearchPageState()));
        } else if (state is HomePageError) {
          return _buildErrorUI(logger, context);
        }
        return const DefaultLoadingWidget();
      }),
    );
  }

  Scaffold _buildHomePageLoadedUI(
      String homePageTitle,
      Color homePageBackgroundColor,
      BuildContext context,
      ILogger logger,
      void Function()? onCartTap,
      HomePageData homePageData,
      {void Function()? onSearchBarTap}) {
    final navigatorKey = getIt<GlobalKey<NavigatorState>>();
    return Scaffold(
      appBar: HomePageAppBar(
        key: navigatorKey,
        isSearchMode: false,
        onCartTap: onCartTap,
        noOfItemsInCart: 3,
        isLoading: false,
        title: homePageTitle, // Localized title

        onSearchBarTap: onSearchBarTap,
      ),
      backgroundColor: homePageBackgroundColor,
      body: homePageBodyAfterLoading(context, logger, homePageData),
    );
  }

  Scaffold _buildHomePageLoadingUI(BuildContext context, String homePageTitle,
      Color homePageBackgroundColor, void Function()? onCartTap) {
    final navigatorKey = getIt<GlobalKey<NavigatorState>>();
    return Scaffold(
      appBar: HomePageAppBar(
        key: navigatorKey,
        isSearchMode: false,
        onCartTap: onCartTap,
        isLoading: true,
        title: homePageTitle, // Localized title
        onSearchBarTap: () => context
            .read<NavigationCubit>()
            .navigateTo(NavigationSearchPageState()),
      ),
      backgroundColor: homePageBackgroundColor,
      body: const SkeletonLoader(),
    );
  }

  Center _buildErrorUI(ILogger logger, BuildContext context) {
    return Center(
      child: PrimaryButton(
        logger: logger,
        text: AppLocalizations.of(context)!.reloadPage,
        onPressed: () {
          context.read<HomePageBloc>().add(LoadHomePageDataEvent());
        },
      ),
    );
  }

  Widget homePageBodyAfterLoading(
    BuildContext context,
    ILogger logger,
    HomePageData homePageData,
  ) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Section: Carousel Slider
          if (homePageData.carousel != null)
            _buildHeroSection(homePageData.carousel),

          // Featured Products Section
          _buildFeaturedProductsSection(
              isDarkMode, logger, homePageData.featuredProducts, context),

          // Categories Section
          _buildCategoriesSection(homePageData.categoryData, context),

          // Call-to-Action Section
          _buildCallToActionSection(logger, context),
        ],
      ),
    );
  }

  /// Hero Section: Small carousel slider with swipe gestures
  Widget _buildHeroSection(List<CarouselData>? carouselData) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: SizedBox(
        height: 180.0,
        child: PageView.builder(
          itemCount: carouselData!.length, // Number of banners
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  carouselData[index].imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Featured Products Section: Horizontal scrollable product cards
  Widget _buildFeaturedProductsSection(bool isDarkMode, ILogger logger,
      List<FeaturedProducts> featuredProducts, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.featuredProducts,
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          SizedBox(
            height: 220.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: featuredProducts.length, // Number of featured products
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 150,
                  child: DefaultProductCard(
                    brandLogoUrl: featuredProducts[index].brandImageUrl,
                    productImage: featuredProducts[index].imageUrl,
                    productName: featuredProducts[index].productName,
                    productPrice: featuredProducts[index].productPrice,
                    stockAvailability: featuredProducts[index].stockLevel,
                    onAddToCart: () {},
                    isDarkMode: isDarkMode,
                    logger: logger,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Categories Section: Grid of categories with icons and labels
  Widget _buildCategoriesSection(
      List<CategoryData> categoryData, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.categories,
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categoryData.length, // Number of categories
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              childAspectRatio: 3 / 2,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {},
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    categoryData[index].imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.broken_image,
                      size: 64,
                      color: Colors.grey,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Call-to-Action Section: Sign-up prompt with a banner
  Widget _buildCallToActionSection(ILogger logger, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        color: AppColors.primaryDark,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.signUpPromo,
                  style: const TextStyle(color: Colors.white, fontSize: 16.0),
                ),
              ),
              SecondaryButton(
                onPressed: () {},
                text: AppLocalizations.of(context)!.signUp,
                logger: logger,
                buttonSize: ButtonSize.small,
                padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
