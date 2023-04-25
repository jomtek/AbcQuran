import 'package:abc_quran/models/sura.dart';
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
    resetBookmark();
  }

  void selectSura(SuraModel sura, {bool reloadMushaf = true}) async {
    int page = await _ref.read(quranMushafServiceProvider).getSuraPage(sura.id);
    state = state.copyWith(page: page);

    if (_ref.read(settingsProvider).showMushaf) {
      if (reloadMushaf) {
        _ref.read(mushafProvider.notifier).reloadPageCouple();
      }
    } else {
      resetBookmark();
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

  void moveBookmarkAt(int verse, int page) {
    // Bookmark logic
    if (verse >= state.bookmarkStart) {
      state = state.copyWith(bookmarkStop: verse);
    } else {
      state = state.copyWith(bookmarkStart: verse, bookmarkStop: verse);
    }

    state = state.copyWith(page: page);
  }

  void startBookmarkFrom(int verse) {
    if (verse > state.bookmarkStop) {
      state = state.copyWith(bookmarkStop: verse);
    }
    state = state.copyWith(bookmarkStart: verse);
  }

  void resetBookmark() {
    final sura = _ref.read(currentSuraProvider);
    if (sura.hasBasmala()) {
      startBookmarkFrom(0);
      moveBookmarkAt(0, state.page);
    } else {
      startBookmarkFrom(1);
      moveBookmarkAt(1, state.page);
    }
  }

  void teleportTo(int suraNum, int verseNum) {
    // Change sura
    final sura = _ref.read(suraListProvider)[suraNum - 1];
    _ref.read(currentSuraProvider.notifier).setSura(sura);

    // Change current verse
    resetBookmark();
    moveBookmarkAt(verseNum, state.page);
  }
}
