import 'package:abc_quran/models/reciter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'reciter_list_provider.dart';

final currentReciterProvider =
    StateNotifierProvider<CurrentReciterNotifier, ReciterModel>((ref) {
  return CurrentReciterNotifier(ref);
});

class CurrentReciterNotifier extends StateNotifier<ReciterModel> {
    final StateNotifierProviderRef<CurrentReciterNotifier, ReciterModel> _ref;

  CurrentReciterNotifier(this._ref) : super(ReciterModel.initial()) {
    _getDefaultReciter();
  }

  void _getDefaultReciter() {
    var reciters = _ref.watch(reciterListProvider);
    if (reciters.isNotEmpty) {
      state = reciters[0];
    }
  }

  void setReciter(ReciterModel reciter) {
    if (reciter.id != state.id) {
      state = reciter;
    }
  }
}