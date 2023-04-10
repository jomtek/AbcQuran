class SettingsState {
  final bool showMushaf;

  SettingsState({required this.showMushaf});

  factory SettingsState.initial() {
    return SettingsState(
        showMushaf: false,
        );
  }

  SettingsState copyWith(
      {bool? showMushaf}) {
    return SettingsState(
        showMushaf: showMushaf ?? this.showMushaf);
  }
}
