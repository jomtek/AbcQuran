class SettingsState {
  final bool showMushaf; // Not in the settings tab
  final String languageId; // App language
  final String translationId;

  SettingsState(
      {required this.languageId,
      required this.showMushaf,
      required this.translationId});

  factory SettingsState.initial() {
    return SettingsState(
        showMushaf: true, languageId: "en", translationId: "en.ahmedali");
  }

  SettingsState copyWith(
      {bool? showMushaf, String? languageId, String? translationId}) {
    return SettingsState(
        showMushaf: showMushaf ?? this.showMushaf,
        languageId: languageId ?? this.languageId,
        translationId: translationId ?? this.translationId);
  }
}
