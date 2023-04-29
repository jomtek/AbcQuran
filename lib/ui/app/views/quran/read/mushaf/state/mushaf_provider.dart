import 'package:abc_quran/models/glyph.dart';
import 'package:abc_quran/providers/player/player_provider.dart';
import 'package:abc_quran/providers/sura/current_sura_provider.dart';
import 'package:abc_quran/providers/sura/sura_list_provider.dart';
import 'package:abc_quran/services/quran/fonts/mushaf_font_service.dart';
import 'package:abc_quran/services/quran/quran_mushaf_service.dart';
import 'package:abc_quran/ui/app/views/quran/read/cursor/cursor_provider.dart';
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
    final page = _ref.read(cursorProvider).page;
    // Ensure page order coherence
    if (page % 2 == 0) {
      await _loadPage(_ref.read(cursorProvider).page - 1, false);
      await _loadPage(_ref.read(cursorProvider).page, true);
    } else {
      await _loadPage(_ref.read(cursorProvider).page, false);
      await _loadPage(_ref.read(cursorProvider).page + 1, true);
    }
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

  void moveTo(Glyph glyph) async {
    // Here the 6-steps order is very important, as it is designed in order to
    // move safely, preventing any graphical/auditive abnormality.

    final player = _ref.read(playerProvider);

    bool wasPlaying = player.isPlaying;

    if (player.isLooping) {
      if (glyph.verse! < player.loopStartVerse ||
          glyph.verse! > player.loopEndVerse) {
        // If the glyph is outside of the loop region, disable the loop mode
        _ref.read(playerProvider.notifier).toggleLoopMode();
      }
    }

    // Stop the player, in order to avoid any unexpected behavior
    await _ref.read(playerProvider.notifier).stop();

    // First, move bookmark
    await _ref.read(cursorProvider.notifier).moveBookmarkTo(
        glyph.verse!, glyph.page,
        automatic: false, canSeek: false);

    // Then, if needed, change the sura
    final currentSura = _ref.read(currentSuraProvider);
    if (glyph.sura != currentSura.id) {
      final targetSura = _ref.read(suraListProvider)[glyph.sura - 1];
      await _ref
          .read(currentSuraProvider.notifier)
          .setSura(targetSura, reloadMushaf: false, resetBm: false);
    }

    // Finally, seek the audio
    await _ref.read(playerProvider.notifier).seekTo(glyph.verse!);

    if (wasPlaying) {
      // Restart the player if needed
      _ref.read(playerProvider.notifier).play();
    }
  }

  void startFrom(Glyph glyph) async {
    _ref.read(cursorProvider.notifier).startBookmarkFrom(glyph.verse!);

    // If needed, change the sura
    final currentSura = _ref.read(currentSuraProvider);
    if (glyph.sura != currentSura.id) {
      final targetSura = _ref.read(suraListProvider)[glyph.sura - 1];
      await _ref
          .read(currentSuraProvider.notifier)
          .setSura(targetSura, reloadMushaf: false, resetBm: false);
    }

    final cursor = _ref.read(cursorProvider);
    if (glyph.verse! >= cursor.bookmarkStop) {
      moveTo(glyph);
    }
  }
}
