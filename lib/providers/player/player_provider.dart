import 'dart:math';

import 'package:abc_quran/providers/reciter/current_reciter_provider.dart';
import 'package:abc_quran/providers/sura/current_sura_provider.dart';
import 'package:abc_quran/ui/app/views/quran/read/cursor/cursor_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'player_state2.dart';

final playerProvider =
    StateNotifierProvider<PlayerNotifier, PlayerState2>((ref) {
  return PlayerNotifier(ref);
});

// This provider provides everything thats necessary for streaming the quran
// Most of the methods it contains, such as `refreshPlayer` or `seek`, must be called externally
class PlayerNotifier extends StateNotifier<PlayerState2> {
  final StateNotifierProviderRef<PlayerNotifier, PlayerState2> _ref;
  final http.Client _httpClient = http.Client();

  PlayerNotifier(this._ref) : super(PlayerState2.initial()) {
    state.player.onPositionChanged.listen(onPositionChanged);
  }

  // Should be called in case the reciter or sura changes.
  // What it does : build a new source url and refresh the mp3 offsets
  Future refreshPlayer() async {
    bool wasPlaying = false;
    if (state.isPlaying) {
      wasPlaying = true;
      play(); // pause
    }

    final sura = _ref.read(currentSuraProvider);
    final reciter = _ref.read(currentReciterProvider);
    final source = reciter.buildSourceFor(sura);
    state = state.copyWith(sourceUrl: source);

    // Fetch new mp3 offsets
    final offsetsUri = Uri.parse(
        "http://141.145.204.116/reciters/${reciter.id}/timecodes/${sura.getPaddedId()}.txt");

    http.Response response;
    try {
      response = await _httpClient.get(offsetsUri);
    } catch (e) {
      throw Exception("Failed to load mp3 offsets for reciter");
    }

    if (response.statusCode == 200) {
      final timecodes = response.body.split("\n");
      state = state.copyWith(timecodes: timecodes);
    }

    if (wasPlaying) {
      play();
    }
  }

  Future seekTo(int verse) async {
    if (state.timecodes.length < verse) {
      await refreshPlayer();
    }

    final sura = _ref.read(currentSuraProvider);
    final tcIndex = verse - 1 - sura.getFirstVerseId();
    int timecode;
    if (tcIndex < 0) {
      timecode = 0;
    } else {
      timecode = int.parse(
          state.timecodes[max(verse - 1 - sura.getFirstVerseId(), 0)]);
    }
    await state.player.seek(Duration(milliseconds: timecode));
  }

  void onPositionChanged(Duration pos) {
    final sura = _ref.read(currentSuraProvider);
    final stop = _ref.read(cursorProvider).bookmarkStop;
    for (int i = state.timecodes.length;
        i > stop - sura.getFirstVerseId();
        i--) {
      final tc = state.timecodes[i - 1];
      // TODO: how costly are the int.parse operations ? should I cast first ?
      if (pos.inMilliseconds > int.parse(tc)) {
        _ref.read(cursorProvider.notifier).moveBookmarkTo(
            i + sura.getFirstVerseId(), _ref.read(cursorProvider).page);
        break;
      }
    }
  }

  void play() async {
    if (!state.isPlaying) {
      state = state.copyWith(isPlaying: true);
      if (state.timecodes.isEmpty) {
        await refreshPlayer();
      }

      // Fire and forget
      state.player.play(UrlSource(state.sourceUrl));
    } else {
      state = state.copyWith(isPlaying: false);
      state.player.pause();
    }
  }
}