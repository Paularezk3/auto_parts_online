import 'package:auto_parts_online/app/routes/navigation_cubit.dart';
import 'package:auto_parts_online/app/routes/navigation_state.dart';
import 'package:auto_parts_online/core/models/navigation_item_config.dart';
import 'package:auto_parts_online/common/widgets/default_navigation_bar.dart';
import 'package:auto_parts_online/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DefaultNavigationBar', () {
    testWidgets('renders correctly with light theme',
        (WidgetTester tester) async {
      final items = [
        NavigationItemConfig(
            icon: const Icon(Icons.home_outlined),
            activeIcon: Icons.home,
            label: 'Home',
            navigate: (c) {}),
        NavigationItemConfig(
            icon: const Icon(Icons.category_outlined),
            activeIcon: Icons.category,
            label: 'Categories',
            navigate: (c) {}),
      ];

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: DefaultNavigationBar(
            selectedIndex: 0,
            onItemTapped: (_) {},
            items: items,
          ),
        ),
      );

      final navBar =
          tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(navBar.backgroundColor, AppColors.secondaryForegroundLight);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Categories'), findsOneWidget);
    });

    testWidgets('applies dark theme correctly', (WidgetTester tester) async {
      final items = [
        NavigationItemConfig(
            icon: const Icon(Icons.home_outlined),
            activeIcon: Icons.home,
            label: 'Home',
            navigate: (c) {}),
        NavigationItemConfig(
            icon: const Icon(Icons.category_outlined),
            activeIcon: Icons.category,
            label: 'Categories',
            navigate: (c) {}),
      ];

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: DefaultNavigationBar(
            selectedIndex: 0,
            onItemTapped: (_) {},
            items: items,
          ),
        ),
      );

      final navBar =
          tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
      expect(navBar.backgroundColor, AppColors.secondaryForegroundDark);
    });

    testWidgets('triggers onItemTapped callback', (WidgetTester tester) async {
      int tappedIndex = -1;

      final items = [
        NavigationItemConfig(
          icon: const Icon(Icons.home_outlined),
          activeIcon: Icons.home,
          label: 'Home',
          navigate: (context) {
            context.read<NavigationCubit>().push(NavigationHomePageState());
          },
        ),
        NavigationItemConfig(
          icon: const Icon(Icons.category_outlined),
          activeIcon: Icons.category,
          label: 'Categories',
          navigate: (context) {
            context.read<NavigationCubit>().push(NavigationHomePageState());
          },
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: DefaultNavigationBar(
            selectedIndex: 0,
            onItemTapped: (index) => tappedIndex = index,
            items: items,
          ),
        ),
      );

      // Simulate tapping the second item
      await tester.tap(find.byIcon(Icons.category_outlined));
      await tester.pumpAndSettle();

      // Verify the correct index was tapped
      expect(tappedIndex, 1);
    });
  });
}
