import 'package:abc_quran/models/glyph.dart';

class MushafState {
  List<List<Glyph>> rightPageGlyphs;
  List<List<Glyph>> leftPageGlyphs;
  int hoveredVerse;
  int hoveredPage;

  MushafState(
      {required this.rightPageGlyphs,
      required this.leftPageGlyphs,
      required this.hoveredVerse,
      required this.hoveredPage});

  factory MushafState.initial() {
    return MushafState(
        rightPageGlyphs: [],
        leftPageGlyphs: [],
        hoveredVerse: -1,
        hoveredPage: -1);
  }

  MushafState copyWith(
      {List<List<Glyph>>? rightPageGlyphs,
      List<List<Glyph>>? leftPageGlyphs,
      int? hoveredVerse,
      int? hoveredPage}) {
    return MushafState(
        rightPageGlyphs: rightPageGlyphs ?? this.rightPageGlyphs,
        leftPageGlyphs: leftPageGlyphs ?? this.leftPageGlyphs,
        hoveredVerse: hoveredVerse ?? this.hoveredVerse,
        hoveredPage: hoveredPage ?? this.hoveredPage);
  }
}
