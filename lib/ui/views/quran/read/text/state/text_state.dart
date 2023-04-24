import 'package:abc_quran/models/glyph.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class TextState {
  final List<String> loadedVerses;
  final List<List<Glyph>> loadedGlyphs;

  TextState({required this.loadedVerses, required this.loadedGlyphs});

  factory TextState.initial() {
    return TextState(loadedVerses: [], loadedGlyphs: []);
  }

  TextState copyWith(
      {List<String>? loadedVerses, List<List<Glyph>>? loadedGlyphs}) {
    return TextState(
        loadedVerses: loadedVerses ?? this.loadedVerses,
        loadedGlyphs: loadedGlyphs ?? this.loadedGlyphs);
  }
}
