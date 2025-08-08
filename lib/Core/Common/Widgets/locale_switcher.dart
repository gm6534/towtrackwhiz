import 'package:towtrackwhiz/Core/Common/Widgets/toasts.dart';
import 'package:towtrackwhiz/Core/Utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controller/Other/locale_controller.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(color: AppColors.primary),
          ),
        ),
      ),
      icon: Text(
        (Get.locale?.languageCode == 'en' ? 'spanish' : 'english')
            .capitalizeFirst!,
        style: Get.textTheme.titleLarge,
      ),
      onPressed: () {
        ToastAndDialog.progressIndicator();
        final currentLang = Get.locale?.languageCode;
        final nextIndex = currentLang == 'en' ? 1 : 0;
        final nextLocale = LocalizationService.supportedLocales[nextIndex];

        LocalizationService.changeLocale(
          langCode: nextLocale.languageCode,
          countryCode: nextLocale.countryCode!,
        );
        return;
        // String newLocale = Get.locale?.languageCode == 'en' ? 'ur' : 'en';
        // LocalizationService.changeLocale(langCode: newLocale, countryCode: 'PK');

        debugPrint(
          "-------${LocalizationService.locale.languageCode}-----------",
        );
        debugPrint(
          "-------${LocalizationService.locale.countryCode}-----------",
        );

        int index = 0;
        if (Get.locale?.languageCode ==
            LocalizationService.locale.languageCode) {
          index = 1;
        } else {
          index = 0;
        }
        LocalizationService.changeLocale(
          langCode: LocalizationService.supportedLocales[index].languageCode,
          countryCode: LocalizationService.supportedLocales[index].countryCode!,
        );
      },
    );
  }
}
