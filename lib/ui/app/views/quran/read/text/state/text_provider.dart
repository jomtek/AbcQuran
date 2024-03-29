import 'dart:math';

import 'package:abc_quran/models/sura.dart';
import 'package:abc_quran/providers/sura/current_sura_provider.dart';
import 'package:abc_quran/services/quran/fonts/mushaf_font_service.dart';
import 'package:abc_quran/services/quran/quran_mushaf_service.dart';
import 'package:abc_quran/providers/text/quran_text_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'text_state.dart';

final textProvider = StateNotifierProvider<TextNotifier, TextState>((ref) {
  return TextNotifier(ref);
});

class TextNotifier extends StateNotifier<TextState> {
  final StateNotifierProviderRef<TextNotifier, TextState> _ref;

  TextNotifier(this._ref) : super(TextState.initial()) {
    _loadBasmalaData();
  }

  Future _loadBasmalaData() async {
    await _ref.read(quranTextProvider.notifier).getAyahsForSura(1);
    final glyphs = await _ref.read(quranMushafServiceProvider).getSuraGlyphs(1);
    state = state.copyWith(
        basmalaText: _ref.read(quranTextProvider)[0], basmalaGlyphs: glyphs[0]);
  }

  Future reloadSura() async {
    final sura = _ref.read(currentSuraProvider);
    await loadSura(sura);
  }

  Future loadSura(SuraModel sura) async {
    await _ref.read(quranTextProvider.notifier).getAyahsForSura(sura.id);
    final glyphs =
        await _ref.read(quranMushafServiceProvider).getSuraGlyphs(sura.id);

    for (final verse in glyphs) {
      final glyph = verse[0];
      _ref.read(mushafFontServiceProvider).loadPage(glyph.page.toString());
    }

    state = state.copyWith(loadedGlyphs: glyphs);
  }

  Future scrollTo(int verse) async {
    await state.scrollController.scrollTo(
        index: max(verse - 1, 0), duration: const Duration(milliseconds: 1200));
    //state.scrollController.jumpTo(index: max(verse - 1, 0));
  }
}
