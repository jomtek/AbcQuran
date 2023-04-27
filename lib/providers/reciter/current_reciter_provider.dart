import 'package:abc_quran/models/reciter.dart';
import 'package:abc_quran/providers/player/player_provider.dart';
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

  void setReciter(ReciterModel reciter) async {
    if (reciter.id != state.id) {
      state = reciter;

      // Reflect changes on player data
      await _ref.read(playerProvider.notifier).refreshPlayer();
    }
  }
}
