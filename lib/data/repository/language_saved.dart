import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageSaved{

  Future<void> setLocal(String languageCode, String countryCode)async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("languageCode", languageCode);
    prefs.setString("countryCode", countryCode);
    Get.updateLocale(Locale(languageCode, countryCode));

  }

  Future<void> getLocale()async{
        final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString("languageCode",);
    final countryCode = prefs.getString("countryCode");
    Get.updateLocale(Locale(languageCode??'ky', countryCode??'KG'));
  }
}