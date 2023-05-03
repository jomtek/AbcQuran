import 'package:abc_quran/providers/player/player_provider.dart';
import 'package:abc_quran/providers/reciter/current_reciter_provider.dart';
import 'package:abc_quran/providers/sura/current_sura_provider.dart';
import 'package:abc_quran/ui/app/api_data.dart';
import 'package:abc_quran/ui/app/views/quran/read/cursor/cursor_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'contribute_state.dart';

final contributeVmProvider =
    StateNotifierProvider<ContributeNotifier, ContributeState>((ref) {
  return ContributeNotifier(ref);
});

class ContributeNotifier extends StateNotifier<ContributeState> {
  final StateNotifierProviderRef<ContributeNotifier, ContributeState> _ref;

  ContributeNotifier(this._ref) : super(ContributeState.initial());

  void setIsContributing(bool isContributing) async {
    if (_ref.read(playerProvider).timecodes.isEmpty) {
      await _ref
          .read(playerProvider.notifier)
          .refreshPlayer(keepPosition: true);
    }
    state = state.copyWith(isContributing: isContributing);
  }

  void setCurrentTime(int time) {
    state = state.copyWith(currentTime: time);
  }

  void refreshNewTimecodes() {
    final timecodes = _ref.read(playerProvider).timecodes;
    state = state.copyWith(
        newTimecodes: List.filled(timecodes.length, -1), currentVerse: 0);
  }

  void moveCursor(int verse) {
    final sura = _ref.read(currentSuraProvider);
    if (verse + sura.getFirstVerseId() <= sura.length) {
      state = state.copyWith(currentVerse: verse);
      _ref.read(cursorProvider.notifier).moveBookmarkTo(
          verse + sura.getFirstVerseId(), -1,
          resolvePage: true);
    }
  }

  void saveTimecode() {
    final tc = state.newTimecodes;
    tc[state.currentVerse] = state.currentTime;
    moveCursor(state.currentVerse + 1);
    state = state.copyWith(newTimecodes: tc);
  }

  void gotoPreviousTimecode() {
    if (state.currentVerse - 1 >
        _ref.read(currentSuraProvider).getFirstVerseId()) {
      final durationMs =
          Duration(milliseconds: state.newTimecodes[state.currentVerse - 2]);
      _ref.read(playerProvider).player.seek(durationMs);
      moveCursor(state.currentVerse - 1);

      final tc = state.newTimecodes;
      tc[state.currentVerse] = -1;
      state = state.copyWith(newTimecodes: tc);
    } else {
      final tc = state.newTimecodes;
      tc[state.currentVerse] = -1;
      state = state.copyWith(newTimecodes: tc);

      _ref.read(playerProvider).player.seek(const Duration(seconds: 0));
      state = state.copyWith(currentVerse: 0);
    }
  }

  void skipTimecode() {
    final oldTimecodes = _ref.read(playerProvider).timecodes;
    final oldTimecode = int.parse(oldTimecodes[state.currentVerse]);
    final tc = state.newTimecodes;
    tc[state.currentVerse] = oldTimecode;
    state = state.copyWith(newTimecodes: tc);
    moveCursor(state.currentVerse + 1);

    _ref.read(playerProvider).player.seek(Duration(milliseconds: oldTimecode));
  }

  void submit() async {
    final http.Client httpClient = http.Client();

    final reciter = _ref.read(currentReciterProvider);
    final sura = _ref.read(currentSuraProvider);
    final oldTimecodes = _ref.read(playerProvider).timecodes;

    state = state.copyWith(contributionsSent: 0, isSending: true);

    int contributionsSent = 0;
    for (int i = 0; i < state.newTimecodes.length; i++) {
      final newTimecode = state.newTimecodes[i];
      final oldTimecode =
          oldTimecodes[i].isEmpty ? -1 : int.parse(oldTimecodes[i]);
      if (newTimecode != -1 && newTimecode != oldTimecode) {
        // Send the contribution
        final contributionUri = Uri.parse(
            "${ApiData.baseUrl}:5000/contribute?reciter=${reciter.id}&sura=${sura.id}&cursor=$i&timecode=$newTimecode");

        http.Response response;
        try {
          response = await httpClient.get(contributionUri);
        } catch (e) {
          throw Exception("Failed to send contribution");
        }
        if (response.statusCode == 200) {
          contributionsSent += 1;
          state = state.copyWith(contributionsSent: contributionsSent);
        }
      }
    }

    Future.delayed(const Duration(seconds: 2));

    state = state.copyWith(isSending: false);
  }
}
