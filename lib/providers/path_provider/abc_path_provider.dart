import 'dart:io';

import 'package:abc_quran/providers/path_provider/abc_path_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

final abcPathProvider =
    StateNotifierProvider<AbcPathNotifier, AbcPathState>((ref) {
  return AbcPathNotifier();
});

class AbcPathNotifier extends StateNotifier<AbcPathState> {
  AbcPathNotifier() : super(AbcPathState.initial()) {
    initState();
  }

  void initState() async {
    state = state.copyWith(
        localFontsFolder: await _localFontsFolder,
        localTranslationsFolder: await _localTranslationsFolder);
  }

  Future<String> get _localFontsFolder async {
    final Directory cacheDirectory = await getApplicationDocumentsDirectory();

    final String directory = "${cacheDirectory.path}/AbcQuran/cache/mushaf";
    if (!await Directory(directory).exists()) {
      Directory(directory).create(recursive: true);
    }

    return directory;
  }

  Future<String> get _localTranslationsFolder async {
    final docsDir = await getApplicationDocumentsDirectory();
    final dir = "${docsDir.path}/AbcQuran/cache/text";

    if (!await Directory(dir).exists()) {
      Directory(dir).create(recursive: true);
    }

    return dir;
  }
}
