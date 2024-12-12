import 'package:flutter/material.dart';
import '../../../common/components/default_buttons.dart';
import '../../../common/widgets/rounded_appbar.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_gradients.dart';

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const RoundedAppBar(
        title: "Home Page",
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Section
            Row(
              children: [
                PrimaryButton(
                  text: "Testing",
                  isLoading: true,
                  onPressed: () {},
                ),
                SecondaryButton(
                  text: "Testing",
                  onPressed: () {},
                ),
                PrimaryButton(
                  text: "Testing",
                  isEnabled: false,
                  onPressed: () {},
                ),
                OutlinedPrimaryButton(
                  text: "Testing",
                  isEnabled: false,
                  isLoading: true,
                  buttonSize: ButtonSize.small,
                  onPressed: () {},
                ),
              ],
            ),
            OutlinedPrimaryButton(
              text: "Testing",
              isEnabled: true,
              buttonSize: ButtonSize.big,
              onPressed: () {},
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                gradient: AppGradients.linearPrimarySecondary,
              ),
              child: const Text(
                "Welcome to Our Platform!",
                style: TextStyle(
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
                  hintText: "Search...",
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Featured Products",
                style: TextStyle(
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
                          "Product Title $index", // Replace dynamically
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "\$99.99", // Replace dynamically
                          style: TextStyle(
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
                          child: const Text("Add to Cart"),
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
              child: const Center(
                child: Text(
                  "© 2024 Your Company Name",
                  style: TextStyle(
                    fontSize: 14.0,
                    color: AppColors.secondaryForegroundLight,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: "Products",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: "Account",
          ),
        ],
        selectedItemColor: AppColors.primaryLight,
        unselectedItemColor: AppColors.secondaryForegroundLight,
      ),
    );
  }
}
