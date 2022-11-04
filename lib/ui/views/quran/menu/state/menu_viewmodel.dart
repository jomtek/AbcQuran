import 'package:abc_quran/models/sura.dart';
import 'package:abc_quran/services/quran_text_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'menu_state.dart';

final menuProvider =
    StateNotifierProvider<MenuNotifier, MenuState>((ref) {
  return MenuNotifier(ref);
});

class MenuNotifier extends StateNotifier<MenuState> {
  final StateNotifierProviderRef<MenuNotifier, MenuState> _ref;

  MenuNotifier(this._ref) : super(MenuState.initial()) {
    _loadCalendars();
  }

  void _loadCalendars() async {
    final suras = await _ref.read(quranTextServiceProvider).getSuraList();
    state = state.copyWith(suras: suras);
  }

  void select(Sura sura) {
    
  }
}
