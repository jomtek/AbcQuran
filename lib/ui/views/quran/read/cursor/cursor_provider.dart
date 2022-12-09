import 'package:abc_quran/models/sura.dart';
import 'package:abc_quran/services/quran/quran_mushaf_service.dart';
import 'package:abc_quran/ui/views/quran/read/mushaf/state/mushaf_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'cursor_state.dart';

final cursorProvider =
    StateNotifierProvider<CursorNotifier, CursorState>((ref) {
  return CursorNotifier(ref);
});


class CursorNotifier extends StateNotifier<CursorState> {
  final StateNotifierProviderRef<CursorNotifier, CursorState> _ref;

  CursorNotifier(this._ref) : super(CursorState.initial());

  void selectSura(SuraModel sura) async {
    int page = await _ref.read(quranMushafServiceProvider).getSuraPage(sura.id);
    state = state.copyWith(sura: sura, page: page);
    _ref.read(mushafProvider.notifier).reloadPageCouple();
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
}