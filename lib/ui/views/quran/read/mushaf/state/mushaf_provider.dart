import 'package:abc_quran/models/glyph.dart';
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
    final pageGlyphs =
        await _ref.read(quranMushafServiceProvider).getPageGlyphs(page);
    await _ref.read(mushafFontServiceProvider).loadPage(page.toString());

    if (isLeft) {
      state = state.copyWith(leftPageGlyphs: pageGlyphs);
    } else {
      state = state.copyWith(rightPageGlyphs: pageGlyphs);
    }
  }

  void hover(Glyph glyph) {
    state = state.copyWith(hoveredVerse: glyph.verse, hoveredPage: glyph.page);
  }
}
