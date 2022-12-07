import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html/parser.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../models/glyph.dart';

final quranMushafServiceProvider = Provider((ref) => QuranMushafService());

// This service fulfills most mushaf quran needs.
// It provides essential text data for displaying the interactive Madani mushaf.
class QuranMushafService {
  Database? db;

  Future _init() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "glyphmap_asset_example.db");

    final exists = await databaseExists(path);
    if (!exists) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data = await rootBundle.load(join("assets/db", "glyphmap.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);
    }

    db = await openDatabase(path, readOnly: true);
  }

  Future<List<String>> _getAyahsFromPage(int page) async {
    final query = await db!
        .rawQuery("SELECT ayah,text FROM sura_ayah_page_text WHERE page=$page");
    var result = <String>[];
    for (final ayah in query) {
      final text = parseFragment(ayah["text"] as String).text!;
      result.add(text);
    }
    return result;
  }

  // Returns 15 lists of glyphs that draw the 15 lines of the mushaf page
  Future<List<List<Glyph>>> getPageGlyphs(int page) async {
    if (db == null) {
      await _init();
    }

    final pageAyahs = await _getAyahsFromPage(page);
    final query = await db!.rawQuery(
        "SELECT page,sura,ayah,text FROM madani_page_text WHERE page=$page");

    var lines = <List<Glyph>>[];
    for (final line in query) {
      final text = line["text"] as String;
      final glyphs = <Glyph>[];

      for (var glyph in parseFragment(text).text!.runes) {
        int? verse = line["ayah"] as int?;

        if (![null, 0].contains(verse)) {
          for (int i = 1; i <= pageAyahs.length; i++) {
            if (pageAyahs[i - 1].contains(String.fromCharCode(glyph))) {
              verse = i;
            }
          }
        }

        glyphs.add(Glyph(
            String.fromCharCode(glyph), page, line["sura"] as int, verse));
      }

      lines.add(glyphs);
    }

    return lines;
  }

  //
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
