import 'package:abc_quran/models/sura.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'read_state.dart';

final readProvider =
    StateNotifierProvider<ReadNotifier, ReadState>((ref) {
  return ReadNotifier(ref);
});


class ReadNotifier extends StateNotifier<ReadState> {
  final StateNotifierProviderRef<ReadNotifier, ReadState> _ref;

  ReadNotifier(this._ref) : super(ReadState.initial()) {
  }

  void selectSura(SuraModel sura) {
    state = state.copyWith(sura: sura);
  }
}