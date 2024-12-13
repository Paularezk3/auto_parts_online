import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocaleService {
  Future<Locale> getDeviceLocale() async {
    final Locale deviceLocale = PlatformDispatcher.instance.locale;
    return AppLocalizations.supportedLocales.contains(deviceLocale)
        ? deviceLocale
        : const Locale('ar');
  }
}
