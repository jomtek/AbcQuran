import 'package:abc_quran/models/sura.dart';
import 'package:abc_quran/providers/player/player_provider.dart';
import 'package:abc_quran/ui/app/views/quran/read/cursor/cursor_provider.dart';
import 'package:abc_quran/ui/app/views/quran/read/text/state/text_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'sura_list_provider.dart';

final currentSuraProvider =
    StateNotifierProvider<CurrentSuraNotifier, SuraModel>((ref) {
  return CurrentSuraNotifier(ref);
});

class CurrentSuraNotifier extends StateNotifier<SuraModel> {
  final StateNotifierProviderRef<CurrentSuraNotifier, SuraModel> _ref;

  CurrentSuraNotifier(this._ref) : super(SuraModel.initial()) {
    _getDefaultSura();
  }

  void _getDefaultSura() {
    var suras = _ref.watch(suraListProvider);
    if (suras.isNotEmpty) {
      state = suras[0]; // Al-Fatiha
      _ref.read(textProvider.notifier).loadSura(suras[0]);
    }
  }

  Future setSura(SuraModel sura,
      {bool reloadMushaf = true, bool resetBm = true}) async {
    if (sura.id != state.id) {
      state = sura;

      // Reflect changes on player data
      await _ref.read(playerProvider.notifier).refreshPlayer();

      // Reflect changes on cursor data
      _ref
          .read(cursorProvider.notifier)
          .selectSura(sura, reloadMushaf: reloadMushaf, resetBm: resetBm);
    }
  }

  // (!) Both methods are unsafe
  SuraModel whatsBefore() {
    final suraList = _ref.read(suraListProvider);
    return suraList[state.id - 1 - 1];
  }
  SuraModel whatsNext() {
    final suraList = _ref.read(suraListProvider);
    return suraList[state.id - 1 + 1];
  }
}
