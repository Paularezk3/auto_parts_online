import 'package:auto_parts_online/app/setup_dependencies.dart';
import 'package:auto_parts_online/common/components/default_buttons.dart';
import 'package:auto_parts_online/core/utils/app_logger.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import '../../../core/models/account_address.dart';

class AddressSelectionModal extends StatelessWidget {
  final List<AccountAddress> addresses;
  final VoidCallback onAddNewAddress;
  final ValueChanged<AccountAddress> onEditAddress;

  const AddressSelectionModal({
    required this.addresses,
    required this.onAddNewAddress,
    required this.onEditAddress,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ILogger logger = getIt<ILogger>();
    return Padding(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          Text(
            "Select Shipping Address",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.black87,
                ),
          ),
          const SizedBox(height: 16),
          if (addresses.isNotEmpty)
            ...addresses.map((address) => ListTile(
                  title: Text(
                    address.address,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.black,
                        ),
                  ),
                  subtitle: Text(
                    "${address.city}, ${address.phoneToContact}",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.black54,
                        ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => onEditAddress(address),
                  ),
                )),
          if (addresses.isEmpty)
            GestureDetector(
              onTap: onAddNewAddress,
              child: DottedBorder(
                color: Colors.blueGrey,
                strokeWidth: 1,
                dashPattern: [6, 4],
                child: Container(
                  height: 100,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    "Add a new shipping address",
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 16),
          OutlinedPrimaryButton(
            logger: logger,
            onPressed: onAddNewAddress,
            text: "Add New Address",
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
