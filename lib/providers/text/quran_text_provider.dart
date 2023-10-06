import 'dart:convert';
import 'dart:io';

import 'package:abc_quran/providers/path_provider/abc_path_provider.dart';
import 'package:abc_quran/providers/settings/settings_provider.dart';
import 'package:abc_quran/providers/sura/current_sura_provider.dart';
import 'package:abc_quran/ui/app/api_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

// This provider fulfills all textual quran needs.
// It provides data for the translated versions of the holy book.

final quranTextProvider =
    StateNotifierProvider<QuranTextNotifier, List<String>>((ref) {
  return QuranTextNotifier(ref);
});

class QuranTextNotifier extends StateNotifier<List<String>> {
  final StateNotifierProviderRef<QuranTextNotifier, List<String>> _ref;
  QuranTextNotifier(this._ref) : super([]);

  final http.Client _httpClient = http.Client();

  Future _fetchTranslationFromApi(int sura) async {
    final translationId = _ref.read(settingsProvider).translationId;
    final translationUri =
        Uri.parse("${ApiData.baseUrl}/text/$translationId/$sura");

    // Fetch translated verses from the api
    http.Response response;
    try {
      response = await _httpClient.get(translationUri);
    } catch (e) {
      throw Exception(
          "Failed to load translation for $translationId and usra $sura");
    }

    if (response.statusCode == 200) {
      final verses = utf8.decode(response.bodyBytes).trim().split("\n");

      // Cache the downloaded translation for the specific sura
      final translationsFolder = _ref.read(abcPathProvider).localTranslationsFolder;

      final dir = Directory("$translationsFolder\\$translationId");
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      final file = File("${dir.path}\\$sura");
      await file.writeAsBytes(response.bodyBytes);

      // Return the translation
      state = verses;
    }
  }

  Future getAyahsForSura(int sura) async {
    final translationsFolder = _ref.read(abcPathProvider).localTranslationsFolder;
    final translationId = _ref.read(settingsProvider).translationId;
    final file = File("$translationsFolder\\$translationId\\$sura");

    if (await file.exists()) {
      state = await file.readAsLines();
    } else {
      await _fetchTranslationFromApi(sura);
    }
  }

  Future reload() async {
    final sura = _ref.read(currentSuraProvider).id;
    await getAyahsForSura(sura);
  }
}
