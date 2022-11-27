import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

final mushafFontServiceProvider = Provider((ref) => MushafFontService());

// This service fulfills visual mushaf needs.
// It provides font data for rendering the Madani mushaf,
// while smartly managing font caching.
class MushafFontService {
  Set<int> _loadedPages = {};
  http.Client _httpClient = http.Client();

  Future<String> get _localFontFolder async {
    final Directory cacheDirectory = await getApplicationDocumentsDirectory();

    final String directory = "${cacheDirectory.path}/mushaf_cache";
    if (!await Directory(directory).exists()) {
      Directory(directory).create(recursive: true);
    }

    return directory;
  }

  Future<void> loadPage(int page) async {
    if (_loadedPages.contains(page)) {
      return;
    } else {
      _loadedPages.add(page);
    }

    final pageBytes = await _fetchPageFromApi(page);
    await _loadFontByteData(page, pageBytes);
  }

  Future<void> _loadFontByteData(int page, ByteData byteData) async {
    final fontLoader = FontLoader(page.toString());
    fontLoader.addFont(Future.value(byteData));
    await fontLoader.load();
  }

  Future<ByteData> _fetchPageFromApi(int page) async {
    final paddedPageNum = page.toString().padLeft(3, "0");
    final fontUri = Uri.parse(
        "http://141.145.204.116/mushaf/fonts/QCF_P$paddedPageNum.TTF");

    // Fetch font from the api
    http.Response response;
    try {
      response = await _httpClient.get(fontUri);
    } catch (e) {
      throw Exception("Failed to load font for page $page");
    }

    if (response.statusCode == 200) {
      // Cache the downloaded font
      final fontFolder = await _localFontFolder;
      final file = File("$fontFolder/$page.ttf");
      await file.writeAsBytes(response.bodyBytes);

      return ByteData.view(response.bodyBytes.buffer);
    } else {
      throw Exception("Failed to load font for page $page");
    }
  }
}
