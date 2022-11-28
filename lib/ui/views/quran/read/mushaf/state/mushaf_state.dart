import 'package:abc_quran/models/glyph.dart';

class MushafState {
  List<List<Glyph>> pageGlyphs;
  int hoveredVerse;
  int hoveredSura;  

  MushafState(
      {required this.pageGlyphs, required this.hoveredVerse, required this.hoveredSura});

  factory MushafState.initial() {
    return MushafState(pageGlyphs: [], hoveredVerse: -1, hoveredSura: -1);
  }

  MushafState copyWith(
      {List<List<Glyph>>? pageGlyphs, int? hoveredVerse, int? hoveredSura}) {
    return MushafState(
        pageGlyphs: pageGlyphs ?? this.pageGlyphs, hoveredVerse: hoveredVerse ?? this.hoveredVerse, hoveredSura: hoveredSura ?? this.hoveredSura);
  }
}
