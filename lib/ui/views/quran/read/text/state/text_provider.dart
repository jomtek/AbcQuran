import 'package:abc_quran/models/sura.dart';
import 'package:abc_quran/providers/sura/current_sura_provider.dart';
import 'package:abc_quran/services/quran/fonts/mushaf_font_service.dart';
import 'package:abc_quran/services/quran/quran_mushaf_service.dart';
import 'package:abc_quran/services/quran/quran_text_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'text_state.dart';

final textProvider =
    StateNotifierProvider<TextNotifier, TextState>((ref) {
  return TextNotifier(ref);
});

class TextNotifier extends StateNotifier<TextState> {
  final StateNotifierProviderRef<TextNotifier, TextState> _ref;

  TextNotifier(this._ref) : super(TextState.initial());

  Future reloadSura() async {
    final sura = _ref.read(currentSuraProvider);
    await loadSura(sura);
  }

  Future loadSura(SuraModel sura) async {
    final verses = await _ref.read(quranTextServiceProvider).getAyahsFromSura(sura.id);
    final glyphs = await _ref.read(quranMushafServiceProvider).getSuraGlyphs(sura.id);

    for (final verse in glyphs) {
      final glyph = verse[0];
      _ref.read(mushafFontServiceProvider).loadPage(glyph.page.toString());
    }

    state = state.copyWith(loadedVerses: verses, loadedGlyphs: glyphs);
  }

  void resetScrollPos() {
    state.scrollController.jumpTo(0);
  }
}
