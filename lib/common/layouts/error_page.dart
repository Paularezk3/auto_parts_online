import 'package:auto_parts_online/core/utils/app_logger.dart';
import 'package:flutter/material.dart';

import '../components/default_buttons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ErrorPage extends StatelessWidget {
  final ILogger logger;
  final void Function() onButtonPressed;
  final String message;
  const ErrorPage(this.message,
      {required this.onButtonPressed, required this.logger, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(children: [
        const Icon(Icons.error_outline, color: Colors.red, size: 48),
        const SizedBox(height: 8),
        Text(
          message,
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        PrimaryButton(
          logger: logger,
          text: AppLocalizations.of(context)!.reloadPage,
          onPressed: onButtonPressed,
        ),
      ]),
    );
  }
}
