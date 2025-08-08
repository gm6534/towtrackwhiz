import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../Core/locales/en_json.dart';
import '../../Core/locales/es_json.dart';

class LocalizationService extends Translations {
  static final fallbackLocale = const Locale('en', 'US');

  static final supportedLocales = [
    const Locale('en', 'US'),
    const Locale('es', 'ES'),
  ];

  // ✅ Initialize GetStorage
  static final _box = GetStorage();
  static const _languageCodeKey = 'language_code';
  static const _countryCodeKey = 'country_code';

  // ✅ Read saved locale or fallback/device locale
  static Locale get locale {
    final storedLangCode = _box.read(_languageCodeKey);
    final storedCountryCode = _box.read(_countryCodeKey);

    if (storedLangCode != null && storedCountryCode != null) {
      return Locale(storedLangCode, storedCountryCode);
    }

    final deviceLocale = Get.deviceLocale;
    return supportedLocales.contains(deviceLocale)
        ? deviceLocale!
        : fallbackLocale;
  }

  @override
  Map<String, Map<String, String>> get keys => {'en_US': en, 'es_ES': es};

  static Map<String, String> get en => english();

  static Map<String, String> get es => spanish();

  // ✅ Save selected locale and apply it
  static Future<void> changeLocale({
    required String langCode,
    required String countryCode,
  }) async {
    final locale = Locale(langCode, countryCode);

    // Save in GetStorage
    _box.write(_languageCodeKey, langCode);
    _box.write(_countryCodeKey, countryCode);

    Get.updateLocale(locale);
    if (Get.isDialogOpen ?? false) {
      await 1.seconds.delay();
      Get.back();
    }
  }
}

class LocalizationService1 extends Translations {
  static final fallbackLocale = const Locale('en', 'US');

  static final supportedLocales = [
    const Locale('en', 'US'),
    const Locale('es', 'ES'),
  ];

  static Locale get locale {
    final deviceLocale = Get.deviceLocale;
    return supportedLocales.contains(deviceLocale)
        ? deviceLocale!
        : fallbackLocale;
  }

  @override
  Map<String, Map<String, String>> get keys => {'en_US': en, 'es_ES': es};

  static Map<String, String> get en => english();

  static Map<String, String> get es => spanish();

  static void changeLocale({
    required String langCode,
    required String countryCode,
  }) {
    final locale = Locale(langCode, countryCode);
    Get.updateLocale(locale);
  }
}
