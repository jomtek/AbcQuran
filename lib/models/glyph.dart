class Glyph {
  final String text;
  final int page;
  final int sura;
  final int? verse;
  final bool isSmall;

  Glyph(this.text, this.page, this.sura, this.verse, {this.isSmall = false});
}