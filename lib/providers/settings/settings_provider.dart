import 'package:abc_quran/ui/app/views/quran/read/mushaf/state/mushaf_provider.dart';
import 'package:abc_quran/ui/app/views/quran/read/text/state/text_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'settings_state.dart';

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier(ref);
});

class SettingsNotifier extends StateNotifier<SettingsState> {
  final StateNotifierProviderRef<SettingsNotifier, SettingsState> _ref;

  SettingsNotifier(this._ref) : super(SettingsState.initial());

  void setShowMushaf(bool showMushaf) async {
    if (showMushaf) {
      _ref.read(mushafProvider.notifier).reloadPageCouple();
    } else {
      await _ref.read(textProvider.notifier).reloadSura();
    }

    state = state.copyWith(showMushaf: showMushaf);
  }

  void setAppLanguage(String id) {
    state = state.copyWith(languageId: id);
  }

  void setQuranLanguage(String id) {
    state = state.copyWith(translationId: id);
    _ref.read(textProvider.notifier).reloadSura();
  }
}
