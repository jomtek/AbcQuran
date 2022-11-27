import 'package:abc_quran/models/glyph.dart';

class MushafState {
  List<List<Glyph>> pageGlyphs;

  MushafState(
      {required this.pageGlyphs});

  factory MushafState.initial() {
    return MushafState(pageGlyphs: []);
  }

  MushafState copyWith(
      {List<List<Glyph>>? pageGlyphs}) {
    return MushafState(
        pageGlyphs: pageGlyphs ?? this.pageGlyphs);
  }
}
