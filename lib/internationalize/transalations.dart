import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class Translations {
  Translations(this.locale) {
    _localizedValues = null;
  }

  Locale locale;
  static Map<dynamic, dynamic> _localizedValues;

  static Translations of(BuildContext context) {
    return Localizations.of<Translations>(context, Translations);
  }

  String text(String key) {
    return _localizedValues[key] ?? '** $key not found';
  }

  static Future<Translations> load(Locale locale,
      {String jsonContent, List<String> packages}) async {
    Translations translations = Translations(locale);
    _localizedValues ??= {};
    if (packages != null) {
      for (int i = 0; i < packages.length; i++) {
        Map<dynamic, dynamic> packageLocalizeValues =
            await _getPackageLocaleJson(packages[i], locale);
        if (packageLocalizeValues != null) {
          _localizedValues.addAll(packageLocalizeValues);
        }
      }
    }

    if (jsonContent != null) {
      _localizedValues.addAll(json.decode(jsonContent));
    }

    return translations;
  }

  static Future<Map<dynamic, dynamic>> _getPackageLocaleJson(
      String packageName, Locale locale) async {
    Map<dynamic, dynamic> packageLocalizeValues;
    String localeJson = await rootBundle.loadString("locale/i20n_en.json");
    try {
      packageLocalizeValues = json.decode(localeJson);
    } catch (e) {
//      print("Invaid locale json");
    }
    return packageLocalizeValues;
  }

  String get currentLanguage => locale.languageCode;
}

class TranslationsDelegate extends LocalizationsDelegate<Translations> {
  final List<String> packages;

  TranslationsDelegate({@required this.packages});

  @override
  bool isSupported(Locale locale) => ['en', 'fr'].contains(locale.languageCode);

  @override
  Future<Translations> load(Locale locale) {
    return Translations.load(locale, packages: packages);
  }

  @override
  bool shouldReload(TranslationsDelegate old) => false;
}
