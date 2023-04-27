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
  }

  Future seekTo(int verse) async {
    final timecode = state.timecodes[verse - 1];
    await state.player.seek(Duration(milliseconds: int.parse(timecode)));
  }

  void onPositionChanged(Duration pos) {
    final stop = _ref.read(cursorProvider).bookmarkStop;
    for (int i = state.timecodes.length; i > stop; i--) {
      final tc = state.timecodes[i - 1];
      // TODO: how costly are the int.parse operations ? should I cast first ?
      if (pos.inMilliseconds > int.parse(tc)) {
        print("Moved to $tc");
        _ref
            .read(cursorProvider.notifier)
            .moveBookmarkTo(i, _ref.read(cursorProvider).page);
        break;
      }
    }
  }

  void play() async {
    if (state.timecodes.isEmpty) {
      await refreshPlayer();
    }

    // Fire and forget
    state.player.play(UrlSource(state.sourceUrl));
  }
}
