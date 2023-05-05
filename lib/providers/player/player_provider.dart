import 'dart:math';

import 'package:abc_quran/providers/reciter/current_reciter_provider.dart';
import 'package:abc_quran/providers/sura/current_sura_provider.dart';
import 'package:abc_quran/ui/app/api_data.dart';
import 'package:abc_quran/ui/app/views/contribute/state/contribute_vm.dart';
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
// (!) DEVELOPER NOTE : Most of the time, I found out that player-related bugs can be fixed
//                      simply by pausing/stopping the player, operating, then restarting it.
// TODO: Address any safety concern. Code looks a bit messy/unstable in its actual form.

class PlayerNotifier extends StateNotifier<PlayerState2> {
  final StateNotifierProviderRef<PlayerNotifier, PlayerState2> _ref;
  final http.Client _httpClient = http.Client();

  PlayerNotifier(this._ref) : super(PlayerState2.initial()) {
    state.player.onPositionChanged.listen(onPositionChanged);
    state.player.onPlayerStateChanged.listen(onPlayerStateChanged);
  }

  // Should be called in case the reciter or sura changes.
  // What it does : build a new source url and refresh the mp3 offsets
  Future refreshPlayer({bool keepPosition = false}) async {
    bool wasPlaying = false;
    if (state.isPlaying) {
      wasPlaying = true;
      await state.player.stop();
    }

    final sura = _ref.read(currentSuraProvider);
    final reciter = _ref.read(currentReciterProvider);
    final source = reciter.buildSourceFor(sura);
    state = state.copyWith(sourceUrl: source);
    state.player.setSourceUrl(source);

    // Fetch new mp3 offsets
    final offsetsUri = Uri.parse(
        "${ApiData.baseUrl}/reciters/${reciter.id}/timecodes/${sura.getPaddedId()}.txt");

    http.Response response;
    try {
      response = await _httpClient.get(offsetsUri);
    } catch (e) {
      throw Exception("Failed to load mp3 offsets for reciter");
    }

    if (response.statusCode == 200) {
      final timecodes = response.body.split("\n");

      // Fix the timecodes by adding or excluding the basmala
      if (reciter.missingBasmala.contains(sura.id)) {
        timecodes.insert(0, "0");
      } else if (reciter.unwantedBasmala.contains(sura.id)) {
        // Suras such as At-Tawba do not need a basmala
        timecodes.removeAt(0);
      }

      state = state.copyWith(timecodes: timecodes);

      _ref.read(contributeVmProvider.notifier).refreshNewTimecodes();
    }

    if (keepPosition) {
      await seekTo(_ref.read(cursorProvider).bookmarkStop);
    }
    if (wasPlaying) {
      play();
    }

    setPlaybackSpeed(state.playbackSpeed);
  }

  Future stop() async {
    await state.player.stop();
  }

  Future seekTo(int verse) async {
    final contributeState = _ref.read(contributeVmProvider);
    if (contributeState.isContributing) {
      return;
    }

    if (state.timecodes.isEmpty) {
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

  void setPlaybackSpeed(double speed) {
    state.player.setPlaybackRate(speed);
    state = state.copyWith(playbackSpeed: speed);
  }

  void onPositionChanged(Duration pos) async {
    _ref.read(contributeVmProvider.notifier).setCurrentTime(pos.inMilliseconds);

    final contributeState = _ref.read(contributeVmProvider);
    final sura = _ref.read(currentSuraProvider);
    final stop = _ref.read(cursorProvider).bookmarkStop;
    for (int i = state.timecodes.length - 1;
        i > stop - sura.getFirstVerseId();
        i--) {
      final tc = state.timecodes[i - 1];

      // TODO: How costly are the int.parse operations ? should I cast first ?
      if (pos.inMilliseconds > int.parse(tc)) {
        int nextVerseNum = i + sura.getFirstVerseId();

        if (nextVerseNum > sura.length) {
          break;
        }
        if (state.isLooping && nextVerseNum > state.loopEndVerse) {
          await seekTo(state.loopStartVerse);
          nextVerseNum = state.loopStartVerse;
        }

        // TODO: Is it messy to await/make an SQL request HERE each time the verse changes ?
        if (!contributeState.isContributing) {
          // If user is actually contributing the timecodes, do not move the bookmark
          print("Seeked after passing $tc. Pos was ${pos.inMilliseconds}");
          _ref
              .read(cursorProvider.notifier)
              .moveBookmarkTo(nextVerseNum, -1, resolvePage: true);
        }

        break;
      }
    }
  }

  void play() async {
    if (!state.isPlaying) {
      if (state.timecodes.isEmpty) {
        await refreshPlayer();
      }
      if (state.wasCompleted) {
        // If sura was completed and user clicks the play button, reset the bookmark
        _ref.read(cursorProvider.notifier).resetBookmark();
        state = state.copyWith(wasCompleted: false);
      }

      // Fire and forget
      state.player.play(UrlSource(state.sourceUrl));
    } else {
      state.player.pause();
    }
  }

  void onPlayerStateChanged(PlayerState pState) {
    if (pState == PlayerState.playing) {
      state = state.copyWith(isPlaying: true);
    } else {
      state = state.copyWith(isPlaying: false);
      if (pState == PlayerState.completed) {
        state = state.copyWith(wasCompleted: true);
      }
    }
  }

  // TODO: create a specific provider for the loop mode
  void toggleLoopMode() {
    state = state.copyWith(isLooping: !state.isLooping);
    if (state.isLooping) {
      // Update the loop range
      state = state.copyWith(
          loopStartVerse: _ref.read(cursorProvider).bookmarkStart == 0
              ? 1
              : _ref.read(cursorProvider).bookmarkStart,
          loopEndVerse: _ref.read(cursorProvider).bookmarkStop);
    }
  }
}
