import 'dart:convert';

import 'package:abc_quran/models/translation.dart';
import 'package:abc_quran/ui/app/api_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

// Looking for app translations ? Everything's at `lib/localization/app_localization.dart`

final translationListProvider =
    StateNotifierProvider<TranslationListNotifier, List<TranslationModel>>(
        (ref) {
  return TranslationListNotifier();
});

class TranslationListNotifier extends StateNotifier<List<TranslationModel>> {
  TranslationListNotifier() : super([]) {
    _loadTranslationList();
  }

  Future _loadTranslationList() async {
    final translationsUri = Uri.parse("${ApiData.baseUrl}/translations.json");

    // Fetch translations data from the api
    http.Response response;
    try {
      response = await http.Client().get(translationsUri);
    } catch (e) {
      throw Exception("Failed to load translations data");
    }

    if (response.statusCode == 200) {
      final List<dynamic> jsonList =
          jsonDecode(utf8.decode(response.bodyBytes));

      var list = <TranslationModel>[];
      for (Map<String, dynamic> reciterJson in jsonList) {
        list.add(TranslationModel.fromJson(reciterJson));
      }

      state = list;
    }
  }
}
