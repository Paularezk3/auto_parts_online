// Create a new StatelessWidget for PaymentMethodSelector
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../checkout_page_model.dart';

class PaymentMethodSelector extends StatefulWidget {
  final PaymentWay selectedMethod;
  final String? instapayLink;
  final ValueChanged<PaymentWay> onPaymentMethodChanged;

  const PaymentMethodSelector({
    required this.selectedMethod,
    this.instapayLink,
    required this.onPaymentMethodChanged,
    super.key,
  });

  @override
  State<PaymentMethodSelector> createState() => _PaymentMethodSelectorState();
}

class _PaymentMethodSelectorState extends State<PaymentMethodSelector> {
  late PaymentWay _selectedMethod;

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
              subtitle: isSelected ? _getPaymentMethodDetails(method) : null,
            ),
          ),
        );
      }).toList(),
    );
  }

  String _getPaymentMethodName(PaymentWay method) {
    switch (method) {
      case PaymentWay.cash:
        return "Cash";
      case PaymentWay.instapay:
        return "InstaPay";
      case PaymentWay.vodafoneCash:
        return "Vodafone Cash";
      // default:
      //   return "Unknown";
    }
  }

  Widget _getPaymentMethodDetails(PaymentWay method) {
    switch (method) {
      case PaymentWay.instapay:
        return _buildNote(
            "Use the InstaPay link to complete your payment securely. Don't worry, our team will verify the payment.",
            method);
      case PaymentWay.vodafoneCash:
        return _buildNote(
            "Copy the Vodafone Cash number and send the amount. Rest assured, our team will confirm the transaction.",
            method);
      default:
        return SizedBox.shrink();
    }
  }

  Widget _buildNote(String message, PaymentWay method) {
    switch (method) {
      case PaymentWay.instapay:
        return Container(
          margin: const EdgeInsets.only(top: 8.0),
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.green),
          ),
          child: Row(
            children: [
              const Icon(Icons.info, color: Colors.green),
              const SizedBox(width: 8),
              Expanded(
                  child: Text(message, style: TextStyle(color: Colors.green))),
            ],
          ),
        );
      default:
        return Container(
          margin: const EdgeInsets.only(top: 8.0),
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.blue),
          ),
          child: Row(
            children: [
              const Icon(Icons.info, color: Colors.blue),
              const SizedBox(width: 8),
              Expanded(
                  child: Text(message, style: TextStyle(color: Colors.blue))),
            ],
          ),
        );
    }
  }
}
