class AbcPathState {
  final String localFontsFolder;
  final String localTranslationsFolder;

  AbcPathState(
      {required this.localFontsFolder, required this.localTranslationsFolder});

  factory AbcPathState.initial() {
    return AbcPathState(localFontsFolder: "", localTranslationsFolder: "");
  }

  AbcPathState copyWith(
      {String? localFontsFolder,
      String? localTranslationsFolder}) {
    return AbcPathState(
        localFontsFolder: localFontsFolder ?? this.localFontsFolder,
        localTranslationsFolder:
            localTranslationsFolder ?? this.localTranslationsFolder);
  }
}
