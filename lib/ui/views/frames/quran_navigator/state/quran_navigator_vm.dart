import 'package:abc_quran/models/sura.dart';
import 'package:abc_quran/providers/sura_info_provider.dart';
import 'package:abc_quran/ui/views/frames/quran_navigator/state/quran_navigator_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final quranNavigatorProvider =
    StateNotifierProvider<QuranNavigatorNotifier, QuranNavigatorState>((ref) {
  return QuranNavigatorNotifier(ref);
});

class QuranNavigatorNotifier extends StateNotifier<QuranNavigatorState> {
  final StateNotifierProviderRef<QuranNavigatorNotifier, QuranNavigatorState> _ref;

  QuranNavigatorNotifier(this._ref) : super(QuranNavigatorState.initial()) {
    state = state.copyWith(
        allElements: _ref.read(suraListProvider),
        relevantElements: _ref.read(suraListProvider));
  }

  void search(String text) {
    // Make an aggregating, weighted search
    var resultsWeights = <SuraModel, int>{};

    for (final sura in state.allElements) {
      for (var kw in text.trim().split(" ")) {
        kw = kw.toLowerCase();

        if (sura.phoneticName.toLowerCase().contains(kw) ||
            sura.translatedName.toLowerCase().contains(kw) ||
            sura.id.toString() == kw) {
          if (resultsWeights.containsKey(sura)) {
            resultsWeights[sura] = resultsWeights[sura]! + 1;
          } else {
            resultsWeights[sura] = 0;
          }
        }
      }
    }

    var relevantResults = resultsWeights.entries.toList()
      ..sort((e1, e2) {
        var diff = e2.value.compareTo(e1.value);
        if (diff == 0) {
          diff = e1.key.id.compareTo(e2.key.id);
        }
        return diff;
      });

    var relevantElements = <SuraModel>[];
    for (final element in relevantResults) {
      relevantElements.add(element.key);
    }

    state = state.copyWith(relevantElements: relevantElements);
  }
}
