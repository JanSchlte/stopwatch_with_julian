import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

//Dies ist die Klasse, wo die json Dateien unter lib\locale decoded werden
//Tatsächlich habe ich die Klasse aber so von einer Website übernommen, weshalb ich zu den einzelnen Code-Lines gar nicht so viel sagen kann. Da ich für die
//Internationalisierung der App nicht viel Zeit hatte, war mir dieser Lösungsansatz durchaus Recht.

class Translations {
  Translations(Locale locale) {
    this.locale = locale;
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

  static Future<Translations> load(Locale locale) async {
    //async Programming ermöglicht es, dass das die Funktion parallel zum Skript ausgeführt wird (sonst würde das Skript auf das Beenden der Funktion warten). Dies sorgt für flüssige Performance ohne Rüttler
    //https://dart.dev/codelabs/async-await
    Translations translations = new Translations(locale);
    String jsonContent =
        await rootBundle.loadString("locale/i18n_${locale.languageCode}.json");
    _localizedValues = json.decode(jsonContent);
    return translations;
  }

  get currentLanguage => locale.languageCode;
}

class TranslationsDelegate extends LocalizationsDelegate<Translations> {
  const TranslationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'de'].contains(locale.languageCode);

  @override
  Future<Translations> load(Locale locale) => Translations.load(locale);

  @override
  bool shouldReload(TranslationsDelegate old) => false;
}
