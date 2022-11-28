import 'package:abc_quran/models/glyph.dart';
import 'package:abc_quran/services/quran/quran_mushaf_service.dart';
import 'package:abc_quran/services/quran/quran_text_service.dart';
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
    _init();
  }

  void _init() async {
    final pageGlyphs = await _ref
        .read(quranMushafServiceProvider)
        .getPageGlyphs(_ref.read(cursorProvider).page);
    state = state.copyWith(pageGlyphs: pageGlyphs);
  }

  void hover(Glyph glyph) {
    state = state.copyWith(hoveredVerse: glyph.verse, hoveredSura: glyph.sura);
  }
}
