import 'package:abc_quran/models/sura.dart';
import 'package:abc_quran/services/quran/fonts/mushaf_font_service.dart';
import 'package:abc_quran/services/quran/quran_global_service.dart';
import 'package:abc_quran/services/quran/quran_mushaf_service.dart';
import 'package:abc_quran/ui/views/quran/read/cursor/cursor_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'sura_menu_state.dart';

final suraMenuProvider =
    StateNotifierProvider<SuraMenuNotifier, SuraMenuState>((ref) {
  return SuraMenuNotifier(ref);
});

class SuraMenuNotifier extends StateNotifier<SuraMenuState> {
  final StateNotifierProviderRef<SuraMenuNotifier, SuraMenuState> _ref;

  SuraMenuNotifier(this._ref) : super(SuraMenuState.initial()) {
    _loadSuras();
  }

  void _loadSuras() async {
    final suras = await _ref.read(quranGlobalServiceProvider).getSuraList();
    state = state.copyWith(suras: suras);
  }

  void select(SuraModel sura) {
    _ref.read(mushafFontServiceProvider).loadPage(3);
    _ref.watch(cursorProvider.notifier).selectSura(sura);
  }
}
