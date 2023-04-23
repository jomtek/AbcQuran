import 'dart:convert';

import 'package:abc_quran/models/sura.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final suraListProvider =
    StateNotifierProvider<SuraListNotifier, List<SuraModel>>((ref) {
  return SuraListNotifier();
});

class SuraListNotifier extends StateNotifier<List<SuraModel>> {
  SuraListNotifier() : super([]) {
    _loadSuraList();
  }

  Future _loadSuraList() async {
    final rawData = await rootBundle.loadString('assets/sura_info.json');
    final jsonList = jsonDecode(rawData);

    var list = <SuraModel>[];
    for (final json in jsonList) {
      list.add(SuraModel.fromJson(json));
    }

    state = list;
  }
}
