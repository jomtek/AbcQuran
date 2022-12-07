import 'package:abc_quran/models/sura.dart';
import 'package:abc_quran/providers/sura_info_provider.dart';
import 'package:abc_quran/services/quran/fonts/mushaf_font_service.dart';
import 'package:abc_quran/services/quran/quran_mushaf_service.dart';
import 'package:abc_quran/ui/views/quran/read/cursor/cursor_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'sura_menu_state.dart';

final suraMenuProvider =
    StateNotifierProvider<SuraMenuNotifier, SuraMenuState>((ref) {
  return SuraMenuNotifier(ref);
});

class SuraMenuNotifier extends StateNotifier<SuraMenuState> {
  final StateNotifierProviderRef<SuraMenuNotifier, SuraMenuState> _ref;

  SuraMenuNotifier(this._ref) : super(SuraMenuState.initial()) {
  }

  void select(SuraModel sura) {
    _ref.watch(cursorProvider.notifier).selectSura(sura);
  }
}
