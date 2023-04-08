import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

final mushafFontServiceProvider = Provider((ref) => MushafFontService());

// This service fulfills visual mushaf needs.
// It provides font data for rendering the Madani mushaf, while smartly managing font caching.
class MushafFontService {
  final Set<String> _loadedPages = {};
  final http.Client _httpClient = http.Client();

  Future<String> get _localFontFolder async {
    final Directory cacheDirectory = await getApplicationDocumentsDirectory();

    final String directory = "${cacheDirectory.path}\\AbcQuran\\cache\\mushaf";
    if (!await Directory(directory).exists()) {
      Directory(directory).create(recursive: true);
    }

    return directory;
  }

  Future<void> loadPage(String page) async {
    if (_loadedPages.contains(page)) {
      return;
    } else {
      _loadedPages.add(page);
    }

    ByteData? pageBytes = await _fetchPageFromDisk(page);
    pageBytes ??= await _fetchPageFromApi(page);

    await _loadFontByteData(page, pageBytes);
  }

  Future _loadFontByteData(String page, ByteData byteData) async {
    final fontLoader = FontLoader(page.toString());
    fontLoader.addFont(Future.value(byteData));
    await fontLoader.load();
  }

  Future<ByteData?> _fetchPageFromDisk(String page) async {
    final fontFolder = await _localFontFolder;
    final file = File("$fontFolder\\$page.ttf");

    if (await file.exists()) {
      List<int> contents = await file.readAsBytes();
      if (contents.isNotEmpty) {
        return ByteData.view(Uint8List.fromList(contents).buffer);
      }
    }

    return null;
  }

  Future<ByteData> _fetchPageFromApi(String page) async {
    final paddedPageNum = page.toString().padLeft(3, "0");

    var fontName = "QCF_P$paddedPageNum";
    if (page == "BSML") {
      fontName = "QCF_BSML";
    }

    final fontUri = Uri.parse(
        "http://141.145.204.116/mushaf/fonts/$fontName.TTF");

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
