import 'package:abc_quran/models/glyph.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class TextState {
  final List<List<Glyph>> loadedGlyphs;
  final String basmalaText;
  final List<Glyph> basmalaGlyphs;

  final ItemScrollController scrollController;

  TextState({
    required this.loadedGlyphs,
    required this.basmalaText,
    required this.basmalaGlyphs,
    required this.scrollController,
  });

  factory TextState.initial() {
    return TextState(
        loadedGlyphs: [],
        basmalaText: "",
        basmalaGlyphs: [],
        scrollController: ItemScrollController());
  }

  TextState copyWith(
      {List<List<Glyph>>? loadedGlyphs,
      String? basmalaText,
      List<Glyph>? basmalaGlyphs}) {
    return TextState(
        loadedGlyphs: loadedGlyphs ?? this.loadedGlyphs,
        basmalaText: basmalaText ?? this.basmalaText,
        basmalaGlyphs: basmalaGlyphs ?? this.basmalaGlyphs,
        scrollController: scrollController);
  }
}
