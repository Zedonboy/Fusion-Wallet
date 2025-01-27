import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String LAGUAGE_CODE = 'languageCode';

//languages code
const String ENGLISH = 'en';
// const String DUTCH = 'nl';//netherlands and belgium both use dutch language
// const String BULGARIAN = 'bg';
const String FRENCH = 'fr';
// const String GERMAN = 'de';
// const String INDONESIAN = 'id';
// const String PORTUGUESE  = 'pt';
// const String SPANISH  = 'es';

Future<Locale> setLocale(String languageCode) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(LAGUAGE_CODE, languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String languageCode = prefs.getString(LAGUAGE_CODE) ?? "en";
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  switch (languageCode) {
    case ENGLISH:
      return Locale(ENGLISH, 'US');
    // case DUTCH:
    //   return Locale(DUTCH, "BE");
    // case BULGARIAN:
    //   return Locale(BULGARIAN, "BG");
    case FRENCH:
      return Locale(FRENCH, "FR");
    // case GERMAN:
    //   return Locale(GERMAN, "DE");
    // case INDONESIAN:
    //   return Locale(INDONESIAN, "ID");
    // case PORTUGUESE:
    //   return Locale(PORTUGUESE, "PT");
    // case SPANISH:
    //   return Locale(SPANISH, "ES");
    default:
      return Locale(ENGLISH, 'US');
  }
}

String? getTranslated(BuildContext context, String key) {
  //return DemoLocalization.of(context)!.translate(key);
  return key;
}
