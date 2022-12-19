class TextState {
  final List<String> loadedVerses;

  TextState(
      {required this.loadedVerses});

  factory TextState.initial() {
    return TextState(loadedVerses: []);
  }

  TextState copyWith(
      {List<String>? loadedVerses}) {
    return TextState(
        loadedVerses: loadedVerses ?? this.loadedVerses);
  }
}
