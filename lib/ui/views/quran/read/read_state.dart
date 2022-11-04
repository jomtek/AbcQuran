
import 'package:abc_quran/models/revelation_type.dart';
import 'package:abc_quran/models/sura.dart';

class ReadState {
  final SuraModel sura;

  ReadState(
      {required this.sura});

  factory ReadState.initial() {
    return ReadState(sura: SuraModel(0,0,"","",RevelationType.mh));
  }

  ReadState copyWith(
      {SuraModel? sura}) {
    return ReadState(
        sura: sura ?? this.sura);
  }
}
