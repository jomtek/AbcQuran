import 'package:abc_quran/models/sura.dart';
import 'package:abc_quran/providers/player/player_provider.dart';
import 'package:abc_quran/providers/settings/settings_provider.dart';
import 'package:abc_quran/providers/sura/current_sura_provider.dart';
import 'package:abc_quran/providers/sura/sura_list_provider.dart';
import 'package:abc_quran/services/quran/quran_mushaf_service.dart';
import 'package:abc_quran/ui/app/views/quran/read/mushaf/state/mushaf_provider.dart';
import 'package:abc_quran/ui/app/views/quran/read/text/state/text_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'cursor_state.dart';

final cursorProvider =
    StateNotifierProvider<CursorNotifier, CursorState>((ref) {
  return CursorNotifier(ref);
});

class CursorNotifier extends StateNotifier<CursorState> {
  final StateNotifierProviderRef<CursorNotifier, CursorState> _ref;

  CursorNotifier(this._ref) : super(CursorState.initial());

  void selectSura(SuraModel sura,
      {bool reloadMushaf = true, bool resetBm = true}) async {
    int page = await _ref.read(quranMushafServiceProvider).getSuraPage(sura.id);
    state = state.copyWith(page: page);

    if (resetBm) {
      resetBookmark();
    }

    if (_ref.read(settingsProvider).showMushaf) {
      if (reloadMushaf) {
        _ref.read(mushafProvider.notifier).reloadPageCouple();
      }
    } else {
      _ref.read(textProvider.notifier).loadSura(sura);
    }
  }

  void gotoNextPageCouple() {
    if (state.page + 2 < 605) {
      state = state.copyWith(page: state.page + 2);
    }
  }

  void gotoPreviousPageCouple() {
    if (state.page - 1 > 0) {
      state = state.copyWith(page: state.page - 2);
    }
  }

  Future moveBookmarkTo(int verse, int page,
      {bool resolvePage = false,
      bool automatic = true,
      bool canSeek = true}) async {
    if (resolvePage) {
      // Get exact mushaf page
      final sura = _ref.read(currentSuraProvider);
      page = await _ref
          .read(quranMushafServiceProvider)
          .getPageNum(sura.id, verse);
    }

    if (automatic) {
      final settings = _ref.read(settingsProvider);
      if (!settings.showMushaf) {
        await _ref.read(textProvider.notifier).scrollTo(verse);
      }
    } else if (canSeek) {
      await _ref.read(playerProvider.notifier).seekTo(verse);
    }

    // Bookmark logic
    if (verse >= state.bookmarkStart) {
      state = state.copyWith(bookmarkStop: verse);
    } else {
      state = state.copyWith(bookmarkStart: verse, bookmarkStop: verse);
    }

    if (page != state.page) {
      state = state.copyWith(page: page);
      _ref.read(mushafProvider.notifier).reloadPageCouple();
    } else {
      state = state.copyWith(page: page);
    }

    final player = _ref.read(playerProvider);
    if (player.isLooping) {
      if (verse < player.loopStartVerse || verse > player.loopEndVerse) {
        // If the glyph is outside of the loop region, disable the loop mode
        _ref.read(playerProvider.notifier).toggleLoopMode();
      }
    }
  }

  void startBookmarkFrom(int verse) async {
    if (verse > state.bookmarkStop) {
      state = state.copyWith(bookmarkStop: verse);
    }
    state = state.copyWith(bookmarkStart: verse);
  }

  void resetBookmark() {
    final sura = _ref.read(currentSuraProvider);
    startBookmarkFrom(sura.getFirstVerseId());
    moveBookmarkTo(sura.getFirstVerseId(), -1, resolvePage: true);
  }

  void teleportTo(int suraNum, int verseNum) async {
    // Change sura
    final sura = _ref.read(suraListProvider)[suraNum - 1];
    _ref.read(currentSuraProvider.notifier).setSura(sura, resetBm: false);

    moveBookmarkTo(verseNum, -1, resolvePage: true);
  }
}
