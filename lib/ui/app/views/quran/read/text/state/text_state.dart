import 'package:abc_quran/models/glyph.dart';

class TextState {
  final List<String> loadedVerses;
  final List<List<Glyph>> loadedGlyphs;
  final String basmalaText;
  final List<Glyph> basmalaGlyphs;

  TextState({
    required this.loadedVerses,
    required this.loadedGlyphs,
    required this.basmalaText,
    required this.basmalaGlyphs,
  });

  factory TextState.initial() {
    return TextState(
        loadedVerses: [], loadedGlyphs: [], basmalaText: "", basmalaGlyphs: []);
  }

  TextState copyWith(
      {List<String>? loadedVerses,
      List<List<Glyph>>? loadedGlyphs,
      String? basmalaText,
      List<Glyph>? basmalaGlyphs}) {
    return TextState(
      loadedVerses: loadedVerses ?? this.loadedVerses,
      loadedGlyphs: loadedGlyphs ?? this.loadedGlyphs,
      basmalaText: basmalaText ?? this.basmalaText,
      basmalaGlyphs: basmalaGlyphs ?? this.basmalaGlyphs,
    );
  }
}
