import 'package:abc_quran/models/glyph.dart';
import 'package:abc_quran/models/sura.dart';
import 'package:abc_quran/services/quran/quran_text_service.dart';
import 'package:abc_quran/ui/views/quran/read/cursor/cursor_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'text_state.dart';

final textProvider =
    StateNotifierProvider<TextNotifier, TextState>((ref) {
  return TextNotifier(ref);
});

class TextNotifier extends StateNotifier<TextState> {
  final StateNotifierProviderRef<TextNotifier, TextState> _ref;

  TextNotifier(this._ref) : super(TextState.initial()) {
    loadSura(_ref.read(cursorProvider).sura);
  }

  Future loadSura(SuraModel sura) async {
    final verses = await _ref.read(quranTextServiceProvider).getAyahsFromSura(sura.id);
    state = state.copyWith(loadedVerses: verses);
  }
}
