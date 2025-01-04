import 'package:auto_parts_online/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AddressCard extends StatelessWidget {
  final String address;
  final String city;
  final String phone;
  final VoidCallback onEdit;

  const AddressCard({
    required this.address,
    required this.city,
    required this.phone,
    required this.onEdit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // GPS Icon aligned to the top-left
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.location_on_rounded,
                  color: AppColors.primaryLight, // Adjust the color if needed
                  size: 24,
                ),
              ],
            ),
            const SizedBox(width: 8),
            // Address and Details in an Expanded Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    city,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  // const SizedBox(height: 2),
                  Text(
                    "Phone: $phone",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[700],
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: onEdit,
                child: const Text("Change"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
