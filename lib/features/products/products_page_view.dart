import 'package:auto_parts_online/app/routes/navigation_cubit.dart';
import 'package:auto_parts_online/app/routes/navigation_state.dart';
import 'package:auto_parts_online/common/widgets/default_appbar.dart';
import 'package:auto_parts_online/core/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/setup_dependencies.dart';

class ProductsPageView extends StatelessWidget {
  const ProductsPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final logger = getIt<ILogger>();
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        context.read<NavigationCubit>().navigateTo(NavigationHomePageState());
        if (didPop) {
          logger.debug("ProductsPage Didn't Ppp");
        }
      },
      child: Scaffold(
        appBar: OtherPageAppBar(
          title: "Products Page",
          showBackButton: true,
          onBackTap: () => context
              .read<NavigationCubit>()
              .navigateTo(NavigationHomePageState()),
        ),
      ),
    );
  }
}
