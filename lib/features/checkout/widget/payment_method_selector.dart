import 'package:auto_parts_online/core/constants/assets_path.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../checkout_page_model.dart';

class PaymentMethodSelector extends StatefulWidget {
  final PaymentWay? selectedMethod;
  final ValueChanged<PaymentWay> onPaymentMethodChanged;

  const PaymentMethodSelector({
    required this.selectedMethod,
    required this.onPaymentMethodChanged,
    super.key,
  });

  @override
  State<PaymentMethodSelector> createState() => _PaymentMethodSelectorState();
}

class _PaymentMethodSelectorState extends State<PaymentMethodSelector> {
  late PaymentWay? _selectedMethod;

  @override
  void initState() {
    super.initState();
    _selectedMethod = widget.selectedMethod;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: PaymentWay.values.map((method) {
        final isSelected = _selectedMethod == method;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(vertical: 5.0),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : AppColors.lightGrey,
            border: Border.all(
              color: isSelected
                  ? AppColors.primaryLight
                  : AppColors.secondaryGrey!,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: InkWell(
            onTap: () {
              if (method != _selectedMethod) {
                setState(() {
                  _selectedMethod = method;
                });
                widget.onPaymentMethodChanged(method);
              }
            },
            child: ListTile(
              leading: Radio<PaymentWay>(
                value: method,
                groupValue: _selectedMethod,
                onChanged: (PaymentWay? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedMethod = newValue;
                    });
                    widget.onPaymentMethodChanged(newValue);
                  }
                },
              ),
              title: Text(
                _getPaymentMethodName(method),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              trailing: _getPaymentMethodLogo(method),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _getPaymentMethodLogo(PaymentWay method) {
    switch (method) {
      case PaymentWay.cash:
        return SizedBox.shrink();
      case PaymentWay.instapay:
        return Image.asset(
          AssetsPath.instaPayLogo, // Replace with the correct asset path
          width: 32,
          height: 32,
        );
      case PaymentWay.vodafoneCash:
        return Image.asset(
          AssetsPath.vodafoneCashLogo, // Replace with the correct asset path
          width: 32,
          height: 32,
        );
    }
  }

  String _getPaymentMethodName(PaymentWay method) {
    switch (method) {
      case PaymentWay.cash:
        return "Cash";
      case PaymentWay.instapay:
        return "InstaPay";
      case PaymentWay.vodafoneCash:
        return "Vodafone Cash";
    }
  }
}
