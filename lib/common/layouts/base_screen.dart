import 'package:auto_parts_online/app/routes/navigation_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app/routes/navigation_cubit.dart';
import '../../core/models/navigation_item_config.dart';
import '../widgets/default_navigation_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BaseScreen extends StatelessWidget {
  final int selectedIndex;
  final Widget child;
  final void Function()? anotherPageClicked;

  const BaseScreen({
    super.key,
    required this.selectedIndex,
    this.anotherPageClicked,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: DefaultNavigationBar(
        selectedIndex: selectedIndex,
        onItemTapped: (index) {
          if (index == selectedIndex) return;
          final config = _buildNavigationItems(context)[index];
          if (anotherPageClicked != null) anotherPageClicked!();
          config.navigate(context);
        },
        items: _buildNavigationItems(context).map((config) {
          return NavigationItemConfig(
              icon: config.icon,
              activeIcon: config.activeIcon,
              label: config.label,
              navigate: config.navigate);
        }).toList(),
      ),
    );
  }

  List<NavigationItemConfig> _buildNavigationItems(BuildContext context) {
    final cubit = context.read<NavigationCubit>();
    return [
      NavigationItemConfig(
        icon: const Icon(Icons.home_outlined),
        activeIcon: Icons.home,
        label: AppLocalizations.of(context)!.home,
        navigate: (context) => cubit.navigateTo(NavigationHomePageState()),
      ),
      NavigationItemConfig(
        icon: const Icon(Icons.category_outlined),
        activeIcon: Icons.category,
        label: AppLocalizations.of(context)!.products,
        navigate: (context) => cubit.push(NavigationProductPageState()),
      ),
      NavigationItemConfig(
        icon: const Icon(Icons.shopping_cart_outlined),
        activeIcon: Icons.shopping_cart,
        label: AppLocalizations.of(context)!.cart,
        navigate: (context) => cubit.push(NavigationCartPageState()),
      ),
      NavigationItemConfig(
        icon: const Icon(Icons.account_circle_outlined),
        activeIcon: Icons.account_circle,
        label: AppLocalizations.of(context)!.account,
        navigate: (context) => cubit.push(NavigationAccountPageState()),
      ),
    ];
  }
}
