import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocaleService {
  Future<Locale> getDeviceLocale() async {
    final Locale deviceLocale = PlatformDispatcher.instance.locale;

    // Check if any supported locale matches the device locale's language code
    final Locale matchingLocale = AppLocalizations.supportedLocales.firstWhere(
      (locale) => locale.languageCode == deviceLocale.languageCode,
      orElse: () => const Locale('ar'), // Fallback locale
    );

    return matchingLocale;
  }
}
