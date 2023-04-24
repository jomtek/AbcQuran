import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html/parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/glyph.dart';

final quranMushafServiceProvider = Provider((ref) => QuranMushafService());

// This service fulfills most mushaf quran needs.
// It provides essential text data for displaying the interactive Madani mushaf.
class QuranMushafService {
  Database? db;

  Future _init() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final path = docsDir.path + r"\AbcQuran\db\glyphmap.db";

    final exists = await databaseExists(path);
    if (!exists) {
      await Directory(dirname(path)).create(recursive: true);

      ByteData data = await rootBundle.load("assets/db/glyphmap.db");
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);
    }

    db = await openDatabase(path, readOnly: true);
  }

  // Returns 15 lists of glyphs that draw the 15 lines of the mushaf page
  Future<List<List<Glyph>>> getPageGlyphs(int page) async {
    if (db == null) {
      await _init();
    }

    final pageAyahsQuery = await db!
        .rawQuery("SELECT ayah,text FROM sura_ayah_page_text WHERE page=$page");
    final query = await db!.rawQuery(
        "SELECT page,sura,ayah,text FROM madani_page_text WHERE page=$page");

    var lines = <List<Glyph>>[];
    for (final line in query) {
      final text = line["text"] as String;
      final glyphs = <Glyph>[];

      for (var glyph in parseFragment(text).text!.runes) {
        int? verse = line["ayah"] as int?;

        // Unify glyphs by the ayah they belong to
        if (![null, 0].contains(verse)) {
          for (final ayah in pageAyahsQuery) {
            final text = parseFragment(ayah["text"] as String).text!;
            if (text.contains(String.fromCharCode(glyph))) {
              verse = ayah["ayah"] as int;
              break;
            }
          }
        }

        glyphs.add(Glyph(
            String.fromCharCode(glyph), page, line["sura"] as int, verse,
            isSmall: page == 1 || page == 2));
      }

      lines.add(glyphs);
    }

    if (lines.length == 8) {
      // In pages 1 and 2, a line padding is necessary
      lines = <List<Glyph>>[[], [], []] +
          lines /*8 lines*/ +
          <List<Glyph>>[[], [], [], []];
    }

    return lines;
  }

  Future<List<List<Glyph>>> getSuraGlyphs(int sura) async {
    if (db == null) {
      await _init();
    }

    final query = await db!.rawQuery(
        "SELECT text,page,ayah FROM sura_ayah_page_text WHERE sura=$sura ORDER BY ayah ASC");

    var verses = <List<Glyph>>[];
    for (final verse in query) {
      var glyphs = <Glyph>[];
      if (verse["ayah"] != null) {
        for (var glyph in parseFragment(verse["text"]).text!.runes) {
          glyphs.add(Glyph(String.fromCharCode(glyph), verse["page"] as int,
              sura, verse["ayah"] as int));
        }
        verses.add(glyphs);
      }
    }

    return verses;
  }

  Future<int> getSuraPage(int sura) async {
    if (db == null) {
      await _init();
    }

    final query = await db!.rawQuery(
        "SELECT page FROM madani_page_text WHERE sura=$sura AND ayah IS NULL");
    final page = query[0]["page"] as int;
    return page;
  }
}
