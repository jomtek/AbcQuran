import 'dart:convert';

import 'package:abc_quran/models/reciter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final reciterListProvider =
    StateNotifierProvider<ReciterListNotifier, List<ReciterModel>>((ref) {
  return ReciterListNotifier();
});

class ReciterListNotifier extends StateNotifier<List<ReciterModel>> {
  ReciterListNotifier() : super([]) {
    _loadReciterList();
  }

  Future _loadReciterList() async {
    final fontUri = Uri.parse("http://141.145.204.116/reciters.json");

    // Fetch reciters data from the api
    http.Response response;
    try {
      response = await http.Client().get(fontUri);
    } catch (e) {
      throw Exception("Failed to load reciters data");
    }

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);

      var list = <ReciterModel>[];
      for (Map<String, dynamic> reciterJson in jsonList) {
        list.add(ReciterModel.fromJson(reciterJson));
      }

      state = list;
    }
  }
}
