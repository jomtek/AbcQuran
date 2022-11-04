import 'package:abc_quran/models/sura.dart';

class MenuState {
  final List<Sura> suras;

  MenuState({required this.suras});

  factory MenuState.initial() {
    return MenuState(suras: []);
  }

  MenuState copyWith({List<Sura>? suras}) {
    return MenuState(suras: suras ?? this.suras);
  }
}
