import 'package:audioplayers/audioplayers.dart';

class PlayerState2 {
  final AudioPlayer player;
  final bool isPlaying;
  final bool wasCompleted;
  final String sourceUrl;
  final List<String> timecodes;
  final double playbackSpeed;

  // Loop mode
  final bool isLooping;
  final int loopStartVerse;
  final int loopEndVerse;

  PlayerState2({
    required this.player,
    required this.isPlaying,
    required this.wasCompleted,
    required this.sourceUrl,
    required this.timecodes,
    required this.playbackSpeed,
    required this.isLooping,
    required this.loopStartVerse,
    required this.loopEndVerse,
  });

  factory PlayerState2.initial() {
    return PlayerState2(
        player: AudioPlayer(),
        isPlaying: false,
        wasCompleted: false,
        sourceUrl: "",
        timecodes: [],
        playbackSpeed: 1,
        isLooping: false,
        loopStartVerse: 1,
        loopEndVerse: 1);
  }

  PlayerState2 copyWith({
    AudioPlayer? player,
    bool? isPlaying,
    bool? wasCompleted,
    String? sourceUrl,
    List<String>? timecodes,
    double? playbackSpeed,
    bool? isLooping,
    int? loopStartVerse,
    int? loopEndVerse,
  }) {
    return PlayerState2(
        player: player ?? this.player,
        isPlaying: isPlaying ?? this.isPlaying,
        wasCompleted: wasCompleted ?? this.wasCompleted,
        sourceUrl: sourceUrl ?? this.sourceUrl,
        timecodes: timecodes ?? this.timecodes,
        playbackSpeed: playbackSpeed ?? this.playbackSpeed,
        isLooping: isLooping ?? this.isLooping,
        loopStartVerse: loopStartVerse ?? this.loopStartVerse,
        loopEndVerse: loopEndVerse ?? this.loopEndVerse);
  }
}
