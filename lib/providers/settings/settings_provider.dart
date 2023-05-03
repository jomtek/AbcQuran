import 'dart:convert';
import 'dart:io';

import 'package:abc_quran/providers/text/quran_text_provider.dart';
import 'package:abc_quran/ui/app/views/quran/read/mushaf/state/mushaf_provider.dart';
import 'package:abc_quran/ui/app/views/quran/read/text/state/text_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import 'settings_state.dart';

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier(ref);
});

class SettingsNotifier extends StateNotifier<SettingsState> {
  final StateNotifierProviderRef<SettingsNotifier, SettingsState> _ref;

  SettingsNotifier(this._ref) : super(SettingsState.initial()) {
    // When the app starts, settings should be automatically loaded from the disk
    _loadSettingsFromDisk();
  }

  Future _loadSettingsFromDisk() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final file = File(docsDir.path + r"\AbcQuran\settings.json");
    if (!await file.exists()) {
      await file.create(recursive: true);
      await file.writeAsString(jsonEncode(state.toJson()));
    } else {
      final data = await file.readAsString();
      final json = jsonDecode(data);
      state = SettingsState.fromJson(json);
      // TODO: find a more clever solution to update the UI
      _ref.read(quranTextProvider.notifier).reload();
    }
  }

  // Always fire and forget, for performance reasons
  Future flushSettings() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final file = File(docsDir.path + r"\AbcQuran\settings.json");
    await file.writeAsString(jsonEncode(state.toJson()));
  }

  void setShowMushaf(bool showMushaf) async {
    if (showMushaf) {
      _ref.read(mushafProvider.notifier).reloadPageCouple();
    } else {
      await _ref.read(textProvider.notifier).reloadSura();
    }

    state = state.copyWith(showMushaf: showMushaf);
    flushSettings();
  }

  void setAppLanguage(String id) {
    state = state.copyWith(languageId: id);
    flushSettings();
  }

  void setQuranLanguage(String id) {
    state = state.copyWith(translationId: id);
    _ref.read(textProvider.notifier).reloadSura();
    flushSettings();
  }
}
