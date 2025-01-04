import 'package:auto_parts_online/app/setup_dependencies.dart';
import 'package:auto_parts_online/common/components/default_buttons.dart';
import 'package:auto_parts_online/core/utils/app_logger.dart';
import 'package:flutter/material.dart';

import '../../core/models/account_address.dart';

class AddEditAddressPage extends StatefulWidget {
  final AccountAddress? initialAddress;
  final void Function(AccountAddress)? onAddressSaved;

  const AddEditAddressPage(
      {this.onAddressSaved, this.initialAddress, super.key});

  @override
  State<AddEditAddressPage> createState() => _AddEditAddressPageState();
}

class _AddEditAddressPageState extends State<AddEditAddressPage> {
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _landmarkController;
  late TextEditingController _phoneController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _addressController =
        TextEditingController(text: widget.initialAddress?.address ?? "");
    _cityController =
        TextEditingController(text: widget.initialAddress?.city ?? "");
    _landmarkController =
        TextEditingController(text: widget.initialAddress?.landMark ?? "");
    _phoneController = TextEditingController(
        text: widget.initialAddress?.phoneToContact ?? "");
  }

  @override
  Widget build(BuildContext context) {
    ILogger logger = getIt<ILogger>();
    return Scaffold(
      appBar: AppBar(
          title: const Text("Add/Edit Address",
              style: TextStyle(color: Colors.black))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextField(
                  controller: _addressController,
                  labelText: "Address",
                  validator: (value) =>
                      value!.isEmpty ? "Address is required" : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _cityController,
                  labelText: "City",
                  validator: (value) =>
                      value!.isEmpty ? "City is required" : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _landmarkController,
                  labelText: "Landmark",
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _phoneController,
                  labelText: "Phone Number",
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value!.isEmpty) return "Phone number is required";
                    if (!RegExp(r'^[0-9]{10,15}$').hasMatch(value)) {
                      return "Enter a valid phone number";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                SecondaryButton(
                  logger: logger,
                  onPressed: _saveAddress,
                  text: "Save Address",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.black),
        border: const OutlineInputBorder(),
      ),
      validator: validator,
    );
  }

  void _saveAddress() {
    if (_formKey.currentState!.validate()) {
      if (widget.onAddressSaved != null) {
        widget.onAddressSaved!(
          AccountAddress(
            addressId: widget.initialAddress?.addressId ?? -1,
            address: _addressController.text,
            city: _cityController.text,
            landMark: _landmarkController.text,
            phoneToContact: _phoneController.text,
            isLastUsed: true,
          ),
        );
      }
      Navigator.pop(
        context,
        AccountAddress(
          addressId: widget.initialAddress?.addressId ?? -1,
          address: _addressController.text,
          city: _cityController.text,
          landMark: _landmarkController.text,
          phoneToContact: _phoneController.text,
          isLastUsed: true,
        ),
      );
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _cityController.dispose();
    _landmarkController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
