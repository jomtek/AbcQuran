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
    state = state.copyWith(showMushaf: showMushaf);
  }
}