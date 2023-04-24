import 'package:abc_quran/ui/views/quran/read/mushaf/state/mushaf_provider.dart';
import 'package:abc_quran/ui/views/quran/read/text/state/text_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'settings_state.dart';

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier(ref);
});

class SettingsNotifier extends StateNotifier<SettingsState> {
  final StateNotifierProviderRef<SettingsNotifier, SettingsState> _ref;

  SettingsNotifier(this._ref) : super(SettingsState.initial());

  void setShowMushaf(bool showMushaf) {
    if (showMushaf) {
      _ref.read(mushafProvider.notifier).reloadPageCouple();
    }
    else {
      _ref.read(textProvider.notifier).reloadSura();
    }
    state = state.copyWith(showMushaf: showMushaf);
  }
}
