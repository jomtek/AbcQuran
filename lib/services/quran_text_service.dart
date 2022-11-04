import 'dart:convert';

import 'package:abc_quran/models/sura.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final quranTextServiceProvider = Provider((ref) => QuranTextService());

class QuranTextService {
  Future<List<Sura>> getSuraList() async {
      final rawData = await rootBundle.loadString('assets/sura_info.json');
      final jsonList = jsonDecode(rawData);
      
      var list = <Sura>[];
      for (final json in jsonList) {
        list.add(Sura.fromJson(json));
      }
      
      return list;
  }
}