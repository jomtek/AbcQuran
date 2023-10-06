import 'package:abc_quran/localization/app_localization.dart';
import 'package:abc_quran/models/translation.dart';
import 'package:abc_quran/providers/settings/settings_provider.dart';
import 'package:abc_quran/providers/settings/settings_state.dart';
import 'package:abc_quran/providers/text/translation_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  Widget _buildAppTranslationsDropdown(SettingsState state, WidgetRef ref) {
    return DropdownButton(
        value: state.languageId,
        items: [
          for (final entry in AppLocalization.translations.entries)
            DropdownMenuItem<String>(
                value: entry.key,
                enabled: entry.key != state.languageId,
                child: Row(
                  children: [
                    Image.asset("assets/flags/${entry.key}.png",
                        isAntiAlias: true,
                        width: 10.sp > 50 ? 50 : 10.sp,
                        height: 10.sp),
                    SizedBox(width: 2.sp),
                    Text(entry.value,
                        style: TextStyle(fontSize: 3.5.sp < 16 ? 16 : 3.5.sp))
                  ],
                ))
        ],
        onChanged: (item) {
          ref.read(settingsProvider.notifier).setAppLanguage(item as String);
        });
  }

  Widget _buildQuranTranslationsDropdown(
      SettingsState state, List<TranslationModel> translations, WidgetRef ref) {
    return DropdownButton(
        value: state.translationId,
        items: [
          for (final translation in translations)
            DropdownMenuItem<String>(
                value: translation.id,
                enabled: translation.id != state.translationId,
                child: Row(
                  children: [
                    Image.asset("assets/flags/${translation.getFlagId()}.png",
                        isAntiAlias: true,
                        width: 10.sp > 50 ? 50 : 10.sp,
                        height: 10.sp),
                    SizedBox(width: 2.sp),
                    Text(translation.name,
                        style: TextStyle(fontSize: 3.5.sp < 16 ? 16 : 3.5.sp))
                  ],
                ))
        ],
        onChanged: (item) {
          ref.read(settingsProvider.notifier).setQuranLanguage(item as String);
        });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(settingsProvider);
    final translations = ref.watch(translationListProvider);

    return Padding(
      padding: EdgeInsets.only(left: 12.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8.sp),
          Text(AppLocalization.of(context)!.translate("settings_sidebar_title"),
              style: TextStyle(
                  fontSize: 6.sp, fontWeight: FontWeight.w500)),
          SizedBox(height: 4.sp),
          SizedBox(
            width: 125.sp < 400 ? 400 : 125.sp,
            child: Row(
              children: [
                Text(AppLocalization.of(context)!.translate("language"),
                    style: TextStyle(fontSize: 4.5.sp)),
                SizedBox(width: 2.sp),
                const Expanded(
                    child: Divider(thickness: 1.5, color: Colors.black26)),
                SizedBox(width: 2.sp),
                _buildAppTranslationsDropdown(state, ref)
              ],
            ),
          ),
          SizedBox(
            width: 125.sp < 400 ? 400 : 125.sp,
            child: Row(
              children: [
                Text(AppLocalization.of(context)!.translate("quran_language"),
                    style: TextStyle(fontSize: 4.5.sp)),
                SizedBox(width: 2.sp),
                const Expanded(
                    child: Divider(thickness: 1.5, color: Colors.black26)),
                SizedBox(width: 2.sp),
                if (translations.isNotEmpty)
                  _buildQuranTranslationsDropdown(state, translations, ref)
              ],
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: () =>
                launchUrl(Uri.parse("https://github.com/jomtek/AbcQuran")),
            child: Text(
              AppLocalization.of(context)!.translate("help_us_github"),
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.blue,
                  fontSize: 6.sp),
            ),
          ),
          SizedBox(height: 12.sp)
        ],
      ),
    );
  }
}
