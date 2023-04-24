import 'package:abc_quran/models/glyph.dart';
import 'package:abc_quran/providers/sura/current_sura_provider.dart';
import 'package:abc_quran/providers/sura/sura_list_provider.dart';
import 'package:abc_quran/services/quran/fonts/mushaf_font_service.dart';
import 'package:abc_quran/services/quran/quran_mushaf_service.dart';
import 'package:abc_quran/ui/views/quran/read/cursor/cursor_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'mushaf_state.dart';

final mushafProvider =
    StateNotifierProvider<MushafNotifier, MushafState>((ref) {
  return MushafNotifier(ref);
});

class MushafNotifier extends StateNotifier<MushafState> {
  final StateNotifierProviderRef<MushafNotifier, MushafState> _ref;

  MushafNotifier(this._ref) : super(MushafState.initial()) {
    // Load basmala font
    _ref.read(mushafFontServiceProvider).loadPage("BSML");
    reloadPageCouple();
  }

  void reloadPageCouple() async {
    await _loadPage(_ref.read(cursorProvider).page, false);
    await _loadPage(_ref.read(cursorProvider).page + 1, true);
  }

  Future _loadPage(int page, bool isLeft) async {
    var pageGlyphs = List.filled(15, <Glyph>[]);
    if (page != 0 && page != 605) {
      pageGlyphs =
          await _ref.read(quranMushafServiceProvider).getPageGlyphs(page);
      await _ref.read(mushafFontServiceProvider).loadPage(page.toString());
    }

    if (isLeft) {
      state = state.copyWith(leftPageGlyphs: pageGlyphs);
    } else {
      state = state.copyWith(rightPageGlyphs: pageGlyphs);
    }
  }

  // Here any glyph symbolises its whole verse
  void hover(Glyph glyph) {
    state = state.copyWith(hoveredVerse: glyph.verse, hoveredSura: glyph.sura);
  }

  void moveTo(Glyph glyph) {
    final currentSura = _ref.read(currentSuraProvider);
    if (glyph.sura != currentSura.id) {
      final targetSura = _ref.read(suraListProvider)[glyph.sura - 1];
      _ref.read(currentSuraProvider.notifier).setSura(targetSura, reloadMushaf: false);
    }
    _ref.read(cursorProvider.notifier).moveBookmarkAt(glyph.verse!, glyph.page);
  }

  void startFrom(Glyph glyph) {
    _ref.read(cursorProvider.notifier).startBookmarkFrom(glyph.verse!);
  }
}
