import 'package:abc_quran/models/sura.dart';
import 'package:abc_quran/services/quran/quran_global_service.dart';
import 'package:abc_quran/ui/views/quran/read/read_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'sura_menu_state.dart';

final suraMenuProvider =
    StateNotifierProvider<SuraMenuNotifier, SuraMenuState>((ref) {
  return SuraMenuNotifier(ref);
});

class SuraMenuNotifier extends StateNotifier<SuraMenuState> {
  final StateNotifierProviderRef<SuraMenuNotifier, SuraMenuState> _ref;

  SuraMenuNotifier(this._ref) : super(SuraMenuState.initial()) {
    _loadSuras();
  }

  void _loadSuras() async {
    final suras = await _ref.read(quranGlobalServiceProvider).getSuraList();
    state = state.copyWith(suras: suras);
  }

  void select(SuraModel sura) {
    _ref.watch(readProvider.notifier).selectSura(sura);
  }
}
