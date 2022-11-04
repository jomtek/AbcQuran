import 'package:abc_quran/models/sura.dart';

class SuraMenuState {
  final List<SuraModel> suras;

  SuraMenuState({required this.suras});

  factory SuraMenuState.initial() {
    return SuraMenuState(suras: []);
  }

  SuraMenuState copyWith({List<SuraModel>? suras}) {
    return SuraMenuState(suras: suras ?? this.suras);
  }
}
