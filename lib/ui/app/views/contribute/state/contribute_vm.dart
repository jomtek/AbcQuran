import 'package:abc_quran/providers/player/player_provider.dart';
import 'package:abc_quran/providers/sura/current_sura_provider.dart';
import 'package:abc_quran/providers/sura/sura_list_provider.dart';
import 'package:abc_quran/ui/app/views/quran/read/cursor/cursor_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'contribute_state.dart';

final contributeVmProvider =
    StateNotifierProvider<ContributeNotifier, ContributeState>((ref) {
  return ContributeNotifier(ref);
});

class ContributeNotifier extends StateNotifier<ContributeState> {
    final StateNotifierProviderRef<ContributeNotifier, ContributeState> _ref;

  ContributeNotifier(this._ref) : super(ContributeState.initial());

  void setIsContributing(bool isContributing) {
    state = state.copyWith(isContributing: isContributing);
  }

  void setCurrentTime(int time) {
    state = state.copyWith(currentTime: time);
  }

  void refreshNewTimecodes() {
    final timecodes = _ref.read(playerProvider).timecodes;
    state = state.copyWith(newTimecodes: List.filled(timecodes.length, -1));
  }

  void saveTimecode() {
    final sura = _ref.read(currentSuraProvider);
    final cursor = _ref.read(cursorProvider);
    final tc = state.newTimecodes;
    tc[cursor.bookmarkStop - sura.getFirstVerseId()] = state.currentTime; 
    state = state.copyWith(newTimecodes: tc);
  }
}
