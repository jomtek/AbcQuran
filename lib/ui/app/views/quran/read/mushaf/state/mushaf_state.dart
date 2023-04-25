import 'package:abc_quran/models/glyph.dart';

class MushafState {
  List<List<Glyph>> rightPageGlyphs;
  List<List<Glyph>> leftPageGlyphs;
  int hoveredVerse;
  int hoveredSura;

  MushafState(
      {required this.rightPageGlyphs,
      required this.leftPageGlyphs,
      required this.hoveredVerse,
      required this.hoveredSura});

  factory MushafState.initial() {
    return MushafState(
        rightPageGlyphs: [],
        leftPageGlyphs: [],
        hoveredVerse: -1,
        hoveredSura: -1);
  }

  MushafState copyWith(
      {List<List<Glyph>>? rightPageGlyphs,
      List<List<Glyph>>? leftPageGlyphs,
      int? hoveredVerse,
      int? hoveredSura}) {
    return MushafState(
        rightPageGlyphs: rightPageGlyphs ?? this.rightPageGlyphs,
        leftPageGlyphs: leftPageGlyphs ?? this.leftPageGlyphs,
        hoveredVerse: hoveredVerse ?? this.hoveredVerse,
        hoveredSura: hoveredSura ?? this.hoveredSura);
  }
}
