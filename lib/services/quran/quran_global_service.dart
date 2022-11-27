import 'dart:convert';

import 'package:abc_quran/models/sura.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final quranGlobalServiceProvider = Provider((ref) => QuranGlobalService());

// This service fulfills all non-specific quran needs, such as retrieving the names of the chapters...
class QuranGlobalService {
  Future<List<SuraModel>> getSuraList() async {
    final rawData = await rootBundle.loadString('assets/sura_info.json');
    final jsonList = jsonDecode(rawData);

    var list = <SuraModel>[];
    for (final json in jsonList) {
      list.add(SuraModel.fromJson(json));
    }

    return list;
  }
}
