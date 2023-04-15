import 'package:abc_quran/models/glyph.dart';
import 'package:flutter/material.dart';

class TextState {
  final List<String> loadedVerses;
  final List<List<Glyph>> loadedGlyphs;

  // Keep the scroll state
  final ScrollController scrollController;

  TextState(
      {required this.loadedVerses,
      required this.loadedGlyphs,
      required this.scrollController});

  factory TextState.initial() {
    return TextState(
        loadedVerses: [],
        loadedGlyphs: [],
        scrollController: ScrollController());
  }

  TextState copyWith(
      {List<String>? loadedVerses,
      List<List<Glyph>>? loadedGlyphs,
      ScrollController? scrollController}) {
    return TextState(
        loadedVerses: loadedVerses ?? this.loadedVerses,
        loadedGlyphs: loadedGlyphs ?? this.loadedGlyphs,
        scrollController: scrollController ?? this.scrollController);
  }
}
