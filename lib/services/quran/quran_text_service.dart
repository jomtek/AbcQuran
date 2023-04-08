import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

final quranTextServiceProvider = Provider((ref) => QuranTextService());

// This service fulfills all textual quran needs.
// It provides data for the translated versions of the holy book.
class QuranTextService {
  Future<String> get _localTranslationsFolder async {
    final docsDir = await getApplicationDocumentsDirectory();
    final dir = docsDir.path + r"\AbcQuran\db\text";

    if (!await Directory(dir).exists()) {
      Directory(dir).create(recursive: true);
    }

    return dir;
  }

  Future<List<String>> getAyahsFromSura(int sura) async {
    final translationsFolder = await _localTranslationsFolder;
    return await File("$translationsFolder\\fr.hamidullah\\$sura").readAsLines();
  }
}