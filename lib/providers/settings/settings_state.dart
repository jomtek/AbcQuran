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

  static fromJson(Map<String, dynamic> json) => SettingsState(
      showMushaf: json["show_mushaf"] as bool,
      languageId: json["language_id"] as String,
      translationId: json["translation_id"] as String);

  Map<String, dynamic> toJson() => {
        'show_mushaf': showMushaf,
        'language_id': languageId,
        'translation_id': translationId
      };
}
