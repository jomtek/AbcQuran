import 'dart:convert';

import 'package:abc_quran/models/hizb.dart';
import 'package:abc_quran/providers/sura/hizb/hizb_state.dart';
import 'package:abc_quran/providers/sura/sura_list_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final hizbListProvider =
    StateNotifierProvider<HizbListNotifier, HizbState>((ref) {
  return HizbListNotifier(ref);
});

class HizbListNotifier extends StateNotifier<HizbState> {
  final StateNotifierProviderRef<HizbListNotifier, HizbState> _ref;

  HizbListNotifier(this._ref) : super(HizbState.initial()) {
    _loadHizbList();
  }

  Future _loadHizbList() async {
    final rawData = await rootBundle.loadString('assets/hizb_list.json');
    final jsonList = jsonDecode(rawData);

    var locations = <HizbModel>[];
    for (final json in jsonList) {
      final start = json["start"].split(":");
      final end = json["end"].split(":");

      locations.add(HizbModel(int.parse(start[0]), int.parse(start[1]),
          int.parse(end[0]), int.parse(end[1])));
    }

    // Calculate heights for the amazing juz-hizb display effect
    // One tile is 13.sp px high
    var heights = <double>[];
    var suras = _ref.watch(suraListProvider);
    for (HizbModel location in locations) {
      final startSura = suras[location.startSura - 1];
      final endSura = suras[location.endSura - 1];

      // 'Hpv' stands for 'Height per verse'
      final startHpv = 13 / startSura.length;
      final endHpv = 13 / endSura.length;

      if (startSura == endSura) {
        // Hizb is contained in a single sura

        final extent = location.endVerse - location.startVerse;
        heights.add(extent * startHpv);
      } else {
        // Hizb is spread in two different suras
        
        final startExtent = startSura.length - location.startVerse + 1;
        final middleExtent = location.endSura - location.startSura - 1;
        final endExtent = location.endVerse;
        heights.add(startExtent * startHpv + middleExtent * 13 + endExtent * endHpv);
      }
    }

    state = state.copyWith(locations: locations, heights: heights);
  }
}
