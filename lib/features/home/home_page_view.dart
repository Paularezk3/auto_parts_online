// lib\features\home_page\home_page_view.dart

import 'package:auto_parts_online/app/routes/navigation_cubit.dart';
import 'package:auto_parts_online/app/routes/navigation_state.dart';
import 'package:auto_parts_online/common/layouts/base_screen.dart';
import 'package:auto_parts_online/common/widgets/confirmation_dialog.dart';
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
import '../../core/constants/app_gradients.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'bloc/home_page_event.dart';

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    final logger = getIt<ILogger>();
    final String homePageTitle = AppLocalizations.of(context)!.homePageTitle;
    final homePageBackgroundColor =
        Theme.of(context).brightness == Brightness.light
            ? AppColors.secondaryForegroundLight
            : AppColors.primaryForegroundLight;
    final onCartTapped = () {};
    return BaseScreen(
      selectedIndex: 0,
      child:
          BlocBuilder<HomePageBloc, HomePageState>(builder: (context, state) {
        if (state is HomePageInitial) {
          logger.debug("init HomePage");
          context.read<HomePageBloc>().add(LoadHomePageDataEvent());
          return const DefaultLoadingWidget();
        } else if (state is HomePageLoading) {
          logger.debug("HomePage Loading");
          return _buildHomePageLoadingUI(
              homePageTitle, homePageBackgroundColor);
        } else if (state is HomePageLoaded) {
          logger.debug("HomePage Loaded State");
          return _buildHomePageLoadedUI(
              homePageTitle, homePageBackgroundColor, context, logger);
        } else if (state is HomePageError) {
          return _buildErrorUI(logger, context);
        }
        return const DefaultLoadingWidget();
      }),
    );
  }

  Scaffold _buildHomePageLoadedUI(String homePageTitle,
      Color homePageBackgroundColor, BuildContext context, ILogger logger) {
    final navigatorKey = getIt<GlobalKey<NavigatorState>>();
    return Scaffold(
      appBar: HomePageAppBar(
        key: navigatorKey,
        isSearchMode: false,
        onCartTap: () {},
        noOfItemsInCart: 3,
        isLoading: false,
        title: homePageTitle, // Localized title
        onSearchBarTap: () => context
            .read<NavigationCubit>()
            .navigateTo(NavigationSearchPageState()),
      ),
      backgroundColor: homePageBackgroundColor,
      body: homePageBodyAfterLoading(context, logger),
    );
  }

  Scaffold _buildHomePageLoadingUI(
      String homePageTitle, Color homePageBackgroundColor) {
    final navigatorKey = getIt<GlobalKey<NavigatorState>>();
    return Scaffold(
      appBar: HomePageAppBar(
        key: navigatorKey,
        isSearchMode: false,
        onCartTap: () {},
        isLoading: true,
        title: homePageTitle, // Localized title
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

  Widget homePageBodyAfterLoading(BuildContext context, ILogger logger) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Section
          Row(
            children: [
              PrimaryButton(
                logger: logger,
                text: AppLocalizations.of(context)!
                    .buttonTesting, // Localized text
                buttonSize: ButtonSize.small,
                onPressed: () {
                  context
                      .read<NavigationCubit>()
                      .navigateTo(NavigationProductPageState());
                },
              ),
              SecondaryButton(
                logger: logger,
                text: AppLocalizations.of(context)!
                    .buttonTesting, // Localized text
                onPressed: () {},
                buttonSize: ButtonSize.small,
              ),
            ],
          ),
          Row(
            children: [
              PrimaryButton(
                logger: logger,
                text: AppLocalizations.of(context)!
                    .buttonTesting, // Localized text
                isEnabled: false,
                onPressed: () {},
              ),
              OutlinedPrimaryButton(
                logger: logger,
                text: AppLocalizations.of(context)!
                    .buttonTesting, // Localized text
                isEnabled: false,
                buttonSize: ButtonSize.small,
                onPressed: () {},
              ),
            ],
          ),
          OutlinedPrimaryButton(
            logger: logger,
            text: AppLocalizations.of(context)!.buttonTesting, // Localized text
            isEnabled: true,
            buttonSize: ButtonSize.big,
            onPressed: () {},
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              gradient: AppGradients.linearPrimarySecondary,
            ),
            child: Text(
              AppLocalizations.of(context)!.welcomeMessage, // Localized text
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryForegroundLight,
              ),
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText:
                    AppLocalizations.of(context)!.searchHint, // Localized text
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: AppColors.secondaryLight,
                  ),
                ),
                filled: true,
                fillColor: AppColors.secondaryForegroundLight,
              ),
            ),
          ),

          // Featured Products Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              AppLocalizations.of(context)!.featuredProducts, // Localized text
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryLight,
              ),
            ),
          ),
          GridView.builder(
            padding: const EdgeInsets.all(16.0),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 4,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: 6, // Replace with dynamic item count
            itemBuilder: (context, index) {
              return Card(
                elevation: 2.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              'https://via.placeholder.com/150',
                            ), // Replace with actual image URL
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        AppLocalizations.of(context)!
                            .productTitle(index), // Localized text
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        AppLocalizations.of(context)!
                            .productPrice(99.99), // Localized text
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: AppColors.accentLight,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryLight,
                        ),
                        child: Text(AppLocalizations.of(context)!
                            .addToCart), // Localized text
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Footer
          Container(
            padding: const EdgeInsets.all(16.0),
            color: AppColors.secondaryLight,
            child: Center(
              child: Text(
                AppLocalizations.of(context)!.footerMessage, // Localized text
                style: const TextStyle(
                  fontSize: 14.0,
                  color: AppColors.secondaryForegroundLight,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
