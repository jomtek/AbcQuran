import 'package:audioplayers/audioplayers.dart';

class PlayerState2 {
  final AudioPlayer player;
  final String sourceUrl;
  final List<String> timecodes;

  PlayerState2(
      {required this.player, required this.sourceUrl, required this.timecodes});

  factory PlayerState2.initial() {
    return PlayerState2(
      player: AudioPlayer(),
      sourceUrl: "",
      timecodes: [],
    );
  }

  PlayerState2 copyWith(
      {AudioPlayer? player, String? sourceUrl, List<String>? timecodes}) {
    return PlayerState2(
        player: player ?? this.player,
        sourceUrl: sourceUrl ?? this.sourceUrl,
        timecodes: timecodes ?? this.timecodes);
  }
}
