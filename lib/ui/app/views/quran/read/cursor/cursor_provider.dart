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

  CursorNotifier(this._ref) : super(CursorState.initial()) {
    //resetBookmark();
  }

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

  void moveBookmarkTo(int verse, int page, {bool automatic = true}) async {
    // Bookmark logic
    if (verse >= state.bookmarkStart) {
      state = state.copyWith(bookmarkStop: verse);
    } else {
      state = state.copyWith(bookmarkStart: verse, bookmarkStop: verse);
    }

    state = state.copyWith(page: page);

    if (automatic) {
      final settings = _ref.read(settingsProvider);
      if (!settings.showMushaf) {
        await _ref.read(textProvider.notifier).scrollTo(verse);
      }
    } else {
      await _ref.read(playerProvider.notifier).seekTo(verse);
    }
  }

  void startBookmarkFrom(int verse) {
    if (verse > state.bookmarkStop) {
      state = state.copyWith(bookmarkStop: verse);
    }
    state = state.copyWith(bookmarkStart: verse);
  }

  void resetBookmark() {
    final sura = _ref.read(currentSuraProvider);
    startBookmarkFrom(sura.getFirstVerseId());
    moveBookmarkTo(sura.getFirstVerseId(), state.page);
  }

  void teleportTo(int suraNum, int verseNum) async {
    // Change sura
    final sura = _ref.read(suraListProvider)[suraNum - 1];
    _ref.read(currentSuraProvider.notifier).setSura(sura, resetBm: false);

    // Get exact mushaf page
    final page = await _ref
        .read(quranMushafServiceProvider)
        .getPageNum(suraNum, verseNum);
    moveBookmarkTo(verseNum, page);
  }
}
